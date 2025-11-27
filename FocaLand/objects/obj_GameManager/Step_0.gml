/// @description CLICS: Cazar y Expandir

// =========================================================
//        PASO 1: CENSO (Contar Focas)
// =========================================================
focas_disponibles = 0;
focas_fuera = 0;

// Contar Foca 1
with (Foca1) { 
    if (estado == "PASEAR" && cooldown_susto <= 0) other.focas_disponibles++; 
    if (estado != "PASEAR") other.focas_fuera++; 
}
// Contar Foca 2
with (Foca2) { 
    if (estado == "PASEAR" && cooldown_susto <= 0) other.focas_disponibles++; 
    if (estado != "PASEAR") other.focas_fuera++; 
}

// Validar cantidad seleccionada
if (cantidad_a_enviar > focas_disponibles) cantidad_a_enviar = focas_disponibles;
if (cantidad_a_enviar < 1 && focas_disponibles > 0) cantidad_a_enviar = 1;


// =========================================================
//        PASO 2: DETECTAR CLICS (Lógica Principal)
// =========================================================
if (mouse_check_button_pressed(mb_left)) {
    
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var ui_click = false; // Bandera para saber si tocamos UI

    // --- A. CLIC EN BOTÓN EXPANSIÓN (Arriba Derecha) ---
    // Usamos las variables definidas en Create (btn_exp_x, etc.)
    if (point_in_rectangle(mx, my, btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h)) {
        
        if (global.pescado_capturado >= costo_expansion) {
            global.pescado_capturado -= costo_expansion; 
            costo_expansion += 10; 
            
            with (obj_Mapa) { nivel_isla++; event_user(0); } 
            show_debug_message("¡Isla Expandida!");
        } else {
            show_debug_message("No hay suficiente pescado.");
        }
        ui_click = true;
    }

    // --- B. CLIC EN MENÚ ESCUADRÓN (Abajo Centro) ---
    if (point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h)) {
        
        if (menu_abierto) {
            // Si está abierto, chequeamos si es RETIRADA o CERRAR
            if (focas_fuera > 0) {
                // Ejecutar Retirada
                with (Foca1) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
                with (Foca2) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
                show_debug_message("¡RETIRADA EJECUTADA!");
            }
            menu_abierto = false; // Cerrar menú
        } 
        else {
            menu_abierto = true; // Abrir menú
        }
        ui_click = true;
    }

    // --- C. CONTROLES DEL PANEL (+ / -) ---
    if (menu_abierto) {
        // Botón [-]
        if (point_in_rectangle(mx, my, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size)) {
            cantidad_a_enviar = max(1, cantidad_a_enviar - 1);
            ui_click = true;
        }
        // Botón [+]
        if (point_in_rectangle(mx, my, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size)) {
            if (cantidad_a_enviar < focas_disponibles) cantidad_a_enviar += 1;
            ui_click = true;
        }
        // Fondo del Panel (Evitar clic en el mapa)
        if (point_in_rectangle(mx, my, panel_x, panel_y, panel_x+panel_w, panel_y+panel_h)) {
            ui_click = true;
        }
    }

    // --- D. ENVIAR FOCAS AL MAPA ---
    // Solo si menú abierto + Clic NO fue en botones + Hay focas
    if (menu_abierto && !ui_click && focas_disponibles > 0) {
        var tx = mouse_x; 
        var ty = mouse_y;
        
        effect_create_above(ef_ring, tx, ty, 1, c_lime);
        
        var lista = ds_list_create();
        with (Foca1) { if (estado=="PASEAR" && cooldown_susto<=0) ds_list_add(lista, id); }
        with (Foca2) { if (estado=="PASEAR" && cooldown_susto<=0) ds_list_add(lista, id); }
        ds_list_shuffle(lista);
        
        var count = 0;
        for (var i=0; i<ds_list_size(lista); i++) {
            if (count >= cantidad_a_enviar) break;
            var f = lista[| i];
            with (f) { 
                estado="IR_A_PESCAR"; 
                tiempo_en_agua=0; 
                dir_movimiento=point_direction(x,y,tx,ty)+irandom_range(-10,10); 
            }
            count++;
        }
        ds_list_destroy(lista);
    }

} // <--- ¡ESTA ES LA LLAVE QUE FALTABA! (Cierra el if mouse check)
/// @description CLICS: Alimentar, Expandir, Menú y Caza

// =========================================================
//        PASO 1: CENSO DE FOCAS (Contar disponibles)
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

// Validar que el selector no supere las disponibles
if (cantidad_a_enviar > focas_disponibles) cantidad_a_enviar = focas_disponibles;
if (cantidad_a_enviar < 1 && focas_disponibles > 0) cantidad_a_enviar = 1;


// =========================================================
//        PASO 2: DETECTAR CLICS (Lógica Principal)
// =========================================================
if (mouse_check_button_pressed(mb_left)) {
    
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var ui_click = false; // Bandera para saber si tocamos un botón

// --- A. BOTÓN ALIMENTAR (DINÁMICO Y BARATO) ---
    if (point_in_rectangle(mx, my, btn_feed_x, btn_feed_y, btn_feed_x+btn_feed_w, btn_feed_y+btn_feed_h)) {
        
        var total_pop = instance_number(Foca1) + instance_number(Foca2);
        
        // --- FÓRMULA DE COSTO (LA REBAJA) ---
        // Base 1 pez + 1 extra cada 20 focas
        var precio_unitario = 1 + floor(total_pop / 20); 
        var costo_total = total_pop * precio_unitario;
        
        if (global.pescado_capturado >= costo_total && total_pop >= 2) {
            
            // 1. Pagar el precio correcto
            global.pescado_capturado -= costo_total;
            
            // 2. Calcular Nacimientos (20%)
            var bebes = floor(total_pop * 0.20);
            if (bebes < 1) bebes = 1; 
            
            // 3. Crear Bebés
            var centro_x = room_width / 2;
            var centro_y = room_height / 2;
            
            repeat(bebes) {
                var nx = centro_x + irandom_range(-40, 40);
                var ny = centro_y + irandom_range(-40, 40);
                var tipo = choose(Foca1, Foca2);
                instance_create_layer(nx, ny, "Instances", tipo);
                effect_create_above(ef_ring, nx, ny, 1, c_red);
            }
            
            show_debug_message("¡Banquete servido! Costo real cobrado: " + string(costo_total));
        } 
        ui_click = true;
    }
    // -----------------------------------------------------
    // B. BOTÓN EXPANDIR
    // -----------------------------------------------------
    if (point_in_rectangle(mx, my, btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h)) {
        
        if (global.pescado_capturado >= costo_expansion) {
            global.pescado_capturado -= costo_expansion; 
            costo_expansion += 10; // Sube el precio
            
            with (obj_Mapa) { nivel_isla++; event_user(0); } // Crecer isla
            show_debug_message("¡Isla Expandida!");
        }
        ui_click = true;
    }

    // -----------------------------------------------------
    // C. BOTÓN MENÚ ESCUADRÓN (Abrir/Cerrar/Retirada)
    // -----------------------------------------------------
    if (point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h)) {
        
        if (menu_abierto) {
            // Si hay focas fuera, ordenamos retirada
            if (focas_fuera > 0) {
                with (Foca1) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
                with (Foca2) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
            }
            menu_abierto = false; // Cerrar menú
        } 
        else {
            menu_abierto = true; // Abrir menú
        }
        ui_click = true;
    }

    // -----------------------------------------------------
    // D. CONTROLES DEL PANEL (+ / -)
    // -----------------------------------------------------
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

    // -----------------------------------------------------
    // E. ENVIAR FOCAS AL MAPA (CLIC EN TERRENO)
    // -----------------------------------------------------
    // Solo si el menú está abierto, no tocamos UI y hay focas
    if (menu_abierto && !ui_click && focas_disponibles > 0) {
        
        var tx = mouse_x; 
        var ty = mouse_y;
        
        effect_create_above(ef_ring, tx, ty, 1, c_lime);
        
        // Crear lista de candidatas
        var lista = ds_list_create();
        with (Foca1) { if (estado=="PASEAR" && cooldown_susto<=0) ds_list_add(lista, id); }
        with (Foca2) { if (estado=="PASEAR" && cooldown_susto<=0) ds_list_add(lista, id); }
        
        ds_list_shuffle(lista); // Barajar
        
        var count = 0;
        var total_lista = ds_list_size(lista);
        
        for (var i=0; i<total_lista; i++) {
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

} // <--- ESTA LLAVE CIERRA EL MOUSE CHECK (Fin del evento)
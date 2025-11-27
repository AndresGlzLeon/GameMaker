/// @description CONTAR, VALIDAR Y ORDENAR

// =========================================================
//        PASO 1: CENSO EN TIEMPO REAL (CORREGIDO)
// =========================================================
focas_disponibles = 0;
focas_fuera = 0; 

// Contamos Foca 1
with (Foca1) { 
    // Si está paseando y sin miedo = DISPONIBLE
    if (estado == "PASEAR" && cooldown_susto <= 0) {
        other.focas_disponibles++;
    }
    // Si NO está paseando (está pescando, huyendo o regresando) = FUERA
    if (estado != "PASEAR") {
        other.focas_fuera++;
    }
}

// Contamos Foca 2
with (Foca2) { 
    if (estado == "PASEAR" && cooldown_susto <= 0) other.focas_disponibles++;
    
    if (estado != "PASEAR") {
        other.focas_fuera++;
    }
}

// Auto-corrección de cantidad
if (cantidad_a_enviar > focas_disponibles) cantidad_a_enviar = focas_disponibles;
if (cantidad_a_enviar < 1 && focas_disponibles > 0) cantidad_a_enviar = 1;






// =========================================================
//        PASO 2: DETECTAR CLICS (UI)
// =========================================================
if (mouse_check_button_pressed(mb_left)) {
    
    var mx_gui = device_mouse_x_to_gui(0);
    var my_gui = device_mouse_y_to_gui(0);
    var click_en_ui = false; // Candado para no enviar focas si toco botones
    
    // --- A. BOTÓN PRINCIPAL (CAZAR / RETIRADA) ---
    if (point_in_rectangle(mx_gui, my_gui, main_x, main_y, main_x+main_w, main_y+main_h)) {
        
        if (menu_abierto) {
            // SI ESTÁ ABIERTO -> ES BOTÓN DE RETIRADA/CERRAR
            
            // Ordenar regreso a todas las que estén fuera
            if (focas_fuera > 0) {
                with (Foca1) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
                with (Foca2) { if (estado != "PASEAR" && estado != "ESCAPANDO") estado = "REGRESAR"; }
                show_debug_message("¡RETIRADA EJECUTADA!");
            }
            
            menu_abierto = false; // Cerrar menú
        } 
        else {
            // SI ESTÁ CERRADO -> ABRIR MENÚ DE CAZA
            menu_abierto = true;
        }
        
        click_en_ui = true;
    }
    
    // --- B. CONTROLES DEL PANEL (Solo si está abierto) ---
    if (menu_abierto) {
        
        // Botón [-]
        if (point_in_rectangle(mx_gui, my_gui, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size)) {
            cantidad_a_enviar = max(1, cantidad_a_enviar - 1);
            click_en_ui = true;
        }
        
        // Botón [+]
        if (point_in_rectangle(mx_gui, my_gui, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size)) {
            if (cantidad_a_enviar < focas_disponibles) cantidad_a_enviar += 1;
            click_en_ui = true;
        }
        
        // Clic en el fondo del panel (para que no atraviese al mapa)
        if (point_in_rectangle(mx_gui, my_gui, panel_x, panel_y, panel_x+panel_w, panel_y+panel_h)) {
            click_en_ui = true;
        }
    }

    // =========================================================
    //        PASO 3: ENVIAR AL MAPA (CLIC EN TERRENO)
    // =========================================================
    
    // Solo enviamos si: Menú abierto + Clic fuera de UI + Hay focas
    if (menu_abierto && !click_en_ui && focas_disponibles > 0) {
        
        var target_x = mouse_x; // Coordenadas en el mundo (Room)
        var target_y = mouse_y;
        var enviadas = 0;
        
        // Feedback Visual en el mapa (Aro verde donde diste la orden)
        effect_create_above(ef_ring, target_x, target_y, 1, c_lime);
        
        // 1. Crear lista de candidatas
        var lista = ds_list_create();
        with (Foca1) { if (estado == "PASEAR" && cooldown_susto <= 0) ds_list_add(lista, id); }
        with (Foca2) { if (estado == "PASEAR" && cooldown_susto <= 0) ds_list_add(lista, id); }
        
        // 2. Barajar para que sea aleatorio
        ds_list_shuffle(lista);
        
        // 3. Enviar a las elegidas
        var total = ds_list_size(lista);
        for (var i = 0; i < total; i++) {
            if (enviadas >= cantidad_a_enviar) break;
            
            var foca = lista[| i];
            with (foca) {
                estado = "IR_A_PESCAR";
                tiempo_en_agua = 0;
                // Van hacia el clic + variación para que no se encimen
                dir_movimiento = point_direction(x, y, target_x, target_y) + irandom_range(-10, 10);
            }
            enviadas++;
        }
        
        ds_list_destroy(lista); // Limpiar memoria
        
        // Opcional: Cerrar menú automáticamente al enviar (estilo RTS rápido)
        // menu_abierto = false; 
    }
}
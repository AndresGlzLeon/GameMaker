/// @description CONTAR, VALIDAR Y ORDENAR

// =========================================================
//        PASO 1: CENSO EN TIEMPO REAL (VALIDACIÓN)
// =========================================================
// Contamos cuántas focas están listas para salir (Paseando y sin miedo)
focas_disponibles = 0;

with (Foca1) { if (estado == "PASEAR" && cooldown_susto <= 0) other.focas_disponibles++; }
with (Foca2) { if (estado == "PASEAR" && cooldown_susto <= 0) other.focas_disponibles++; }

// Auto-corrección: Si seleccionaste 10 pero solo quedan 3, bajar el número automáticamente
if (cantidad_a_enviar > focas_disponibles) {
    cantidad_a_enviar = focas_disponibles;
}
// Si hay 0 disponibles, el mínimo visual es 0 (o 1 para no romper lógica, pero validamos al enviar)
if (cantidad_a_enviar < 1 && focas_disponibles > 0) cantidad_a_enviar = 1;


// =========================================================
//        PASO 2: INTERACCIÓN UI
// =========================================================
if (mouse_check_button_pressed(mb_left)) {
    
    var mx_gui = device_mouse_x_to_gui(0);
    var my_gui = device_mouse_y_to_gui(0);
    var click_en_ui = false;
    
    // --- A. BOTÓN PRINCIPAL (ABRIR / RETIRADA) ---
    if (point_in_rectangle(mx_gui, my_gui, main_x, main_y, main_x+main_w, main_y+main_h)) {
        
        if (menu_abierto) {
            // --- LÓGICA DE RETIRADA (RECALL) ---
            // Si estaba abierto y lo cierro, llamo a las que están cazando
            with (Foca1) {
                if (estado == "IR_A_PESCAR" || estado == "BUSCANDO_PECES") estado = "REGRESAR";
            }
            with (Foca2) {
                if (estado == "IR_A_PESCAR" || estado == "BUSCANDO_PECES") estado = "REGRESAR";
            }
            show_debug_message("¡RETIRADA! Todas las unidades regresan a la base.");
        }
        
        menu_abierto = !menu_abierto;
        click_en_ui = true;
    }
    
    // --- B. BOTONES +/- (Solo si menú abierto) ---
    if (menu_abierto) {
        // [-] MENOS
        if (point_in_rectangle(mx_gui, my_gui, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size)) {
            cantidad_a_enviar = max(1, cantidad_a_enviar - 1);
            click_en_ui = true;
        }
        // [+] MÁS
        if (point_in_rectangle(mx_gui, my_gui, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size)) {
            // VALIDACIÓN: No subir más allá de las disponibles
            if (cantidad_a_enviar < focas_disponibles) {
                cantidad_a_enviar += 1;
            }
            click_en_ui = true;
        }
        // Fondo panel
        if (point_in_rectangle(mx_gui, my_gui, panel_x, panel_y, panel_x+panel_w, panel_y+panel_h)) {
            click_en_ui = true;
        }
    }

    // =========================================================
    //        PASO 3: ENVIAR ORDEN (CLIC EN MAPA)
    // =========================================================
    if (menu_abierto && !click_en_ui && focas_disponibles > 0) {
        
        var target_x = mouse_x;
        var target_y = mouse_y;
        var enviadas = 0;
        
        effect_create_above(ef_ring, target_x, target_y, 1, c_lime);
        
        // Recolección y Barajado
        var lista = ds_list_create();
        with (Foca1) { if (estado == "PASEAR" && cooldown_susto <= 0) ds_list_add(lista, id); }
        with (Foca2) { if (estado == "PASEAR" && cooldown_susto <= 0) ds_list_add(lista, id); }
        ds_list_shuffle(lista);
        
        // Envío (Usando cantidad_a_enviar que ya está validada arriba)
        var total = ds_list_size(lista);
        for (var i = 0; i < total; i++) {
            if (enviadas >= cantidad_a_enviar) break;
            
            var foca = lista[| i];
            with (foca) {
                estado = "IR_A_PESCAR";
                tiempo_en_agua = 0;
                dir_movimiento = point_direction(x, y, target_x, target_y) + irandom_range(-10, 10);
            }
            enviadas++;
        }
        ds_list_destroy(lista);
    }
}
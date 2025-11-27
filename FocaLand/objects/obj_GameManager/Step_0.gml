/// @description UI y Lógica de Envío Aleatorio

var mx_gui = device_mouse_x_to_gui(0);
var my_gui = device_mouse_y_to_gui(0);

// ---------------------------------------------------------
// 1. DETECTAR CLIC EN BOTONES (IZQUIERDO)
// ---------------------------------------------------------
if (mouse_check_button_pressed(mb_left)) {
    // Botón 1
    if (point_in_rectangle(mx_gui, my_gui, btn1_x, btn1_y, btn1_x+btn1_w, btn1_y+btn1_h)) {
        cantidad_seleccionada = 1;
    }
    // Botón 5
    else if (point_in_rectangle(mx_gui, my_gui, btn5_x, btn5_y, btn5_x+btn5_w, btn5_y+btn5_h)) {
        cantidad_seleccionada = 5;
    }
    // Botón 10
    else if (point_in_rectangle(mx_gui, my_gui, btn10_x, btn10_y, btn10_x+btn10_w, btn10_y+btn10_h)) {
        cantidad_seleccionada = 10;
    }
}

// ---------------------------------------------------------
// 2. ENVIAR ESCUADRÓN (CLIC DERECHO)
// ---------------------------------------------------------
if (mouse_check_button_pressed(mb_right)) {
    
    // Guardar destino (Mouse en el mundo)
    mx = mouse_x;
    my = mouse_y;
    
    // Efecto visual
    effect_create_above(ef_ring, mx, my, 1, c_white);
    
    // --- PASO A: CREAR LISTA DE CANDIDATOS ---
    // Buscamos TODAS las focas disponibles (Gris y Negra)
    var lista_candidatos = ds_list_create();
    
    // Buscar Foca1 disponibles
    with (Foca1) {
        if (estado == "PASEAR" && cooldown_susto <= 0) {
            ds_list_add(lista_candidatos, id); // Me apunto a la lista
        }
    }
    // Buscar Foca2 disponibles
    with (Foca2) {
        if (estado == "PASEAR" && cooldown_susto <= 0) {
            ds_list_add(lista_candidatos, id);
        }
    }
    
    // --- PASO B: BARAJAR (SHUFFLE) ---
    // ¡Aquí ocurre la magia aleatoria! Mezclamos la lista.
    ds_list_shuffle(lista_candidatos);
    
    // --- PASO C: SELECCIONAR Y ENVIAR ---
    var enviadas = 0;
    var total_disponibles = ds_list_size(lista_candidatos);
    
    // Repetimos tantas veces como queramos enviar (o hasta que se acaben las focas)
    for (var i = 0; i < total_disponibles; i++) {
        
        if (enviadas >= cantidad_seleccionada) break; // Ya enviamos suficientes
        
        // Sacamos el ID de la foca ganadora de la lista
        var foca_elegida = lista_candidatos[| i];
        
        // Le damos la orden a esa foca específica
        with (foca_elegida) {
            estado = "IR_A_PESCAR";
            tiempo_en_agua = 0;
            dir_movimiento = point_direction(x, y, other.mx, other.my);
            dir_movimiento += irandom_range(-15, 15); // Pequeña variación
        }
        
        enviadas++;
    }
    
    // Limpiar memoria
    ds_list_destroy(lista_candidatos);
    
    if (enviadas > 0) {
        show_debug_message("Orden enviada a " + string(enviadas) + " focas aleatorias.");
    } else {
        show_debug_message("¡Comandante! No hay focas disponibles en la base.");
    }
}
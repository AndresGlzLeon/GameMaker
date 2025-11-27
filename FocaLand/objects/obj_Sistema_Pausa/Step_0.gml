/// @description Detectar ESC y Clicks

// 1. DETECTAR TECLA ESCAPE
if (keyboard_check_pressed(vk_escape)) {
    pausa = !pausa; // Cambia de true a false y viceversa
    
    if (pausa) {
        // CONGELAR EL JUEGO (Desactiva todo menos este objeto)
        instance_deactivate_all(true);
    } else {
        // DESCONGELAR (Reactiva todo)
        instance_activate_all();
    }
}

// 2. DETECTAR CLICKS DEL MOUSE (Coordenadas GUI)
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var click = mouse_check_button_pressed(mb_left);

// SI EL JUEGO NO ESTÁ PAUSADO (Click en el botón de la esquina)
if (!pausa) {
    // Si el mouse está dentro del botón "MENÚ"
    if (mx > btn_x && mx < btn_x + btn_ancho && my > btn_y && my < btn_y + btn_alto) {
        if (click) {
            pausa = true;
            instance_deactivate_all(true); // Congelar
        }
    }
} 

// SI EL JUEGO SÍ ESTÁ PAUSADO (Clicks en el menú de pausa)
else {
    var centro_x = display_get_gui_width() / 2;
    var centro_y = display_get_gui_height() / 2;
    
    // Botón CONTINUAR (Arriba)
    if (mx > centro_x - 100 && mx < centro_x + 100 && my > centro_y - 40 && my < centro_y) {
        if (click) {
            pausa = false;
            instance_activate_all(); // Descongelar
        }
    }
    
    // Botón SALIR (Abajo)
    if (mx > centro_x - 100 && mx < centro_x + 100 && my > centro_y + 20 && my < centro_y + 60) {
        if (click) {
            instance_activate_all(); // Reactivar antes de salir por si acaso
            room_goto(rm_Menu); // Vuelve a tu menú principal
        }
    }
}
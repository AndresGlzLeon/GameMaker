/// @description Detectar ESC para Pausa/Despausa

// SOLO ESC cambia el estado de pausa
if (keyboard_check_pressed(vk_escape)) {
    pausa = !pausa;
    
    if (pausa) {
        // Congelar el juego
        instance_deactivate_all(true);
        instance_activate_object(obj_Sistema_Pausa);
        if (instance_exists(obj_HUD_Entorno)) instance_activate_object(obj_HUD_Entorno);
    } else {
        // Descongelar el juego
        instance_activate_all();
    }
    
    show_debug_message("Pausa: " + string(pausa));
}
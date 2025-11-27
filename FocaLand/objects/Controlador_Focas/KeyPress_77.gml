/// @description DIAGNÓSTICO DE TRUCO

show_debug_message("--- INTENTO DE TRUCO ---");

// 1. ¿El objeto existe?
show_debug_message("1. Controlador activo.");

// 2. ¿La variable existe?
if (variable_global_exists("pescado_capturado")) {
    
    // Guardar valor antes
    var antes = global.pescado_capturado;
    
    // SUMAR
    global.pescado_capturado += 100000;
    
    // Mostrar cambio
    show_debug_message("2. ÉXITO: Tenías " + string(antes) + ", ahora tienes " + string(global.pescado_capturado));
    
    // Efecto visual para confirmar en pantalla
    effect_create_above(ef_firework, mouse_x, mouse_y, 2, c_yellow);
} 
else {
    show_debug_message("2. FALLO: La variable 'global.pescado_capturado' NO existe.");
}
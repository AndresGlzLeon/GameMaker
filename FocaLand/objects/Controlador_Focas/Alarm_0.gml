/// @description TRUCO: Peces Infinitos (Corregido)

// Verificamos si la variable del dinero existe para evitar el crash
if (variable_global_exists("pescado_capturado")) {
    
    // USAR EL NOMBRE CORRECTO: pescado_capturado
    global.pescado_capturado += 1000;
    
    show_debug_message("💰 TRUCO ACTIVADO: +1000 Peces. Total: " + string(global.pescado_capturado));
    
    // Efecto visual divertido en el mouse
    effect_create_above(ef_star, mouse_x, mouse_y, 1, c_yellow);
}
else {
    show_debug_message("❌ Error: La variable global.pescado_capturado no se ha creado aún.");
}
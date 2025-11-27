/// @description Sistema de Regeneración de Focas (Cada 5 segundos)

// Contar focas actuales
var focas_actuales = instance_number(Foca1) + instance_number(Foca2);

// Si hay muy pocas focas, regenerar algunas
if (variable_global_exists("cantidad_focas_minima") && focas_actuales < global.cantidad_focas_minima) {
    var focas_a_crear = global.cantidad_focas_minima - focas_actuales;
    var creadas = 0;
    var intentos = 0;
    
    show_debug_message("⚠️ POCAS FOCAS DETECTADAS (" + string(focas_actuales) + "), regenerando " + string(focas_a_crear) + "...");
    
    // Crear las focas que faltan
    while (creadas < focas_a_crear && intentos < 500) {
        intentos++;
        
        // Elegir una zona aleatoria
        var zona_x = irandom(3) * (room_width div 4);
        var zona_y = irandom(3) * (room_height div 4);
        
        var pos_x = zona_x + irandom_range(64, (room_width div 4) - 64);
        var pos_y = zona_y + irandom_range(64, (room_height div 4) - 64);
        
        pos_x = clamp(pos_x, 64, room_width - 64);
        pos_y = clamp(pos_y, 64, room_height - 64);
        
        if (tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0) {
            var tipo = choose(Foca1, Foca2);
            instance_create_layer(pos_x, pos_y, "Instances", tipo);
            creadas++;
        }
    }
    
    show_debug_message("✓ Regeneradas " + string(creadas) + " focas. Total ahora: " + string(focas_actuales + creadas));
}

// Reiniciar el alarma para próxima verificación
alarm[1] = 300; // 5 segundos después

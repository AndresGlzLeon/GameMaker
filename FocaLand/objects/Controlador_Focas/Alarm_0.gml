/// @description GENERAR MANADA

var cantidad_focas = 10; // ¿Cuántas quieres?
var creadas = 0;
var intentos = 0;

// Verificamos que el mapa exista
if (!variable_global_exists("tilemap_nieve")) {
    alarm[0] = 5; // Si no está listo, espera otros 5 frames
    exit;
}

// BUCLE DE CREACIÓN
while (creadas < cantidad_focas && intentos < 1000) {
    intentos++;
    
    // Elegir punto al azar en la pantalla
    var pos_x = irandom_range(64, room_width - 64);
    var pos_y = irandom_range(64, room_height - 64);

    // PREGUNTA CLAVE: ¿Hay nieve en este punto? (Tile > 0)
    if (tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0) {
        
        // ¡SITIO VÁLIDO! 
        // Lanzar moneda: ¿Gris o Negra?
        var tipo_foca = choose(Foca1, Foca2);
        
        instance_create_layer(pos_x, pos_y, "Instances", tipo_foca);
        
        creadas++;
    }
}

show_debug_message("¡Nacieron " + string(creadas) + " focas en la isla!");
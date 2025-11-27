/// @description GENERAR ORCAS (Depredadores)

var cantidad_orcas = 3; // Pocas, porque son peligrosas
var creadas = 0;
var intentos = 0;

// Seguridad de capas
if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; exit;
}

// Distancia de seguridad (Lejos de la isla para no spawnear trabadas)
var margen = 200; 

while (creadas < cantidad_orcas && intentos < 1000) {
    intentos++;

    var px = irandom_range(margen, room_width - margen);
    var py = irandom_range(margen, room_height - margen);

    // 1. ¿Hay agua?
    var hay_agua = tilemap_get_at_pixel(global.tilemap_agua, px, py) > 0;

    // 2. ¿NO hay nieve cerca? (Revisamos el punto exacto)
    var hay_nieve = tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0;

    if (hay_agua && !hay_nieve) {
        // ¡Sitio válido!
        instance_create_layer(px, py, "Instances", obj_Orca); // Asegúrate que el objeto se llame 'orca'
        creadas++;
    }
}

show_debug_message("🦈 Cuidado: Se han liberado " + string(creadas) + " orcas.");
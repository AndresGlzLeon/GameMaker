/// @description GENERAR ANILLO DE DEPREDADORES

var cantidad_orcas = 8; // AUMENTAMOS LA DIFICULTAD (Antes eran 3)
var creadas = 0;
var intentos = 0;

if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; exit;
}

var cx = room_width / 2;
var cy = room_height / 2;

// BUCLE DE CREACIÓN
while (creadas < cantidad_orcas && intentos < 2000) {
    intentos++;
    
    // --- LÓGICA DE "ANILLO DE LA MUERTE" ---
    // En lugar de X/Y al azar, elegimos una distancia desde el centro.
    // Entre 400 y 900 pixeles del centro es la "Zona de Peligro".
    var distancia = irandom_range(400, 900);
    var angulo = irandom(359);
    
    var px = cx + lengthdir_x(distancia, angulo);
    var py = cy + lengthdir_y(distancia, angulo);

    // 1. Validar que sea Agua y NO sea Nieve
    var hay_agua = tilemap_get_at_pixel(global.tilemap_agua, px, py) > 0;
    var hay_nieve = tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0;
    
    if (hay_agua && !hay_nieve) {
        // Crear la orca
        var nueva_orca = instance_create_layer(px, py, "Instances", obj_Orca);
        
        // Truco: Que nazcan mirando hacia la isla para dar miedo desde el inicio
        nueva_orca.dir_movimiento = point_direction(px, py, cx, cy) + irandom_range(-45, 45);
        
        creadas++;
    }
}

show_debug_message("⚠️ ALERTA: " + string(creadas) + " orcas patrullando la costa.");
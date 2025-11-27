/// @description GENERAR ORCAS (Corregido y Aumentado)

// Si estamos cargando, usar el número guardado. Si no, usar 30 por defecto.
var cantidad_orcas = variable_global_exists("orcas_guardadas") ? global.orcas_guardadas : 30;
var creadas = 0;
var intentos = 0;

// Seguridad
if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; exit;
}

var cx = room_width / 2;
var cy = room_height / 2;

// BUCLE ROBUSTO
while (creadas < cantidad_orcas && intentos < 10000) { // Más intentos (10k)
    intentos++;
    
    // --- CAMBIO CLAVE: RADIO MÁS GRANDE ---
    // Antes era 400-900. Ahora 800-2200.
    // Esto cubre casi todo el mar en un mapa grande.
    var distancia = irandom_range(800, 2200);
    var angulo = irandom(359);
    
    var px = cx + lengthdir_x(distancia, angulo);
    var py = cy + lengthdir_y(distancia, angulo);
    
    // Validar límites del mundo
    px = clamp(px, 50, room_width - 50);
    py = clamp(py, 50, room_height - 50);

    // Validar Terreno
    var hay_agua = tilemap_get_at_pixel(global.tilemap_agua, px, py) > 0;
    var hay_nieve = tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0;
    
    if (hay_agua && !hay_nieve) {
        
        // Crear Orca
        var nueva = instance_create_layer(px, py, "Instances", orca);
        
        // Que nazca mirando al centro (acechando)
        nueva.dir_movimiento = point_direction(px, py, cx, cy) + irandom_range(-20, 20);
        
        creadas++;
    }
}

show_debug_message("🦈 REPORTE: Se generaron " + string(creadas) + " orcas de " + string(cantidad_orcas) + " solicitadas. [Modo Carga: " + string(global.modo_carga) + "]");

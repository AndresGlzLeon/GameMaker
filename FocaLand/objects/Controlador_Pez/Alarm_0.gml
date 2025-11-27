/// @description GENERAR BANCO DE PECES

var cantidad_peces = 15; // Ajusta a tu gusto
var creados = 0;
var intentos = 0;

// 1. Verificaciones de seguridad
if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; // Si no están listos, esperar más
    exit;
}

// 2. Bucle de creación
while (creados < cantidad_peces && intentos < 2000) {
    intentos++;
    
    // Elegir punto al azar
    var pos_x = irandom_range(32, room_width - 32);
    var pos_y = irandom_range(32, room_height - 32);

    // 3. LA REGLA DE ORO:
    // ¿Hay Agua aquí? Y ADEMÁS... ¿No hay Nieve?
    // (Esto evita que nazcan debajo de la isla si por error hay agua pintada abajo)
    var hay_agua = tilemap_get_at_pixel(global.tilemap_agua, pos_x, pos_y) > 0;
    var hay_nieve = tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0;
    
    if (hay_agua && !hay_nieve) {
        
        // ¡Sitio perfecto: Mar abierto!
        instance_create_layer(pos_x, pos_y, "Instances", Pez);
        creados++;
    }
}

show_debug_message("🐟 Peces en el agua: " + string(creados));
/// @description GENERAR FOCAS (INTELIGENTE)

// 1. CONFIGURACIÓN POR DEFECTO (Partida Nueva)
var cantidad_focas = 20; 

// 2. REVISAR SI ESTAMOS CARGANDO PARTIDA
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    if (variable_global_exists("focas_guardadas")) {
        cantidad_focas = global.focas_guardadas;
        show_debug_message("CARGANDO PARTIDA: Restaurando " + string(cantidad_focas) + " focas.");
    }
}

// 3. GENERACIÓN EN EL MAPA
var creadas = 0;
var intentos = 0;

// Validar que exista el mapa de nieve para no ponerlas en el agua
if (!variable_global_exists("tilemap_nieve")) {
    // Intentamos buscarlo si no existe
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
    
    if (global.tilemap_nieve == -1) { alarm[0]=5; exit; } // Reintentar luego si falla
}

while (creadas < cantidad_focas && intentos < 1000) {
    intentos++;
    var pos_x = irandom_range(64, room_width - 64);
    var pos_y = irandom_range(64, room_height - 64);

    // Solo poner si hay suelo (Tile > 0)
    if (tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0) {
        var tipo = choose(Foca1, Foca2);
        instance_create_layer(pos_x, pos_y, "Instances", tipo);
        creadas++;
    }
}

// 4. APAGAR EL MODO CARGA (CON RETRASO)
// Usamos una alarma para dar tiempo a los Peces y Orcas de leer sus datos
// antes de que borremos la variable global.
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    alarm[1] = 5; // En 5 frames se apaga el modo carga
}
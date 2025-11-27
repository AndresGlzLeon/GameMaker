/// @description GENERAR FOCAS (INTELIGENTE CON PROTECCIÓN)

// 1. CONFIGURACIÓN POR DEFECTO (Partida Nueva)
var cantidad_focas = 50; 

// 2. REVISAR SI ESTAMOS CARGANDO PARTIDA
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    if (variable_global_exists("focas_guardadas")) {
        cantidad_focas = global.focas_guardadas;
        show_debug_message("🦭 CARGANDO PARTIDA: Restaurando " + string(cantidad_focas) + " focas.");
    }
}

// 3. GENERACIÓN EN EL MAPA - DISTRIBUIDAS EN ZONAS SEGURAS
var creadas = 0;
var intentos = 0;
var max_intentos = 2000; // Más intentos para asegurar colocación

// Validar que exista el mapa de nieve para no ponerlas en el agua
if (!variable_global_exists("tilemap_nieve")) {
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
    
    if (global.tilemap_nieve == -1) { alarm[0]=1; exit; }
}

// Dividir el mapa en zonas para distribuir focas uniformemente
var zona_ancho = room_width div 4;
var zona_alto = room_height div 4;

while (creadas < cantidad_focas && intentos < max_intentos) {
    intentos++;
    
    // Elegir una zona aleatoria del mapa
    var zona_x = irandom(3) * zona_ancho;
    var zona_y = irandom(3) * zona_alto;
    
    // Buscar posición segura dentro de la zona
    var pos_x = zona_x + irandom_range(64, zona_ancho - 64);
    var pos_y = zona_y + irandom_range(64, zona_alto - 64);
    
    // Asegurar que está dentro del mapa
    pos_x = clamp(pos_x, 64, room_width - 64);
    pos_y = clamp(pos_y, 64, room_height - 64);

    // Solo poner si hay suelo (Tile > 0)
    if (tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0) {
        var tipo = choose(Foca1, Foca2);
        instance_create_layer(pos_x, pos_y, "Instances", tipo);
        creadas++;
    }
}

show_debug_message("🦭 Focas creadas: " + string(creadas) + " (Modo Carga: " + string(global.modo_carga) + ")");

// 4. SISTEMA DE REGENERACIÓN (Mantener mínimo de focas)
// Cada cierto tiempo, verifica si hay muy pocas focas y regenera
global.cantidad_focas_minima = max(5, cantidad_focas div 3); // Al menos 1/3 del original o 5
global.regeneracion_focas_activa = true;
alarm[1] = 300; // Revisar cada 5 segundos

// 5. APAGAR EL MODO CARGA (CON RETRASO MÁXIMO)
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    alarm[0] = 50; // En 50 frames se apaga el modo carga
    show_debug_message("⏳ Apagando modo carga en 50 frames...");
}
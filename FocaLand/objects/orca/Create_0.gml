/// @description Depredador ALFA (Buffed)

// --- ESTADÍSTICAS MEJORADAS ---
velocidad_patrulla = 1.8; // Patrulla un poco más rápido
velocidad_caza = 4.5;     // ¡MUY RÁPIDA! (Más que la foca corriendo)
radio_deteccion = 600;    // Ve lejísimos (antes 350)

estado = "PATRULLAR"; 
objetivo = noone;
dir_movimiento = irandom(359);
image_speed = 0.5;

// Mapa
if (!variable_global_exists("tilemap_nieve")) {
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
}

// --- SISTEMA DE ENFERMEDAD ---
tiempo_enfermedad = 0; // Contador: Si es > 0, está envenenado
duracion_veneno = 1200; // 20 SEGUNDOS de enfermedad (60fps * 20)
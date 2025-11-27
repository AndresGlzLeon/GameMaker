/// @description Configuración Foca Negra

// --- MOVIMIENTO ---
velocidad_propia = 1.5;   // Velocidad en tierra
velocidad_caza = 3.5;     // Velocidad en agua
dir_movimiento = irandom(359);
image_speed = 0.5;

// --- INTELIGENCIA ARTIFICIAL (ESTADOS) ---
// ¡ESTA ES LA VARIABLE QUE TE FALTABA!
estado = "PASEAR";      
rango_vision = 250;     
pez_objetivo = noone;   

// --- MAPA ---
if (!variable_global_exists("tilemap_nieve")) {
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
}
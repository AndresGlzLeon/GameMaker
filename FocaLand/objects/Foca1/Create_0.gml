/// @description VARIABLES DE LA FOCA (Solo movimiento)

// 1. Velocidad
velocidad_propia = 1.5; 
dir_movimiento = irandom(359); 

// 2. Animación
image_speed = 0.5; 
alarm[0] = game_get_speed(gamespeed_fps) * 2; // Temporizador cambio rumbo

// 3. OBTENER EL MAPA DE NIEVE (Para no salirse)
// Asegúrate de que la capa en la Room se llame "TilesSnow"
var _layer_id = layer_get_id("TilesSnow"); 
global.mapa_nieve = layer_tilemap_get_id(_layer_id);

// Si no encuentra el mapa, avisar (pero no crear más focas)
if (global.mapa_nieve == -1) {
    show_debug_message("Foca no encuentra la capa TilesSnow");
}
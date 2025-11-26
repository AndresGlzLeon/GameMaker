/// @description Configuración: Ojo de Halcón (Detecta Nieve)

// Velocidad muy lenta
velocidad_propia = 0.5; 
dir_movimiento = irandom(359); 
image_speed = 0.3; 
alarm[0] = game_get_speed(gamespeed_fps) * 4;

// --- OBTENER MAPA DE AGUA (Donde SÍ puede estar) ---
var _layer_agua = layer_get_id("TilesWater"); 
global.mapa_agua = layer_tilemap_get_id(_layer_agua);

// --- OBTENER MAPA DE NIEVE (Lo que debe EVITAR) ---
// Asegúrate de que la capa se llame TilesSnow, igual que con las focas
var _layer_nieve = layer_get_id("TilesSnow"); 
global.mapa_nieve = layer_tilemap_get_id(_layer_nieve);

if (global.mapa_agua == -1 || global.mapa_nieve == -1) {
    show_debug_message("ADVERTENCIA: Al pez le falta un mapa (Agua o Nieve). Revisa los nombres de capa.");
}
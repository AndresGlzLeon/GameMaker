/// @description Configuración: Nieve y Agua

ancho_celdas = room_width div 64;
alto_celdas = room_height div 64;
nivel_isla = 1;

// Crear memoria
global.grid_terreno = ds_grid_create(ancho_celdas, alto_celdas);

// 1. CONECTAR CAPA DE NIEVE
var lay_snow = layer_get_id("TilesSnow");
global.tilemap_nieve = layer_tilemap_get_id(lay_snow);

// 2. CONECTAR CAPA DE AGUA (¡Nuevo!)
// Asegúrate de que en la Room la capa se llame "TilesWater"
var lay_water = layer_get_id("TilesWater");
global.tilemap_agua = layer_tilemap_get_id(lay_water);

// Dibujar
event_user(0);
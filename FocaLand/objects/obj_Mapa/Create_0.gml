/// @description Configuración: Nieve y Agua

ancho_celdas = room_width div 64;
alto_celdas = room_height div 64;

// CARGAR NIVEL DE ISLA SI ESTAMOS EN MODO CARGA
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    if (variable_global_exists("nivel_isla_guardado")) {
        nivel_isla = global.nivel_isla_guardado;
        show_debug_message("🏝️ CARGANDO TERRENO: Nivel Isla " + string(nivel_isla));
    } else {
        nivel_isla = 1;
    }
} else {
    nivel_isla = 1;
}

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
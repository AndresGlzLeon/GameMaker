/// @description Configuración del Depredador

// Velocidades (Debe ser más rápida que la foca nadando)
velocidad_patrulla = 1.5;
velocidad_caza = 4.2; 

// Visión
radio_deteccion = 350; 
estado = "PATRULLAR"; // Estados: "PATRULLAR", "PERSEGUIR"
objetivo = noone;

dir_movimiento = irandom(359);
image_speed = 0.5;

// Conectar con Mapa de Nieve (Para no encallar)
if (!variable_global_exists("tilemap_nieve")) {
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
}
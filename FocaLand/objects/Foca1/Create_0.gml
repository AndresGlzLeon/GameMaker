/// @description Configuración Foca Gris

// --- MOVIMIENTO ---
velocidad_propia = 1.5;   // Velocidad en tierra
velocidad_caza = 3.5;     // Velocidad en agua (¡Más rápida!)
dir_movimiento = irandom(359);
image_speed = 0.5;

// --- INTELIGENCIA ARTIFICIAL (ESTADOS) ---
estado = "PASEAR";      // Puede ser: "PASEAR", "CAZAR", "REGRESAR"
rango_vision = 250;     // Distancia a la que ve un pez
pez_objetivo = noone;   // Variable para recordar a qué pez persigue

// --- MAPA ---
// Aseguramos que la variable global del mapa exista (creada por obj_Mapa)
if (!variable_global_exists("tilemap_nieve")) {
    // Intento de rescate si obj_Mapa no cargó primero
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
}
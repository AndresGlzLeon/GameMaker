/// @description Generador de Peces (Corregido)

var cantidad_peces = 15; 
var creados = 0; // <--- Aquí la declaramos como "creados"

// IMPORTANTE: Asegúrate de que la capa de agua se llame así en la Room
var nombre_capa_agua = "TilesWater"; 
var capa_instancias = "Instances";

var layer_id = layer_get_id(nombre_capa_agua);
var tilemap_id = layer_tilemap_get_id(layer_id);

if (tilemap_id == -1) {
    show_message("ERROR: No encuentro la capa 'TilesWater'. Revisa el nombre en la Room.");
    exit;
}

var intentos = 0;

// BUCLE DE GENERACIÓN CORREGIDO
// Ahora usamos "creados" igual que arriba
while (creados < cantidad_peces && intentos < 3000) {
    intentos++;
    
    var pos_x = irandom_range(32, room_width - 32);
    var pos_y = irandom_range(32, room_height - 32);

    // Verificar si hay agua
    var hay_agua = tilemap_get_at_pixel(tilemap_id, pos_x, pos_y) > 0;
    
    if (hay_agua) {
        // Crear el Pez
        var nuevo_pez = instance_create_layer(pos_x, pos_y, capa_instancias, Pez);
        
        // Dirección aleatoria
        nuevo_pez.dir_movimiento = irandom(359);
        
        creados++; // Sumamos a "creados"
    }
}
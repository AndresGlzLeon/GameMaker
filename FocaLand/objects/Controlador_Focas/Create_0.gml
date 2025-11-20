/// @description GENERADOR DE MANADA (Este sí crea las focas)

var cantidad_focas = 10;
var creadas = 0;

// Nombres de las capas (Deben ser exactos a tu Room)
var capa_suelo = "TilesSnow";
var capa_instancias = "Instances";

var layer_id = layer_get_id(capa_suelo);
var tilemap_id = layer_tilemap_get_id(layer_id);

// Si no existe la capa, detenemos todo para que no explote
if (tilemap_id == -1) {
    show_message("ERROR: No encuentro la capa 'TilesSnow' en la Room.");
    exit;
}

var intentos = 0;

// BUCLE DE CREACIÓN
while (creadas < cantidad_focas && intentos < 2000) {
    intentos++;
    
    var pos_x = irandom_range(64, room_width - 64);
    var pos_y = irandom_range(64, room_height - 64);

    // Verificamos si hay suelo (Tile > 0)
    var tile_data = tilemap_get_at_pixel(tilemap_id, pos_x, pos_y);
    var tile_index = tile_get_index(tile_data);

    if (tile_index > 0) {
        // ELEGIR TIPO DE FOCA
        var obj_foca = choose(Foca1, Foca2);
        
        // CREAR LA FOCA
        var nueva = instance_create_layer(pos_x, pos_y, capa_instancias, obj_foca);
        
        // Opcional: Darle una dirección inicial aleatoria extra
        nueva.dir_movimiento = irandom(359);
        
        creadas++;
    }
}
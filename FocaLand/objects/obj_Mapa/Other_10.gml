/// @description DIBUJAR NIEVE Y AGUA

var radio = 3 + (nivel_isla * 2); 
var cx = ancho_celdas div 2;
var cy = alto_celdas div 2;

ds_grid_clear(global.grid_terreno, 0);
ds_grid_set_disk(global.grid_terreno, cx, cy, radio, 1);

// BUCLE DE PINTADO DOBLE
for (var _x = 0; _x < ancho_celdas; _x++) {
    for (var _y = 0; _y < alto_celdas; _y++) {
        
        var valor = global.grid_terreno[# _x, _y];
        
        if (valor == 1) {
            // === ES TIERRA ===
            // 1. Poner Tile de Nieve (Índice 1 = Blanco Sólido)
            tilemap_set(global.tilemap_nieve, 1, _x, _y);
            
            // 2. Borrar agua debajo (Para que no haya agua oculta)
            tilemap_set(global.tilemap_agua, 0, _x, _y);
        } 
        else {
            // === ES MAR ===
            // 1. Borrar Nieve
            tilemap_set(global.tilemap_nieve, 0, _x, _y);
            
            // 2. Poner Tile de Agua (Índice 1 = Azul Sólido)
            // Asegúrate que tu TileSetWater tenga un cuadro azul en la posición 1
            tilemap_set(global.tilemap_agua, 1, _x, _y);
        }
    }
}
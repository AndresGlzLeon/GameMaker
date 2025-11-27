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
	// ... (Tus bucles for anteriores terminan aquí) ...
// } 

// ... (Después de los bucles que pintan el mapa) ...

// =========================================================
//        RESCATE MATEMÁTICO (Infalible)
// =========================================================

// 1. Calcular el Radio Real de la isla en PIXELES
// (Radio en celdas * 64px que mide cada cuadro)
var radio_en_pixeles = radio * 64; 

// Centro de la sala en pixeles
var centro_sala_x = room_width / 2;
var centro_sala_y = room_height / 2;

with (orca) {
    
    // 2. Medir distancia al centro
    var dist_al_centro = point_distance(x, y, centro_sala_x, centro_sala_y);
    
    // 3. VERIFICACIÓN: ¿Estoy dentro de la zona de nieve?
    // Si mi distancia es MENOR al radio de la isla, estoy atrapada.
    if (dist_al_centro < radio_en_pixeles) {
        
        // 4. TELETRANSPORTE
        // Calculamos el ángulo para salir disparada hacia afuera
        var dir_salida = point_direction(centro_sala_x, centro_sala_y, x, y);
        
        // Te colocamos JUSTO en el borde + 50 pixeles de aire
        x = centro_sala_x + lengthdir_x(radio_en_pixeles + 50, dir_salida);
        y = centro_sala_y + lengthdir_y(radio_en_pixeles + 50, dir_salida);
        
        // Resetear estado para que no se quede con bugs de movimiento
        estado = "PATRULLAR";
        objetivo = noone;
        
        // Efecto visual para que sepas que se salvó
        effect_create_above(ef_ring, x, y, 2, c_red);
    }
}
	
	
}
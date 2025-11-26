/// @description GENERADOR DE PECES (Igual al de focas, pero en el agua)

var cantidad_peces = 15; // Ajusta cuántos peces quieres al inicio
var peces_creados = 0;

// Nombres de las capas (Usamos la misma capa de suelo para saber dónde NO ponerlos)
var capa_suelo = "TilesSnow";
var capa_instancias = "Instances";

var layer_id = layer_get_id(capa_suelo);
var tilemap_id = layer_tilemap_get_id(layer_id);

// Validación de seguridad
if (tilemap_id == -1) {
    show_debug_message("ADVERTENCIA: No se encuentra 'TilesSnow' para generar peces.");
    // No usamos exit aquí para no detener el resto del juego si esto falla
} else {

    var intentos = 0;

    // BUCLE DE CREACIÓN
    while (peces_creados < cantidad_peces && intentos < 2000) {
        intentos++;
        
        // Generar posición aleatoria
        var pos_x = irandom_range(64, room_width - 64);
        var pos_y = irandom_range(64, room_height - 64);

        // Verificamos el suelo
        var tile_data = tilemap_get_at_pixel(tilemap_id, pos_x, pos_y);
        var tile_index = tile_get_index(tile_data);

        // CONDICIÓN INVERSA: Buscamos donde NO haya tile (tile_index == 0)
        // Asumimos que vacío = Agua
        if (tile_index == 0) {
            
            // CREAR EL PEZ (Asegúrate de tener tu objeto Obj_Pez creado)
            var nuevo_pez = instance_create_layer(pos_x, pos_y, capa_instancias, Pez);
            
            // Opcional: Darle dirección inicial si tu pez se mueve
            nuevo_pez.direction = irandom(359);
            nuevo_pez.speed = 0.5; // Velocidad lenta para que naden
            
            peces_creados++;
        }
    }
}
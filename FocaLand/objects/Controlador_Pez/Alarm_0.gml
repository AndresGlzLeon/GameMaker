/// @description Generar Pez en zona válida

// 1. CONTROL DE POBLACIÓN
// Solo creamos si hay menos del máximo permitido
if (instance_number(Obj_Pez) < max_peces) {
    
    var creado = false;
    var intentos = 0;
    
    // 2. BUSCAR UN LUGAR CON AGUA (Donde NO haya nieve)
    // Intentamos 10 veces encontrar una coordenada válida al azar
    while (!creado && intentos < 10) {
        intentos++;
        
        var _x = irandom_range(32, room_width - 32);
        var _y = irandom_range(32, room_height - 32);
        
        // Verificamos el mapa de tiles
        var es_agua = true;
        
        if (global.tilemap_suelo != -1) {
            // Obtenemos qué hay en esa coordenada
            var tile_data = tilemap_get_at_pixel(global.tilemap_suelo, _x, _y);
            var tile_index = tile_get_index(tile_data);
            
            // Si el índice es mayor a 0, ES HIELO/TIERRA. 
            // Nosotros queremos agua (índice 0 o vacío).
            if (tile_index > 0) {
                es_agua = false;
            }
        }
        
        // 3. CREAR EL PEZ SI ES AGUA
        if (es_agua) {
            instance_create_layer(_x, _y, capa_instancias, Obj_Pez);
            creado = true;
            // Opcional: Efecto visual al nacer (una burbuja o cambio de escala)
        }
    }
}

// 4. REINICIAR ALARMA
// Vuelve a ejecutar este código en X segundos
alarm[0] = game_get_speed(gamespeed_fps) * tiempo_spawn;
/// @description GENERACIÓN (GRUPOS vs CARGA)

// 1. SEGURIDAD DE MAPA (Tu código original)
if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; 
    exit;
}

// 2. DETECTAR SI ESTAMOS CARGANDO PARTIDA
var modo_carga_activo = false;
var cantidad_exacta_a_cargar = 0;

if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    modo_carga_activo = true;
    if (variable_global_exists("peces_guardados")) {
        cantidad_exacta_a_cargar = global.peces_guardados;
    }
    show_debug_message("MODO CARGA: Restaurando " + string(cantidad_exacta_a_cargar) + " peces.");
}


// ==========================================================
// OPCIÓN A: CARGAR PARTIDA (Restaurar número exacto)
// ==========================================================
if (modo_carga_activo) {
    
    var creados = 0;
    var intentos = 0;
    
    // Simplemente creamos peces sueltos hasta llegar al número guardado
    while (creados < cantidad_exacta_a_cargar && intentos < 5000) {
        intentos++;
        
        // Buscar posición segura (Tu lógica de seguridad simplificada para 1 pez)
        var px = irandom_range(64, room_width - 64);
        var py = irandom_range(64, room_height - 64);
        
        var es_seguro = true;
        // Debe ser agua
        if (tilemap_get_at_pixel(global.tilemap_agua, px, py) == 0) es_seguro = false;
        // No debe ser nieve
        if (tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0) es_seguro = false;
        
        if (es_seguro) {
            var p = instance_create_layer(px, py, "Instances", Pez);
            p.direction = irandom(359); // Dirección al azar
            p.velocidad_propia = random_range(0.4, 0.6);
            creados++;
        }
    }
}

// ==========================================================
// OPCIÓN B: NUEVA PARTIDA (Tu código de Cardúmenes)
// ==========================================================
else {
    
    // CONFIGURACIÓN DE TUS GRUPOS
    var grupos_a_crear = 50; 
    var grupos_creados = 0;
    var intentos = 0;
    var margen_seguridad = 120; 

    // BUCLE DE GRUPOS (Tu código intacto)
    while (grupos_creados < grupos_a_crear && intentos < 5000) {
        intentos++;
        
        // 1. ELEGIR EL CENTRO DEL GRUPO
        var centro_x = irandom_range(margen_seguridad, room_width - margen_seguridad);
        var centro_y = irandom_range(margen_seguridad, room_height - margen_seguridad);

        // 2. VERIFICAR QUE EL CENTRO SEA SEGURO
        var zona_segura = true;
        
        if (tilemap_get_at_pixel(global.tilemap_agua, centro_x, centro_y) == 0) zona_segura = false;
        
        if (zona_segura) {
            if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y) > 0) zona_segura = false;
            if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x + margen_seguridad, centro_y) > 0) zona_segura = false;
            if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x - margen_seguridad, centro_y) > 0) zona_segura = false;
            if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y + margen_seguridad) > 0) zona_segura = false;
            if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y - margen_seguridad) > 0) zona_segura = false;
        }

        // 3. CREAR EL GRUPO
        if (zona_segura) {
            var num_peces = irandom_range(15, 25);
            var dir_grupo = irandom(359); 
            
            repeat(num_peces) {
                var offset_x = irandom_range(-40, 40);
                var offset_y = irandom_range(-40, 40);
                
                var p = instance_create_layer(centro_x + offset_x, centro_y + offset_y, "Instances", Pez);
                
                p.dir_movimiento = dir_grupo + irandom_range(-10, 10);
                p.velocidad_propia = random_range(0.4, 0.6); 
            }
            
            grupos_creados++;
        }
    }
    show_debug_message("🐟 Cardúmenes creados: " + string(grupos_creados));
}
/// @description GENERAR CARDÚMENES (Grupos de 3 a 8)

// Configuración
var grupos_a_crear = 10; // ¿Cuántos grupos de peces quieres en el mapa?
var grupos_creados = 0;
var intentos = 0;

// Seguridad de mapa
if (!variable_global_exists("tilemap_agua") || !variable_global_exists("tilemap_nieve")) {
    alarm[0] = 10; 
    exit;
}

// Margen de seguridad: Aumentamos esto para que el grupo entero quepa en el agua
// 64px de margen + 50px de radio del grupo = 114px mínimo lejos de la nieve
var margen_seguridad = 120; 

// BUCLE DE GRUPOS
while (grupos_creados < grupos_a_crear && intentos < 5000) {
    intentos++;
    
    // 1. ELEGIR EL CENTRO DEL GRUPO (El "Líder" invisible)
    var centro_x = irandom_range(margen_seguridad, room_width - margen_seguridad);
    var centro_y = irandom_range(margen_seguridad, room_height - margen_seguridad);

    // 2. VERIFICAR QUE EL CENTRO SEA SEGURO (Agua profunda, lejos de nieve)
    var zona_segura = true;
    
    // Check rápido: ¿El centro es agua?
    if (tilemap_get_at_pixel(global.tilemap_agua, centro_x, centro_y) == 0) zona_segura = false;
    
    // Check de perímetro (Arriba, Abajo, Izq, Der) para asegurar que no hay nieve cerca
    if (zona_segura) {
        if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y) > 0) zona_segura = false;
        if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x + margen_seguridad, centro_y) > 0) zona_segura = false;
        if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x - margen_seguridad, centro_y) > 0) zona_segura = false;
        if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y + margen_seguridad) > 0) zona_segura = false;
        if (tilemap_get_at_pixel(global.tilemap_nieve, centro_x, centro_y - margen_seguridad) > 0) zona_segura = false;
    }

    // 3. SI LA ZONA ES SEGURA, CREAMOS EL GRUPO
    if (zona_segura) {
        
        // Decidir cuántos peces tendrá este grupo (3 a 8)
        var num_peces = irandom_range(3, 8);
        
        // Asignar una dirección común para que el grupo empiece moviéndose junto
        var dir_grupo = irandom(359); 
        
        // Crear los peces individuales alrededor del centro
        repeat(num_peces) {
            // Desplazamiento aleatorio pequeño (para que no nazcan uno encima del otro)
            var offset_x = irandom_range(-40, 40);
            var offset_y = irandom_range(-40, 40);
            
            var p = instance_create_layer(centro_x + offset_x, centro_y + offset_y, "Instances", Pez);
            
            // Truco para que se mantengan en grupo un rato:
            // Todos nacen con la MISMA dirección y velocidad similar
            p.dir_movimiento = dir_grupo + irandom_range(-10, 10); // Pequeña variación natural
            p.velocidad_propia = random_range(0.4, 0.6); // Velocidad similar
        }
        
        grupos_creados++;
    }
}

show_debug_message("🐟 Cardúmenes creados: " + string(grupos_creados));
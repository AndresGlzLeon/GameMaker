/// @description DIBUJAR MAPA CON DECORACIÓN ORDENADA

// 1. LIMPIEZA
instance_destroy(obj_Igloo);
instance_destroy(obj_Pasto);

// 2. CÁLCULOS BÁSICOS
var radio = 3 + (nivel_isla * 2); 
var cx = ancho_celdas div 2;
var cy = alto_celdas div 2;

ds_grid_clear(global.grid_terreno, 0);
ds_grid_set_disk(global.grid_terreno, cx, cy, radio, 1);

// 3. PINTAR Y DECORAR
for (var _x = 0; _x < ancho_celdas; _x++) {
    for (var _y = 0; _y < alto_celdas; _y++) {
        
        var valor = global.grid_terreno[# _x, _y];
        
        if (valor == 1) {
            // === ES NIEVE ===
            tilemap_set(global.tilemap_nieve, 1, _x, _y);
            tilemap_set(global.tilemap_agua, 0, _x, _y);
            
            // --- GENERACIÓN DE DECORACIÓN ---
            
            // A. Zona Segura (Ni en el centro, ni en la orilla)
            var dist_celdas = point_distance(_x, _y, cx, cy);
            
            if (dist_celdas > 2 && dist_celdas < (radio - 2)) {
                
                var real_x = (_x * 64) + 32;
                var real_y = (_y * 64) + 32;
                var suerte = irandom(100);
                
                // B. INTENTAR PONER IGLÚ (Probabilidad 3%)
                // Subí un poco la probabilidad (de 2 a 3) porque el filtro de distancia
                // va a eliminar varios intentos, así compensamos.
                if (suerte < 3) {
                    
                    // --- FILTRO DE SEPARACIÓN (NUEVO) ---
                    // Checamos un radio de 150 pixeles alrededor.
                    // Si NO hay colisión con otro iglú, construimos.
                    if (!collision_circle(real_x, real_y, 150, obj_Igloo, false, true)) {
                        instance_create_layer(real_x, real_y, "Instances", obj_Igloo);
                    }
                }
                
                // C. INTENTAR PONER PASTO (Probabilidad 15%)
                // Usamos 'else' para no poner pasto dentro de un iglú recién creado
                else if (suerte < 15) {
                    // Validamos también que no haya un iglú (por si acaso el de arriba falló o es vecino)
                    if (!place_meeting(real_x, real_y, obj_Igloo)) {
                        var azar_x = real_x + irandom_range(-20, 20);
                        var azar_y = real_y + irandom_range(-20, 20);
                        instance_create_layer(azar_x, azar_y, "Instances", obj_Pasto);
                    }
                }
            }
        } 
        else {
            // === ES AGUA ===
            tilemap_set(global.tilemap_nieve, 0, _x, _y);
            tilemap_set(global.tilemap_agua, 1, _x, _y);
        }
    }
}

// 4. RESCATE DE ORCAS (Hacia afuera)
var radio_px = radio * 64; 
var centro_x_px = room_width / 2;
var centro_y_px = room_height / 2;

with (orca) {
    if (point_distance(x, y, centro_x_px, centro_y_px) < radio_px) {
        var dir = point_direction(centro_x_px, centro_y_px, x, y);
        x = centro_x_px + lengthdir_x(radio_px + 80, dir);
        y = centro_y_px + lengthdir_y(radio_px + 80, dir);
        estado = "PATRULLAR";
        objetivo = noone;
        effect_create_above(ef_ring, x, y, 2, c_red);
    }
}

// 5. RESCATE DE FOCAS (Hacia adentro)
var tipos = [Foca1, Foca2];
for (var i = 0; i < 2; i++) {
    with (tipos[i]) {
        if (place_meeting(x, y, obj_Igloo)) {
            var dir_safe = point_direction(x, y, centro_x_px, centro_y_px);
            x += lengthdir_x(64, dir_safe);
            y += lengthdir_y(64, dir_safe);
            effect_create_above(ef_smoke, x, y, 0, c_white);
        }
    }
	
	// ... (El resto del código del mapa va arriba) ...

// =========================================================
//        5. RESCATE DE FOCAS (DESATASCADOR DE IGLÚS)
// =========================================================

var tipos = [Foca1, Foca2];

for (var i = 0; i < 2; i++) {
    
    with (tipos[i]) {
        
        // 1. DETECTAR SI ME CONSTRUYERON ENCIMA
        // instance_place me dice CUÁL iglú me está aplastando
        var igloo_encima = instance_place(x, y, obj_Igloo);
        
        if (igloo_encima != noone) {
            
            // 2. CALCULAR RUTA DE ESCAPE
            // Hacia el lado contrario del centro del iglú
            var dir_escape = point_direction(igloo_encima.x, igloo_encima.y, x, y);
            
            // 3. EMPUJAR HASTA SALIR (Bucle while)
            // "Mientras siga tocando el iglú, muéveme 5 pixeles más allá"
            var seguridad = 0; // Para evitar bucles infinitos
            
            while (place_meeting(x, y, obj_Igloo) && seguridad < 50) {
                x += lengthdir_x(10, dir_escape);
                y += lengthdir_y(10, dir_escape);
                seguridad++;
            }
            
            // 4. SEGURIDAD: ¿ME EMPUJARON AL AGUA?
            // Si después de salir del iglú caí al mar, corro al centro del mapa
            if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) == 0) {
                var dir_centro = point_direction(x, y, room_width/2, room_height/2);
                
                // Salto grande hacia el centro para asegurar nieve
                x += lengthdir_x(80, dir_centro);
                y += lengthdir_y(80, dir_centro);
            }
            
            // Efecto visual para confirmar que funcionó
            effect_create_above(ef_cloud, x, y, 0, c_white);
        }
    }
}
}
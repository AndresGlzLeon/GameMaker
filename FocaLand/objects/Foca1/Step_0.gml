/// @description IA SUPREMA: Caza Manual, Estamina y Quiebre

if (!variable_global_exists("tilemap_nieve")) exit;

// =========================================================
//        PRIORIDAD 1: DETECTAR ORCAS (Instinto)
// =========================================================
var estoy_en_tierra = tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0;

if (!estoy_en_tierra && estado != "ESCAPANDO") {
    // Si existe el depredador
    if (instance_exists(orca)) { 
        var amenaza = instance_nearest(x, y, orca);
        
        // Si la orca está cerca (250px) -> ¡PÁNICO!
        if (amenaza != noone && point_distance(x, y, amenaza.x, amenaza.y) < 250) {
            estado = "ESCAPANDO";
            show_debug_message("¡ORCA! ¡CORRE!");
        }
    }
}

// =========================================================
//                  ESTADO: PASEAR (Tierra)
// =========================================================
if (estado == "PASEAR") {
    
    // 1. RECUPERARSE
    if (estamina < estamina_max) estamina += 1; // Recuperar aire
    cansada = false; 

    // 2. GESTIÓN DEL MIEDO (Trauma)
    if (cooldown_susto > 0) {
        cooldown_susto--; // Bajando el miedo
        velocidad_propia = 2.0; // Se mueve nerviosa
    } else {
        velocidad_propia = 1.5; // Calmada
        hambre++; 
    }
    
    // --- SALIDA AUTOMÁTICA DESACTIVADA (MODO COMANDANTE) ---
    /* // Si quisieras que salieran solas de nuevo, descomenta esto:
    if (hambre > limite_hambre && cooldown_susto <= 0) {
        estado = "IR_A_PESCAR";
        tiempo_en_agua = 0;
        dir_movimiento = point_direction(room_width/2, room_height/2, x, y) + irandom_range(-45, 45);
    }
    */

    // 3. MOVIMIENTO EN TIERRA (Rebotar en bordes de nieve)
    var _dx = lengthdir_x(velocidad_propia, dir_movimiento);
    var _dy = lengthdir_y(velocidad_propia, dir_movimiento);
    var choco = false;
    
    // Sensor de borde (40px)
    if (tilemap_get_at_pixel(global.tilemap_nieve, x + lengthdir_x(40, dir_movimiento), y) == 0) {
        _dx = -_dx; x -= sign(_dx)*2; choco = true;
    }
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y + lengthdir_y(40, dir_movimiento)) == 0) {
        _dy = -_dy; y -= sign(_dy)*2; choco = true;
    }
    
    if (choco) dir_movimiento = irandom(359);
    
// Movimiento con Colisión de Iglús
    // Solo me muevo si NO hay un iglú en el punto destino
    if (!place_meeting(x + _dx, y, obj_Igloo)) {
        x += _dx;
    }
    if (!place_meeting(x, y + _dy, obj_Igloo)) {
        y += _dy;
    }
    
    if (_dx != 0) image_xscale = sign(_dx);
}

// =========================================================
//             ESTADO: IR A PESCAR (Obedeciendo Orden)
// =========================================================
else if (estado == "IR_A_PESCAR") {
    
    // YA NO calculamos "dir_mar" aquí. Usamos "dir_movimiento" que nos dio el mouse.
    
    // Avanzar
    x += lengthdir_x(velocidad_propia, dir_movimiento);
    y += lengthdir_y(velocidad_propia, dir_movimiento);
    
    // Si piso agua (Tile 0), cambio a modo búsqueda
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) == 0) {
        estado = "BUSCANDO_PECES"; 
    }
    
    // Animación
    if (lengthdir_x(1, dir_movimiento) > 0) image_xscale = 1; else image_xscale = -1;
}

// =========================================================
//             ESTADO: BUSCANDO PECES (Nado)
// =========================================================
else if (estado == "BUSCANDO_PECES") {
    tiempo_en_agua++;
    
    // Si no encuentro nada, me rindo y vuelvo
    if (tiempo_en_agua > max_tiempo_agua) estado = "REGRESAR";

    // Nadar
    x += lengthdir_x(velocidad_caza, dir_movimiento);
    y += lengthdir_y(velocidad_caza, dir_movimiento);
    
    // Deambular en el agua
    if (irandom(100) == 0) dir_movimiento += irandom_range(-45, 45);
    if (x < 0 || x > room_width || y < 0 || y > room_height) dir_movimiento += 180;

    // DETECTAR PEZ
    var pez = instance_nearest(x, y, Pez);
    if (pez != noone && point_distance(x, y, pez.x, pez.y) < rango_vision) {
        estado = "PERSEGUIR";
        pez_objetivo = pez;
    }
    if (x > xprevious) image_xscale = 1; else image_xscale = -1;
}

// =========================================================
//                  ESTADO: PERSEGUIR (Ataque)
// =========================================================
else if (estado == "PERSEGUIR") {
    if (!instance_exists(pez_objetivo)) {
        estado = "BUSCANDO_PECES"; exit;
    }
    
    var dir_pez = point_direction(x, y, pez_objetivo.x, pez_objetivo.y);
    x += lengthdir_x(velocidad_caza, dir_pez);
    y += lengthdir_y(velocidad_caza, dir_pez);
    
    if (pez_objetivo.x - x != 0) image_xscale = sign(pez_objetivo.x - x);
}

// =========================================================
//                  ESTADO: REGRESAR (Con Red de Seguridad)
// =========================================================
else if (estado == "REGRESAR") {
    
    // --- RED DE SEGURIDAD (FIX) ---
    // Si ya estoy muy cerca del centro (radio de 200px),
    // asumo que estoy en la nieve y termino la misión.
    if (point_distance(x, y, room_width/2, room_height/2) < 200) {
        estado = "PASEAR";
        hambre = 0;
        cooldown_susto = 0; // Opcional: quitar miedo al llegar a casa
    }

    // ... (Aquí sigue tu código normal de movimiento y sensor de tiles) ...
    var dir_casa = point_direction(x, y, room_width/2, room_height/2);
    x += lengthdir_x(velocidad_caza, dir_casa);
    y += lengthdir_y(velocidad_caza, dir_casa);
    
    // El sensor de tiles original (déjalo por si detecta nieve antes de llegar al centro)
    var sensor_x = x + lengthdir_x(10, dir_casa);
    var sensor_y = y + lengthdir_y(10, dir_casa);
    
    if (tilemap_get_at_pixel(global.tilemap_nieve, sensor_x, sensor_y) > 0) {
        estado = "PASEAR";
        hambre = 0;
        x += lengthdir_x(60, dir_casa);
        y += lengthdir_y(60, dir_casa);
    }
    
    if (x > xprevious) image_xscale = 1; else image_xscale = -1;
}

// =========================================================
//        ESTADO: ESCAPANDO (Quiebre + Estamina)
// =========================================================
else if (estado == "ESCAPANDO") {
    
    var dir_escape = point_direction(x, y, room_width/2, room_height/2);
    var vel_actual = 0;
    var usar_turbo = false;
    
    // --- 1. DETECCIÓN DE PELIGRO Y CÁLCULO DE RUTA ---
    if (instance_exists(orca)) {
        var orca_cerca = instance_nearest(x, y, orca);
        
        if (orca_cerca != noone) {
            var dist = point_distance(x, y, orca_cerca.x, orca_cerca.y);
            var dir_orca = point_direction(x, y, orca_cerca.x, orca_cerca.y);
            
            // CASO A: ¡PELIGRO INMINENTE! (QUIEBRE)
            // Si está a menos de 100px, giro de 90 grados
            if (dist < 100) {
                dir_escape = dir_orca + 90; // Quiebre lateral
                usar_turbo = true; // Activar adrenalina
            }
            // CASO B: PELIGRO MEDIO (EVASIÓN INTELIGENTE)
            else {
                var dir_casa = point_direction(x, y, room_width/2, room_height/2);
                dir_escape = dir_casa;
                
                // Si la orca me bloquea el paso a casa, me desvío
                if (abs(angle_difference(dir_casa, dir_orca)) < 60) {
                     if (angle_difference(dir_casa, dir_orca) >= 0) dir_escape -= 80;
                     else dir_escape += 80;
                }
            }
        }
    }
    
    // --- 2. GESTIÓN DE ESTAMINA ---
    if (estamina > 0) {
        if (usar_turbo) {
            vel_actual = 5.5; // Velocidad Turbo
            estamina -= 2;    // Gasta doble energía
        } else {
            vel_actual = 4.0; // Velocidad Sprint Normal
            estamina -= 1;    // Gasta normal
        }
    } else {
        // AGOTADA
        vel_actual = 1.5; 
        cansada = true;
    }

    // 3. APLICAR MOVIMIENTO
    x += lengthdir_x(vel_actual, dir_escape);
    y += lengthdir_y(vel_actual, dir_escape);
    
    // 4. SALVACIÓN (Llegar a la nieve)
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0) {
        estado = "PASEAR";
        cooldown_susto = 600; // 10 segundos de miedo (no vuelve a salir)
        x += lengthdir_x(80, dir_escape);
        y += lengthdir_y(80, dir_escape);
    }
    
    // 5. ANIMACIÓN AUTOMÁTICA (Detecta si es Foca1 o Foca2)
    if (object_index == Foca2) { 
         if (x < xprevious) sprite_index = Foca1_L; else sprite_index = Foca1_R;
    } else { 
         if (x < xprevious) sprite_index = Foca1_L; else sprite_index = Foca1_R;
    }
    
    // Feedback Visual (Gris si está cansada)
    if (cansada) image_blend = c_gray; else image_blend = c_white;
}
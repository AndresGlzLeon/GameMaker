/// @description IA SUPREMA: Caza Manual, Estamina y Quiebre

if (!variable_global_exists("tilemap_nieve")) exit;

// ... (Inicio del Step) ...

// =========================================================
//        SISTEMA DE ENFERMEDAD (PERSISTENTE)
// =========================================================
var multiplicador_vel = 1.0; 

// 1. CONTAGIO: Si toco petróleo, reinicio el contador de enfermedad
if (place_meeting(x, y, Pollution)) {
    tiempo_enfermedad = duracion_veneno; // ¡20 segundos enfermo!
}

// 2. EFECTO DE ESTADO
if (tiempo_enfermedad > 0) {
    tiempo_enfermedad--; // Bajar contador
    
    // SÍNTOMAS:
    multiplicador_vel = 0.5; // Muy lento (50%)
    if (estamina > 0) estamina -= 0.5; // Drena energía constantemente
    
    // Feedback visual (Verde y parpadeo cuando se va a acabar)
    if (tiempo_enfermedad > 120 || (tiempo_enfermedad % 20 < 10)) {
        image_blend = c_lime; 
    } else {
        image_blend = c_white;
    }
} 
else {
    // SANO
    if (!cansada) image_blend = c_white;
}

// Aplicar velocidad (Asegúrate de usar tus variables vel_tierra_real...)
var vel_tierra_real = velocidad_propia * multiplicador_vel;
var vel_agua_real   = velocidad_caza * multiplicador_vel;

// ... (Resto del código de IA...)

// =========================================================
//        PRIORIDAD 1: DETECTAR ORCAS (Instinto)
// =========================================================
var estoy_en_tierra = tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0;

if (!estoy_en_tierra && estado != "ESCAPANDO") {
    // CORRECCIÓN: Usar el nombre correcto del objeto orca
    if (instance_exists(orca)) { 
        var amenaza = instance_nearest(x, y, orca);
        
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
    
    if (estamina < estamina_max) estamina += 1; 
    cansada = false; 

    if (cooldown_susto > 0) {
        cooldown_susto--; 
        velocidad_propia = 2.0; 
    } else {
        velocidad_propia = 1.5; 
        hambre++; 
    }
    
    // Movimiento
    var _dx = lengthdir_x(vel_tierra_real, dir_movimiento);
    var _dy = lengthdir_y(vel_tierra_real, dir_movimiento);
    var choco = false;
    
    if (tilemap_get_at_pixel(global.tilemap_nieve, x + lengthdir_x(40, dir_movimiento), y) == 0) {
        _dx = -_dx; x -= sign(_dx)*2; choco = true;
    }
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y + lengthdir_y(40, dir_movimiento)) == 0) {
        _dy = -_dy; y -= sign(_dy)*2; choco = true;
    }
    
    if (choco) dir_movimiento = irandom(359);
    
    // Evitar Iglús
    if (!place_meeting(x + _dx, y, obj_Igloo)) x += _dx;
    if (!place_meeting(x, y + _dy, obj_Igloo)) y += _dy;
    
    if (_dx != 0) image_xscale = sign(_dx);
}

// =========================================================
//             ESTADO: IR A PESCAR (Salida)
// =========================================================
else if (estado == "IR_A_PESCAR") {
    
    x += lengthdir_x(vel_tierra_real, dir_movimiento);
    y += lengthdir_y(vel_tierra_real, dir_movimiento);
    
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) == 0) {
        estado = "BUSCANDO_PECES"; 
    }
    if (lengthdir_x(1, dir_movimiento) > 0) image_xscale = 1; else image_xscale = -1;
}

// =========================================================
//             ESTADO: BUSCANDO PECES (Nado)
// =========================================================
else if (estado == "BUSCANDO_PECES") {
    tiempo_en_agua++;
    if (tiempo_en_agua > max_tiempo_agua) estado = "REGRESAR";

    x += lengthdir_x(vel_agua_real, dir_movimiento);
    y += lengthdir_y(vel_agua_real, dir_movimiento);
    
    if (irandom(100) == 0) dir_movimiento += irandom_range(-45, 45);
    if (x < 0 || x > room_width || y < 0 || y > room_height) dir_movimiento += 180;

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
    x += lengthdir_x(vel_agua_real, dir_pez);
    y += lengthdir_y(vel_agua_real, dir_pez);
    
    if (pez_objetivo.x - x != 0) image_xscale = sign(pez_objetivo.x - x);
}

// =========================================================
//                  ESTADO: REGRESAR (Retorno)
// =========================================================
else if (estado == "REGRESAR") {
    
    // FIX DE SEGURIDAD (Si estoy cerca del centro, llegué)
    if (point_distance(x, y, room_width/2, room_height/2) < 200) {
        estado = "PASEAR"; hambre = 0; cooldown_susto = 0;
    }

    var dir_casa = point_direction(x, y, room_width/2, room_height/2);
    x += lengthdir_x(vel_agua_real, dir_casa);
    y += lengthdir_y(vel_agua_real, dir_casa);
    
    // Sensor de nieve adelantado
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
    
    // DETECCIÓN INTELIGENTE
    if (instance_exists(orca)) {
        var orca_cerca = instance_nearest(x, y, orca);
        
        if (orca_cerca != noone) {
            var dist = point_distance(x, y, orca_cerca.x, orca_cerca.y);
            var dir_orca = point_direction(x, y, orca_cerca.x, orca_cerca.y);
            
            // Quiebre (Pánico Cercano)
            if (dist < 100) {
                dir_escape = dir_orca + 90; 
                usar_turbo = true; 
            }
            // Evasión Lejana
            else {
                var dir_casa = point_direction(x, y, room_width/2, room_height/2);
                dir_escape = dir_casa;
                if (abs(angle_difference(dir_casa, dir_orca)) < 60) {
                     if (angle_difference(dir_casa, dir_orca) >= 0) dir_escape -= 80;
                     else dir_escape += 80;
                }
            }
        }
    }
    
    // ESTAMINA
    if (estamina > 0) {
        if (usar_turbo) { vel_actual = 5.5; estamina -= 2; } 
        else { vel_actual = 4.0; estamina -= 1; }
    } else {
        vel_actual = 1.5; cansada = true;
    }

    // Aplicar enfermedad
    vel_actual = vel_actual * multiplicador_vel;

    x += lengthdir_x(vel_actual, dir_escape);
    y += lengthdir_y(vel_actual, dir_escape);
    
    // Salvación
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0) {
        estado = "PASEAR";
        cooldown_susto = 600; 
        x += lengthdir_x(80, dir_escape);
        y += lengthdir_y(80, dir_escape);
    }
    
    // ANIMACIÓN (¡Aquí está la corrección!)
    // Para Foca2
    if (x < xprevious) sprite_index = Foca2_L; else sprite_index = Foca2_R;
    
    if (cansada) image_blend = c_gray; 
}
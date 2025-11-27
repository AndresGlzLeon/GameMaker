/// @description IA: Pasear, Cazar y Volver

// Seguridad: Si no hay mapa, no hacemos nada para evitar crash
if (!variable_global_exists("tilemap_nieve") || global.tilemap_nieve == -1) exit;

// =========================================================
//                  ESTADO 1: PASEAR (En Tierra)
// =========================================================
if (estado == "PASEAR") {
    
    // 1. CALCULAR MOVIMIENTO NORMAL
    var _dx = lengthdir_x(velocidad_propia, dir_movimiento);
    var _dy = lengthdir_y(velocidad_propia, dir_movimiento);
    var choco = false;
    
    // 2. EVITAR SALIRSE DE LA NIEVE (Sensor de 40px)
    // Si el punto futuro NO es nieve (es 0), rebotamos.
    if (tilemap_get_at_pixel(global.tilemap_nieve, x + lengthdir_x(40, dir_movimiento), y) == 0) {
        _dx = -_dx; 
        x -= sign(_dx) * 2; // Empujón hacia atrás
        choco = true;
    }
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y + lengthdir_y(40, dir_movimiento)) == 0) {
        _dy = -_dy; 
        y -= sign(_dy) * 2; // Empujón hacia atrás
        choco = true;
    }
    
    // Si chocó contra el borde de la isla, cambia de rumbo
    if (choco) dir_movimiento = irandom(359);
    
    // Aplicar movimiento
    x += _dx;
    y += _dy;
    
    // 3. BUSCAR PECES (Transición a CAZAR)
    // Escaneamos el pez más cercano
    var pez = instance_nearest(x, y, Pez);
    
    // Si existe y está dentro del rango de visión...
    if (pez != noone && point_distance(x, y, pez.x, pez.y) < rango_vision) {
        estado = "CAZAR";
        pez_objetivo = pez;
        // Opcional: Sonido de alerta o exclamación visual
    }
    
    // ANIMACIÓN (Sprites GRISES)
    if (_dx < 0) sprite_index = Foca1_L;
    else if (_dx > 0) sprite_index = Foca1_R;
}

// =========================================================
//                  ESTADO 2: CAZAR (En Agua)
// =========================================================
else if (estado == "CAZAR") {
    
    // Si el pez ya no existe (otra foca se lo ganó), volver a casa
    if (!instance_exists(pez_objetivo)) {
        estado = "REGRESAR";
        exit;
    }
    
    // Perseguir al pez (ignorando límites de nieve)
    var dir_al_pez = point_direction(x, y, pez_objetivo.x, pez_objetivo.y);
    
    var _dx = lengthdir_x(velocidad_caza, dir_al_pez);
    var _dy = lengthdir_y(velocidad_caza, dir_al_pez);
    
    x += _dx;
    y += _dy;
    
    // ANIMACIÓN (Mirar al pez)
    if (_dx < 0) sprite_index = Foca1_L;
    else if (_dx > 0) sprite_index = Foca1_R;
}

// =========================================================
//                  ESTADO 3: REGRESAR (A la Isla)
// =========================================================
else if (estado == "REGRESAR") {
    
    // Ir hacia el centro del mapa (siempre seguro en tu juego)
    var dir_casa = point_direction(x, y, room_width/2, room_height/2);
    
    var _dx = lengthdir_x(velocidad_propia, dir_casa);
    var _dy = lengthdir_y(velocidad_propia, dir_casa);
    
    x += _dx;
    y += _dy;
    
    // Si tocamos nieve de nuevo (Tile > 0), volvemos a pasear
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0) {
        estado = "PASEAR";
        // Nos adentramos un poco extra para no quedarnos en el borde
        x += lengthdir_x(30, dir_casa); 
        y += lengthdir_y(30, dir_casa);
    }
    
    // ANIMACIÓN
    if (_dx < 0) sprite_index = Foca1_L;
    else if (_dx > 0) sprite_index = Foca1_R;
}
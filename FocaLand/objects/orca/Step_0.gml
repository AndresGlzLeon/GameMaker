/// @description IA: Patrullar y Cazar Focas

if (!variable_global_exists("tilemap_nieve")) exit;

// =========================================================
//                  ESTADO 1: PATRULLAR
// =========================================================
if (estado == "PATRULLAR") {
    
    // 1. Movimiento
    var _dx = lengthdir_x(velocidad_patrulla, dir_movimiento);
    var _dy = lengthdir_y(velocidad_patrulla, dir_movimiento);
    var choco = false;

    // 2. EVITAR LA NIEVE (Rebotar si toca tierra)
    if (tilemap_get_at_pixel(global.tilemap_nieve, x + lengthdir_x(60, dir_movimiento), y) > 0) {
        _dx = -_dx; x -= sign(_dx)*5; choco = true;
    }
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y + lengthdir_y(60, dir_movimiento)) > 0) {
        _dy = -_dy; y -= sign(_dy)*5; choco = true;
    }
    
    // 3. REBOTAR EN BORDES DEL MUNDO
    if (x < 0 || x > room_width || y < 0 || y > room_height) {
        dir_movimiento += 180; choco = true;
    }

    if (choco) dir_movimiento = irandom(359);

    x += _dx;
    y += _dy;

    // 4. BUSCAR PRESAS (Focas en el agua)
    // Buscamos la más cercana de cualquier tipo (Gris o Negra)
    var foca_g = instance_nearest(x, y, Foca1);
    var foca_n = instance_nearest(x, y, Foca2);
    
    var posible_presa = noone;
    var dist = 99999;

    // Comparamos cuál está más cerca
    if (foca_g != noone) {
        var d = point_distance(x, y, foca_g.x, foca_g.y);
        if (d < dist) { dist = d; posible_presa = foca_g; }
    }
    if (foca_n != noone) {
        var d = point_distance(x, y, foca_n.x, foca_n.y);
        if (d < dist) { dist = d; posible_presa = foca_n; }
    }

    // SI ENCONTRÓ UNA Y ESTÁ CERCA
    if (posible_presa != noone && dist < radio_deteccion) {
        // Regla de Oro: La orca solo ataca si la foca NO está en tierra
        if (tilemap_get_at_pixel(global.tilemap_nieve, posible_presa.x, posible_presa.y) == 0) {
            estado = "PERSEGUIR";
            objetivo = posible_presa;
        }
    }
    
    // Animación
    if (_dx != 0) image_xscale = sign(_dx);
}

// =========================================================
//                  ESTADO 2: PERSEGUIR
// =========================================================
else if (estado == "PERSEGUIR") {
    
    // Si la foca ya no existe o se subió a la nieve -> Dejar de perseguir
    if (!instance_exists(objetivo)) { estado = "PATRULLAR"; exit; }
    
    // Check si se salvó subiendo a la nieve
    if (tilemap_get_at_pixel(global.tilemap_nieve, objetivo.x, objetivo.y) > 0) {
        estado = "PATRULLAR";
        exit;
    }

    // Perseguir
    var dir = point_direction(x, y, objetivo.x, objetivo.y);
    x += lengthdir_x(velocidad_caza, dir);
    y += lengthdir_y(velocidad_caza, dir);
    
    // Animación
    if (objetivo.x - x != 0) image_xscale = sign(objetivo.x - x);
}
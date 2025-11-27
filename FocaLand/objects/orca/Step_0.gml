/// @description IA: Patrullar y Cazar Focas

if (!variable_global_exists("tilemap_nieve")) exit;

// =========================================================
//                  ESTADO 1: PATRULLAR
// =========================================================
if (estado == "PATRULLAR") {
    
    // ... (Tu código de movimiento y choque con nieve sigue aquí) ...
    // x += _dx;
    // y += _dy;

    // --- NUEVO: INSTINTO DE ACECHO (Mantenerse cerca de la isla) ---
    var dist_centro = point_distance(x, y, room_width/2, room_height/2);
    
    // Si la orca se aleja más de 1500 pixeles del centro...
    if (dist_centro > 1500) {
        // ...gira suavemente para volver a la zona de caza
        var dir_centro = point_direction(x, y, room_width/2, room_height/2);
        
        // Lerp de ángulo para que gire natural y no de golpe
        var diff = angle_difference(dir_movimiento, dir_centro);
        dir_movimiento -= diff * 0.05; // Giro suave
    }
    
    // ... (El resto de tu código de buscar presas sigue aquí) ...
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
/// @description Nadar y rebotar en la isla

// Movimiento simple
x += lengthdir_x(0.5, dir_movimiento); // Velocidad 0.5 (lento)
y += lengthdir_y(0.5, dir_movimiento);

var choco = false;

// SENSOR DE NIEVE (Evitar encallar)
// Si toco nieve (Tile > 0), reboto.
if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0) {
    // Rebotar hacia el lado contrario
    dir_movimiento = point_direction(x, y, room_width/2, room_height/2) + 180; 
    
    // Empujón fuerte hacia el agua
    x += lengthdir_x(5, dir_movimiento);
    y += lengthdir_y(5, dir_movimiento);
    
    choco = true;
}

// Rebotar en bordes de la pantalla
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    dir_movimiento += 180;
    choco = true;
}

// Cambiar rumbo al azar a veces
if (irandom(200) == 0 || choco) {
    dir_movimiento += irandom_range(-45, 45);
}

// Animación Espejo
if (choose(true, false)) image_xscale = 1; // Pez simple
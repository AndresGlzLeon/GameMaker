/// Movimiento aleatorio simple
if (!variable_global_exists("velocidad_foca")) {
    variable_global_set("velocidad_foca", 1);
}

if (irandom(100) == 0) {
    direction = irandom(359);
}

x += lengthdir_x(global.velocidad_foca, direction);
y += lengthdir_y(global.velocidad_foca, direction);

// Evitar salir de la room
if (x < 0 || x > room_width) direction = 180 - direction;
if (y < 0 || y > room_height) direction = 360 - direction;


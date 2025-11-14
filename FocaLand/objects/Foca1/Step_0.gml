/// Movimiento aleatorio simple con animaciones L/R
if (!variable_global_exists("velocidad_foca")) {
    variable_global_set("velocidad_foca", 1);
}

// Dirección aleatoria en 360°
if (irandom(100) == 0) {
    direction = irandom(359);
}

// Movimiento
x += lengthdir_x(global.velocidad_foca, direction);
y += lengthdir_y(global.velocidad_foca, direction);

// Selección de sprite según dirección
// Si el ángulo está entre 90° y 270° → izquierda
// Si está entre 270° y 90° → derecha
if (direction >= 90 && direction < 270) {
    sprite_index = Foca1_L;
} else {
    sprite_index = Foca1_R;
}

// Evitar salir de la room
if (x < 0 || x > room_width) direction = 180 - direction;
if (y < 0 || y > room_height) direction = 360 - direction;

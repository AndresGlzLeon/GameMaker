/// @description Orientación automática

// Si se mueve a la izquierda (velocidad horizontal negativa)
if (hspeed < 0) {
    image_xscale = -1; // Voltea el sprite horizontalmente
}
// Si se mueve a la derecha
else if (hspeed > 0) {
    image_xscale = 1;  // Sprite normal
}

// Rebotar en la pantalla (o usa move_wrap si prefieres que aparezcan por el otro lado)
move_bounce_solid(true);

// O limitar al mapa (simple)
if (x < 0 || x > room_width) hspeed *= -1;
if (y < 0 || y > room_height) vspeed *= -1;
// Velocidades iniciales
velocidad_x = 0;
velocidad_y = 0;

// Velocidad base de movimiento
rapidez = 2;

// Dirección inicial aleatoria
if (choose(true, false)) {
    velocidad_x = choose(-rapidez, rapidez);
} else {
    velocidad_y = choose(-rapidez, rapidez);
}

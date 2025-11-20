/// @description Cambiar dirección

dir_movimiento = irandom(359);

// Reiniciar la alarma aleatoriamente entre 1 y 3 segundos
var tiempo_min = game_get_speed(gamespeed_fps) * 1;
var tiempo_max = game_get_speed(gamespeed_fps) * 3;
alarm[0] = irandom_range(tiempo_min, tiempo_max);
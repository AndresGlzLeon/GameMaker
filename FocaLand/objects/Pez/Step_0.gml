/// @description Sistema Anti-Nieve y Anti-Bordes

if (global.mapa_agua == -1 || global.mapa_nieve == -1) exit;

// --- CONFIGURACIÓN DEL SENSOR ---
// Distancia desde la nariz del pez.
// 40 pixeles es suficiente para ver la nieve venir y girar antes de tocarla.
var distancia_sensor = 40; 

var _dx = lengthdir_x(velocidad_propia, dir_movimiento);
var _dy = lengthdir_y(velocidad_propia, dir_movimiento);
var choco = false;

// -----------------------------
// 1. SENSOR HORIZONTAL (X)
// -----------------------------

// Truco Pro: ¿Desde dónde sale el sensor?
// Si voy a la derecha, mido desde mi borde derecho (bbox_right).
// Si voy a la izquierda, mido desde mi borde izquierdo (bbox_left).
var origen_sensor_x = (_dx > 0) ? bbox_right : bbox_left;

// Calculamos dónde cae la punta del sensor
var punta_sensor_x = origen_sensor_x + lengthdir_x(distancia_sensor, dir_movimiento);

// CHEQUEO DOBLE:
// A) ¿Se acaba el agua? (tile == 0)
// B) ¿Hay nieve? (tile > 0 en el mapa de nieve)
var fin_del_agua_x = tilemap_get_at_pixel(global.mapa_agua, punta_sensor_x, y) == 0;
var hay_nieve_x    = tilemap_get_at_pixel(global.mapa_nieve, punta_sensor_x, y) > 0;

if (fin_del_agua_x || hay_nieve_x) {
    _dx = -_dx; // Rebotar
    x -= sign(_dx) * 2; // Alejarse un poco
    choco = true;
}

// -----------------------------
// 2. SENSOR VERTICAL (Y)
// -----------------------------

var origen_sensor_y = (_dy > 0) ? bbox_bottom : bbox_top;
var punta_sensor_y = origen_sensor_y + lengthdir_y(distancia_sensor, dir_movimiento);

var fin_del_agua_y = tilemap_get_at_pixel(global.mapa_agua, x, punta_sensor_y) == 0;
var hay_nieve_y    = tilemap_get_at_pixel(global.mapa_nieve, x, punta_sensor_y) > 0;

if (fin_del_agua_y || hay_nieve_y) {
    _dy = -_dy; // Rebotar
    y -= sign(_dy) * 2; // Alejarse un poco
    choco = true;
}

// -----------------------------
// 3. APLICAR RESULTADO
// -----------------------------

if (choco) {
    dir_movimiento = point_direction(0, 0, _dx, _dy);
    dir_movimiento += irandom_range(-20, 20); // Giro natural
}

x += _dx;
y += _dy;

// Animación Espejo
if (_dx != 0) image_xscale = sign(_dx);
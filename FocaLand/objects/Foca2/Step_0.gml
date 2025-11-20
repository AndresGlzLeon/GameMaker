/// @description Movimiento con "Sensores Largos"

// Seguridad: Si no hay mapa, no hacer nada
if (!variable_global_exists("mapa_nieve") || global.mapa_nieve == -1) exit;

// 1. CONFIGURACIÓN DEL SENSOR
// Esto es la distancia "hacia adelante" que mirará la foca.
// Si tu sprite mide 64px de ancho, la mitad es 32.
// Ponemos 40 para que detecte el borde 8 píxeles ANTES de tocarlo.
var distancia_sensor = 40; 

// 2. CALCULAR INTENCIÓN DE MOVIMIENTO
var _dx = lengthdir_x(velocidad_propia, dir_movimiento);
var _dy = lengthdir_y(velocidad_propia, dir_movimiento);

var choco = false;

// 3. SENSOR HORIZONTAL (X)
// Miramos hacia donde apunta la nariz (dir_movimiento) en el eje X
var sensor_x = lengthdir_x(distancia_sensor, dir_movimiento);

// Verificamos esa posición adelantada
if (tilemap_get_at_pixel(global.mapa_nieve, x + sensor_x, y) == 0) {
    // ¡Se acaba la nieve!
    _dx = -_dx; // Invertir fuerza X
    
    // TRUCO ANTI-TRABAS:
    // Si detecta borde, empujamos a la foca un poquito hacia atrás
    // para asegurar que no se quede pegada en la línea.
    x -= sign(sensor_x) * 2; 
    
    choco = true;
}

// 4. SENSOR VERTICAL (Y)
// Miramos hacia donde apunta la nariz en el eje Y
var sensor_y = lengthdir_y(distancia_sensor, dir_movimiento);

if (tilemap_get_at_pixel(global.mapa_nieve, x, y + sensor_y) == 0) {
    // ¡Se acaba la nieve!
    _dy = -_dy; // Invertir fuerza Y
    y -= sign(sensor_y) * 2; // Empujoncito de seguridad hacia atrás
    choco = true;
}

// 5. RECALCULAR DIRECCIÓN SI CHOCÓ
if (choco) {
    // Calculamos el nuevo ángulo basado en el rebote
    dir_movimiento = point_direction(0, 0, _dx, _dy);
    
    // Añadimos un pequeño cambio aleatorio para que no reboten siempre en linea recta perfecta
    dir_movimiento += irandom_range(-10, 10);
}

// 6. APLICAR MOVIMIENTO FINAL
x += _dx;
y += _dy;

// 7. ANIMACIÓN (AQUÍ ELIGES SEGÚN SI ES FOCA1 O FOCA2)
// ---------------------------------------------------------


// CASO FOCA 2 (NEGRA) - Copia esto si es el objeto Foca2
if (object_index == Foca2) {
    if (_dx < -0.1) sprite_index = Foca2_L; 
    else if (_dx > 0.1) sprite_index = Foca2_R;
}
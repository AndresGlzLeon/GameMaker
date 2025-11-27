/// @description Configuración Visual y Vida

// --- 1. APARIENCIA ---
image_blend = c_white; // Usar colores originales del sprite (para ver textura)
image_alpha = 0.9;     // Casi sólido pero un poco transparente

// Tamaño variado
var escala = random_range(0.8, 1.3);
image_xscale = escala;
image_yscale = escala;

image_angle = irandom(360);
image_speed = 0.2; // Velocidad de animación si tienes frames

// Variable para animación de respiración
tiempo = irandom(100); 

// --- 2. TIEMPO DE VIDA (La corrección) ---
duracion_segundos = 30; // Durará 30 segundos en el agua
vida = game_get_speed(gamespeed_fps) * duracion_segundos; 
desvaneciendo = false;  // Interruptor para iniciar el fade out
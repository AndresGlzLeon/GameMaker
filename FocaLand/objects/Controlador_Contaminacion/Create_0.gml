/// @description Temporizador de Desastres
alarm[0] = 300; // Empieza en 5 segundos
// ... (Tu configuración visual anterior se queda igual) ...

// --- TIEMPO DE VIDA ---
duracion_segundos = 30; // ¿Cuánto dura la mancha en el agua?
vida = game_get_speed(gamespeed_fps) * duracion_segundos; 
desvaneciendo = false; // Estado para saber si ya se está yendo
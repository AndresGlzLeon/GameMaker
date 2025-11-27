/// @description Configuración de la Cámara

// 1. Obtener la cámara actual de la Room
cam = view_camera[0];

// 2. Definir la resolución base (Full HD)
base_w = 1920;
base_h = 1280;

// 3. Variables de Zoom
zoom_nivel = 1.0;       // 1 = Normal, 0.5 = Cerca, 2 = Lejos
zoom_destino = 1.0;     // Para suavizar el movimiento (Lerp)

// 4. Variables para Arrastrar con Mouse (Drag)
drag_x = 0;
drag_y = 0;
dragging = false; // ¿Estamos arrastrando?
/// @description Configuración UI y Lógica

global.pescado_capturado = 0;
cantidad_a_enviar = 1; // Empezamos con 1 por seguridad
focas_disponibles = 0; // Variable para saber el límite real

menu_abierto = false;

// --- CONFIGURACIÓN VISUAL (Igual que antes) ---
main_w = 200; main_h = 50;
main_x = (display_get_gui_width()/2) - (main_w/2);
main_y = display_get_gui_height() - 60;

panel_w = 300; panel_h = 80;
panel_x = (display_get_gui_width()/2) - (panel_w/2);
panel_y = main_y - panel_h - 10;

btn_size = 40;
btn_minus_x = panel_x + 20; btn_minus_y = panel_y + 20;
btn_plus_x = panel_x + panel_w - 60; btn_plus_y = panel_y + 20;

draw_set_font(-1);
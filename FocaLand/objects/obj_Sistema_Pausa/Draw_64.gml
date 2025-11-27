/// @description DIBUJAR INTERFAZ

// 1. DIBUJAR BOTÓN PEQUEÑO "MENÚ" (Siempre visible si no hay pausa)
if (!pausa) {
    draw_set_color(c_dkgray); // Fondo botón
    draw_roundrect(btn_x, btn_y, btn_x + btn_ancho, btn_y + btn_alto, false);
    
    draw_set_color(c_white); // Borde
    draw_roundrect(btn_x, btn_y, btn_x + btn_ancho, btn_y + btn_alto, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + (btn_ancho/2), btn_y + (btn_alto/2), "MENU");
}

// 2. DIBUJAR PANTALLA DE PAUSA (Solo si pausa == true)
if (pausa) {
    var ancho = display_get_gui_width();
    var alto = display_get_gui_height();
    var cx = ancho / 2;
    var cy = alto / 2;
    
    // Fondo negro semitransparente (Efecto oscurecer)
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, ancho, alto, false);
    draw_set_alpha(1);
    
    // Título "PAUSA"
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed(cx, cy - 100, "JUEGO PAUSADO", 2, 2, 0);
    
    // --- BOTÓN CONTINUAR ---
    var mouse_sobre_cont = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), cx - 100, cy - 40, cx + 100, cy);
    draw_set_color(mouse_sobre_cont ? c_yellow : c_gray); // Cambia color si pasas el mouse
    draw_roundrect(cx - 100, cy - 40, cx + 100, cy, false);
    
    draw_set_color(c_black);
    draw_text(cx, cy - 20, "CONTINUAR");
    
    // --- BOTÓN SALIR ---
    var mouse_sobre_salir = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), cx - 100, cy + 20, cx + 100, cy + 60);
    draw_set_color(mouse_sobre_salir ? c_red : c_gray);
    draw_roundrect(cx - 100, cy + 20, cx + 100, cy + 60, false);
    
    draw_set_color(c_white);
    draw_text(cx, cy + 40, "SALIR AL MENU");
}

// Resetear alineación
draw_set_halign(fa_left);
draw_set_valign(fa_top);
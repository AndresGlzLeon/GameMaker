/// @description PAUSA CON BOTÓN GUARDAR

var ancho = display_get_gui_width();
var alto = display_get_gui_height();
var color_fondo_caja = make_color_rgb(10, 20, 40);

// --- 1. BOTÓN PEQUEÑO "MENU" (Si no hay pausa) ---
if (!pausa) {
    // (Este código es igual al anterior, lo mantenemos simple)
    draw_set_font(fnt_Botones);
    var hover_btn = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), btn_x, btn_y, btn_x + btn_ancho, btn_y + btn_alto);
    
    draw_set_color(color_fondo_caja); draw_set_alpha(0.7);
    draw_roundrect(btn_x, btn_y, btn_x + btn_ancho, btn_y + btn_alto, false);
    
    draw_set_alpha(1); draw_set_color(hover_btn ? c_aqua : c_gray);
    draw_roundrect(btn_x, btn_y, btn_x + btn_ancho, btn_y + btn_alto, true);
    
    draw_set_color(c_white); draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(btn_x + btn_ancho/2, btn_y + btn_alto/2, "MENU");
}

// --- 2. PANTALLA DE PAUSA (Con 3 Botones) ---
if (pausa) {
    var cx = ancho / 2;
    var cy = alto / 2;
    
    // Fondo oscuro
    draw_set_color(make_color_rgb(5, 10, 25)); draw_set_alpha(0.85);
    draw_rectangle(0, 0, ancho, alto, false); draw_set_alpha(1);
    
    // Título
    draw_set_font(fnt_Titulo); draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text_color(cx, cy - 140, "PAUSA", c_white, c_white, c_aqua, c_blue, 1);
    
    // --- LÓGICA DE BOTONES ---
    draw_set_font(fnt_Botones);
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var click = mouse_check_button_pressed(mb_left);
    
    // COORDENADAS DE LOS 3 BOTONES (Separados por 60px)
    // 1. CONTINUAR
    var b1_y1 = cy - 60; var b1_y2 = cy - 10;
    // 2. GUARDAR
    var b2_y1 = cy;      var b2_y2 = cy + 50;
    // 3. SALIR
    var b3_y1 = cy + 60; var b3_y2 = cy + 110;
    
    var bx1 = cx - 120; var bx2 = cx + 120; // Ancho igual para todos
    
    // --- DIBUJAR BOTÓN 1: CONTINUAR ---
    var h1 = point_in_rectangle(mx, my, bx1, b1_y1, bx2, b1_y2);
    if (h1 && click) { pausa = false; instance_activate_all(); } // Acción
    
    draw_set_color(color_fondo_caja); draw_roundrect(bx1, b1_y1, bx2, b1_y2, false);
    draw_set_color(h1 ? c_lime : c_white); draw_roundrect(bx1, b1_y1, bx2, b1_y2, true);
    draw_text(cx, (b1_y1 + b1_y2)/2, "CONTINUAR");

    // --- DIBUJAR BOTÓN 2: GUARDAR ---
    var h2 = point_in_rectangle(mx, my, bx1, b2_y1, bx2, b2_y2);
    
    // CAMBIA ESTO:
    if (h2 && click) { 
        show_debug_message("CLICK EN GUARDAR DETECTADO"); // <--- MIRA ABAJO EN LA SALIDA
        guardar_partida_json(); 
    }
    draw_set_color(color_fondo_caja); draw_roundrect(bx1, b2_y1, bx2, b2_y2, false);
    draw_set_color(h2 ? c_yellow : c_white); draw_roundrect(bx1, b2_y1, bx2, b2_y2, true);
    draw_text(cx, (b2_y1 + b2_y2)/2, "GUARDAR PARTIDA");

    // --- DIBUJAR BOTÓN 3: SALIR ---
    var h3 = point_in_rectangle(mx, my, bx1, b3_y1, bx2, b3_y2);
    if (h3 && click) { instance_activate_all(); room_goto(rm_Menu); } // Acción
    
    draw_set_color(color_fondo_caja); draw_roundrect(bx1, b3_y1, bx2, b3_y2, false);
    draw_set_color(h3 ? c_red : c_ltgray); draw_roundrect(bx1, b3_y1, bx2, b3_y2, true);
    draw_text(cx, (b3_y1 + b3_y2)/2, "SALIR AL MENU");
}

// Reset
draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
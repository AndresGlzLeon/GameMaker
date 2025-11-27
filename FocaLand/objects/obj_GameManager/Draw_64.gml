/// @description INTERFAZ VISUAL MEJORADA

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Marcador
draw_set_color(c_black); draw_set_alpha(0.5);
draw_rectangle(10, 10, 200, 50, false);
draw_set_alpha(1); draw_set_color(c_white);
draw_text(20, 20, "🐟 Pescado: " + string(global.pescado_capturado));

// --- BOTÓN PRINCIPAL ---
var col_main = c_navy;
if (point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h)) col_main = c_blue;
if (menu_abierto) col_main = c_maroon; // Rojo oscuro para indicar "Cerrar/Retirada"

draw_set_color(col_main);
draw_rectangle(main_x, main_y, main_x+main_w, main_y+main_h, false);
draw_set_color(c_white);
draw_rectangle(main_x, main_y, main_x+main_w, main_y+main_h, true);

draw_set_halign(fa_center); draw_set_valign(fa_middle);

// CAMBIO DE TEXTO IMPORTANTE
if (menu_abierto) draw_text(main_x + main_w/2, main_y + main_h/2, "📢 ¡RETIRADA!");
else              draw_text(main_x + main_w/2, main_y + main_h/2, "⚓ CAZAR PECES");

// --- PANEL DESPLEGABLE ---
if (menu_abierto) {
    draw_set_color(c_dkgray);
    draw_rectangle(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, false);
    draw_set_color(c_white);
    draw_rectangle(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, true);
    
    // Título con estado
    var titulo = "Disponibles: " + string(focas_disponibles);
    if (focas_disponibles == 0) titulo = "¡NO HAY FOCAS!";
    draw_text(panel_x + panel_w/2, panel_y + 10, titulo);

    // [-]
    var col_min = c_gray;
    if (point_in_rectangle(mx, my, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size)) col_min = c_ltgray;
    draw_set_color(col_min);
    draw_rectangle(btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size, false);
    draw_set_color(c_black); draw_text(btn_minus_x + btn_size/2, btn_minus_y + btn_size/2, "-");

    // [+]
    var col_plus = c_gray;
    // Si ya seleccionamos todas las disponibles, oscurecemos el botón +
    if (cantidad_a_enviar >= focas_disponibles) col_plus = c_dkgray; 
    else if (point_in_rectangle(mx, my, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size)) col_plus = c_ltgray;
    
    draw_set_color(col_plus);
    draw_rectangle(btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size, false);
    draw_set_color(c_black); draw_text(btn_plus_x + btn_size/2, btn_plus_y + btn_size/2, "+");

    // NÚMERO CENTRAL (FORMATO: SELECCIONADO / TOTAL)
    draw_set_color(c_white);
    var texto_num = string(cantidad_a_enviar) + " / " + string(focas_disponibles);
    draw_text_transformed(panel_x + panel_w/2, panel_y + 45, texto_num, 1.5, 1.5, 0);
}

draw_set_halign(fa_left); draw_set_valign(fa_top);
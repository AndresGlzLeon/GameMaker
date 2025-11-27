/// @description INTERFAZ: Marcador, Botones y Menú

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// --- CÁLCULOS DE ECONOMÍA (Para mostrar precios reales) ---
var total_focas = instance_number(Foca1) + instance_number(Foca2);

// Fórmula de precio BARATO (la misma del Step)
var precio_unitario = 1 + floor(total_focas / 20); 
var costo_banquete = total_focas * precio_unitario;


// 1. MARCADOR DE PESCADO (Arriba Izquierda)
draw_set_color(c_black); draw_set_alpha(0.5);
draw_rectangle(10, 10, 220, 50, false);
draw_set_alpha(1); draw_set_color(c_white);
draw_set_halign(fa_left); draw_set_valign(fa_middle);
draw_text(20, 30, "🐟 Pescado: " + string(global.pescado_capturado));


// =========================================================
//           BOTÓN ALIMENTAR (¡AQUÍ ESTÁ!)
// =========================================================
var puede_alimentar = (global.pescado_capturado >= costo_banquete && total_focas >= 2);
var col_feed = c_dkgray;

if (puede_alimentar) col_feed = c_lime; // Verde si alcanza
// Hover
if (point_in_rectangle(mx, my, btn_feed_x, btn_feed_y, btn_feed_x+btn_feed_w, btn_feed_y+btn_feed_h)) {
    if (puede_alimentar) col_feed = c_green;
}

draw_set_color(col_feed);
draw_rectangle(btn_feed_x, btn_feed_y, btn_feed_x+btn_feed_w, btn_feed_y+btn_feed_h, false);
draw_set_color(c_white);
draw_rectangle(btn_feed_x, btn_feed_y, btn_feed_x+btn_feed_w, btn_feed_y+btn_feed_h, true);

draw_set_halign(fa_center);

var txt_feed = "ALIMENTAR (" + string(costo_banquete) + " 🐟)";
if (total_focas < 2) txt_feed = "FALTAN FOCAS";

draw_text(btn_feed_x + btn_feed_w/2, btn_feed_y + btn_feed_h/2, txt_feed);


// =========================================================
//           BOTÓN EXPANDIR
// =========================================================
var tiene_dinero = (global.pescado_capturado >= costo_expansion);
var col_exp = c_dkgray; 

if (tiene_dinero) col_exp = c_orange; 
// Hover
if (point_in_rectangle(mx, my, btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h)) {
    if (tiene_dinero) col_exp = c_yellow; 
}

draw_set_color(col_exp);
draw_rectangle(btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h, false);
draw_set_color(c_white);
draw_rectangle(btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h, true);

var txt_exp = "EXPANDIR (" + string(costo_expansion) + " 🐟)";
draw_text(btn_exp_x + btn_exp_w/2, btn_exp_y + btn_exp_h/2, txt_exp);


// =========================================================
//           MENÚ ESCUADRÓN (ABAJO)
// =========================================================

// --- Botón Principal ---
var hover_main = point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h);
var col_main = make_color_rgb(0, 50, 200); 
var txt_main = "CAZAR";
var ico = Foca1_R;

if (menu_abierto) {
    // Texto inteligente: Si hay focas fuera, dice RETIRADA
    if (focas_fuera > 0) { 
        col_main = make_color_rgb(200, 50, 50); 
        txt_main = "RETIRADA"; 
    } else { 
        col_main = c_dkgray; 
        txt_main = "CERRAR"; 
    }
}
if (hover_main) col_main = merge_color(col_main, c_white, 0.2);

draw_set_color(col_main);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, false);
draw_set_color(c_white);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, true);

// Icono y Texto
var isize = main_h - 14;
draw_sprite_stretched(ico, 0, main_x+10, main_y+7, isize, isize);
draw_text(main_x + isize + 20, main_y + main_h/2, txt_main);

// --- Panel Desplegable ---
if (menu_abierto) {
    draw_set_color(make_color_rgb(10, 20, 40));
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, false);
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, true);
    
    draw_text(panel_x + panel_w/2, panel_y + 12, "ESCUADRÓN");

    // Botones +/-
    var h_min = point_in_rectangle(mx, my, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size);
    draw_set_color(h_min ? c_white : c_gray);
    draw_rectangle(btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size, true);
    draw_text(btn_minus_x+btn_size/2, btn_minus_y+btn_size/2, "-");

    var h_plus = point_in_rectangle(mx, my, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size);
    var col_p = (cantidad_a_enviar >= focas_disponibles) ? c_dkgray : (h_plus ? c_white : c_gray);
    draw_set_color(col_p);
    draw_rectangle(btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size, true);
    draw_text(btn_plus_x+btn_size/2, btn_plus_y+btn_size/2, "+");

    // Número
    draw_set_color(c_white);
    var centro_x = panel_x + panel_w/2;
    var centro_y = panel_y + 55;
    draw_sprite_ext(ico, 0, centro_x - 35, centro_y, 1, 1, 0, c_white, 1);
    
    draw_set_halign(fa_left);
    draw_text_transformed(centro_x - 10, centro_y, string(cantidad_a_enviar)+"/"+string(focas_disponibles), 1.2, 1.2, 0);
}

// Reset final
draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
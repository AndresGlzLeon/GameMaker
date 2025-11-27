/// @description INTERFAZ COMANDANTE + EXPANSIÓN PRO

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// --- CONFIGURACIÓN DE FUENTE Y ALINEACIÓN ---
draw_set_font(fnt_Botones);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// =========================================================
//            1. BOTÓN EXPANSIÓN (MEJORADO)
// =========================================================

// Lógica de Estado
var tiene_dinero = (global.pescado_capturado >= costo_expansion);
var hover_exp = point_in_rectangle(mx, my, btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h);

// Colores: Dorado si alcanza, Gris oscuro si no
var col_btn_exp = make_color_rgb(255, 180, 50); // Dorado (Gold)
if (!tiene_dinero) col_btn_exp = make_color_rgb(60, 60, 70); // Gris apagado

// Efecto Brillo (Solo si tienes dinero y pasas el mouse)
var alpha_exp = 0.9;
if (tiene_dinero && hover_exp) {
    col_btn_exp = merge_color(col_btn_exp, c_white, 0.2); // Se ilumina
    alpha_exp = 1;
}

// DIBUJAR FONDO DEL BOTÓN (Redondeado para combinar)
draw_set_color(col_btn_exp);
draw_set_alpha(alpha_exp);
draw_roundrect(btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h, false);

// Borde (Blanco si alcanza, Gris si no)
draw_set_alpha(1);
draw_set_color(tiene_dinero ? c_white : c_gray);
draw_roundrect(btn_exp_x, btn_exp_y, btn_exp_x+btn_exp_w, btn_exp_y+btn_exp_h, true);

// --- CONTENIDO DEL BOTÓN (ICONO + TEXTO) ---

// 1. Título "EXPANDIR"
draw_set_halign(fa_center);
draw_set_color(c_white);
// Lo dibujamos un poco arriba del centro
draw_text(btn_exp_x + btn_exp_w/2, btn_exp_y + 15, "EXPANDIR");

// 2. Costo con Icono de Pez
var icono_costo = PezSprite; // <--- TU ICONO DE PESCADO
var costo_str = string(costo_expansion);

// Cálculos para centrar "Icono + Texto"
var ancho_icono = 20; 
var separacion = 5;
var ancho_texto = string_width(costo_str);
var total_ancho = ancho_icono + separacion + ancho_texto;
var inicio_x = btn_exp_x + (btn_exp_w / 2) - (total_ancho / 2);
var altura_y = btn_exp_y + 35; // Parte de abajo del botón

// Dibujar Icono Pez (Pequeño)
draw_sprite_stretched(icono_costo, 0, inicio_x, altura_y - 10, ancho_icono, ancho_icono);

// Dibujar Texto Precio
draw_set_halign(fa_left); // Alineamos a la izq para escribir después del icono
var col_precio = tiene_dinero ? c_lime : c_red; // Verde si alcanza, Rojo si falta
draw_set_color(col_precio);
draw_text(inicio_x + ancho_icono + separacion, altura_y, costo_str);


// =========================================================
//            2. MENÚ ESCUADRÓN (ESTILO ÁRTICO)
// =========================================================

// --- Botón Principal ---
var hover_main = point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h);

// Colores
var col_main = make_color_rgb(0, 100, 255); // Azul Brillante
var txt_main = "CAZAR";
var ico_main = Foca1_R; // Icono Foca

if (menu_abierto) {
    if (focas_fuera > 0) {
        col_main = make_color_rgb(255, 60, 60); // Rojo Alerta
        txt_main = "RETIRADA";
    } else {
        col_main = make_color_rgb(40, 40, 50); // Gris oscuro (Cerrar)
        txt_main = "CERRAR";
    }
}
// Hover
if (hover_main) col_main = merge_color(col_main, c_white, 0.2);

// Dibujar Botón
draw_set_color(col_main);
draw_set_alpha(hover_main ? 1 : 0.9);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, false);

// Borde
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, true);

// Icono y Texto
var isize = main_h - 14;
draw_sprite_stretched(ico_main, 0, main_x+10, main_y+7, isize, isize);

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(main_x + isize + 20, main_y + main_h/2, txt_main);


// --- Panel Desplegable ---
if (menu_abierto) {
    // Fondo Azul Profundo
    draw_set_color(make_color_rgb(10, 20, 40));
    draw_set_alpha(0.95);
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, false);
    
    // Borde Celeste
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, true);
    
    // Título
    draw_set_halign(fa_center);
    draw_text(panel_x + panel_w/2, panel_y + 12, "ESCUADRÓN");

    // Botones +/-
    var h_min = point_in_rectangle(mx, my, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size);
    draw_set_color(h_min ? c_white : c_gray);
    draw_rectangle(btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size, true); // Solo borde
    draw_text(btn_minus_x+btn_size/2, btn_minus_y+btn_size/2, "-");

    var h_plus = point_in_rectangle(mx, my, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size);
    // Lógica visual: Si llegamos al tope, se oscurece
    var col_p = (cantidad_a_enviar >= focas_disponibles) ? c_dkgray : (h_plus ? c_white : c_gray);
    
    draw_set_color(col_p);
    draw_rectangle(btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size, true); // Solo borde
    draw_text(btn_plus_x+btn_size/2, btn_plus_y+btn_size/2, "+");

    // Foca + Número Central
    var centro_x = panel_x + panel_w/2;
    var centro_y = panel_y + 55;
    
    // Dibujamos la foca a la izquierda del texto
    draw_sprite_ext(ico_main, 0, centro_x - 40, centro_y, 1, 1, 0, c_white, 1);
    
    // Número
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    var txt_num = string(cantidad_a_enviar)+"/"+string(focas_disponibles);
    draw_text_transformed(centro_x - 15, centro_y, txt_num, 1.2, 1.2, 0);
    
    // Etiqueta pequeña
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text_transformed(centro_x, centro_y + 20, "Listas", 0.7, 0.7, 0);
}

// Reset final obligatorio
draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white); draw_set_alpha(1);
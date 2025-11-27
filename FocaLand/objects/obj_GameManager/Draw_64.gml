/// @description INTERFAZ COMANDANTE (TEXTO BLANCO Y ACOMODADO)

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// --- 1. CONFIGURACIÓN DE COLORES ---
var col_fondo_ui = make_color_rgb(10, 20, 40);    // Fondo paneles
var col_borde    = make_color_rgb(100, 200, 255); // Celeste hielo
var col_accion   = make_color_rgb(0, 50, 200);    // Azul Real (Botón Cazar)
var col_alerta   = make_color_rgb(200, 50, 50);   // Rojo (Retirada)
var col_texto    = c_white;                       // ¡TEXTO SIEMPRE BLANCO!

// Configurar fuente
draw_set_font(fnt_Botones); 
draw_set_halign(fa_left); 
draw_set_valign(fa_middle);


// --- 2. BOTÓN PRINCIPAL ---
var hover_main = point_in_rectangle(mx, my, main_x, main_y, main_x+main_w, main_y+main_h);

// Lógica de Estado
var color_actual = col_accion;
var texto_btn = "CAZAR";
var icono_a_usar = Foca1_R; // Tu sprite

if (menu_abierto) {
    color_actual = col_alerta; 
    texto_btn = "RETIRADA";
}

// Efecto Hover (Brillo al pasar el mouse)
var alpha_btn = hover_main ? 1 : 0.9;
if (hover_main) {
    // Hacemos el color un poco más claro si pasas el mouse
    color_actual = merge_color(color_actual, c_white, 0.2); 
}

// DIBUJAR FONDO DEL BOTÓN
draw_set_color(color_actual);
draw_set_alpha(alpha_btn);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, false);

// DIBUJAR BORDE BLANCO
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(main_x, main_y, main_x+main_w, main_y+main_h, true);

// --- DIBUJAR ICONO Y TEXTO (ACOMODADOS) ---

// 1. Calculamos tamaño del icono (un poco más pequeño que el botón para dejar margen)
var icon_size = main_h - 14; 
var icon_y = main_y + 7; // Centrado verticalmente (7px de margen arriba)
var icon_x = main_x + 10; // Margen izquierdo

// Dibujar Icono
draw_sprite_stretched(icono_a_usar, 0, icon_x, icon_y, icon_size, icon_size);

// 2. Dibujar Texto (BLANCO)
draw_set_color(c_white); // <--- AQUÍ ESTÁ EL CAMBIO: SIEMPRE BLANCO
// Posición: A la derecha del icono + 10 pixeles de separación
draw_text(icon_x + icon_size + 10, main_y + main_h/2, texto_btn);



// --- 3. PANEL DESPLEGABLE ---
if (menu_abierto) {
    
    // Fondo oscuro
    draw_set_color(col_fondo_ui);
    draw_set_alpha(0.95);
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, false);
    
    // Borde
    draw_set_alpha(1);
    draw_set_color(col_borde);
    draw_roundrect(panel_x, panel_y, panel_x+panel_w, panel_y+panel_h, true);
    
    // TÍTULO (Ahora sí con acento, asegúrate de haber hecho el Paso 1)
    draw_set_halign(fa_center);
    draw_set_color(col_borde);
    draw_text(panel_x + panel_w/2, panel_y + 12, "ESCUADRÓN"); // Subí un poco el Y (era 15)
    
    // --- CONTROLES ---
    
    // [-]
    var h_min = point_in_rectangle(mx, my, btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size);
    draw_set_color(h_min ? c_white : c_gray);
    draw_rectangle(btn_minus_x, btn_minus_y, btn_minus_x+btn_size, btn_minus_y+btn_size, true);
    draw_text(btn_minus_x + btn_size/2, btn_minus_y + btn_size/2, "-");
    
    // [+]
    var h_plus = point_in_rectangle(mx, my, btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size);
    var col_plus = (cantidad_a_enviar >= focas_disponibles) ? c_dkgray : (h_plus ? c_white : c_gray);
    draw_set_color(col_plus);
    draw_rectangle(btn_plus_x, btn_plus_y, btn_plus_x+btn_size, btn_plus_y+btn_size, true);
    draw_text(btn_plus_x + btn_size/2, btn_plus_y + btn_size/2, "+");
    
    
    // --- ZONA CENTRAL (FOCA + NÚMERO) ---
    var centro_x = panel_x + panel_w/2;
    var centro_y = panel_y + 55; // Altura media del panel
    
    // 1. Dibujar Foca (A la IZQUIERDA del centro)
    // La movemos 30 pixeles a la izquierda para que no tape el número
    draw_sprite_ext(icono_a_usar, 0, centro_x - 35, centro_y, 1, 1, 0, c_white, 1);
    
    // 2. Dibujar Número (A la DERECHA del centro)
    draw_set_color(c_white);
    var str_num = string(cantidad_a_enviar) + "/" + string(focas_disponibles);
    
    // Alineamos a la izquierda para que el número empiece después de la foca
    draw_set_halign(fa_left); 
    draw_text_transformed(centro_x - 10, centro_y, str_num, 1.2, 1.2, 0);
    
    // 3. Texto "Listas" (Abajo y centrado)
    draw_set_halign(fa_center); // Volvemos a centrar
    draw_set_color(c_gray);
    draw_text_transformed(centro_x, centro_y + 22, "Listas", 0.7, 0.7, 0);
}

// Reset final
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
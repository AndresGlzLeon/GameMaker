/// @description HUD ELEGANTE CON ICONOS

// 1. OBTENER DATOS
var n_focas = instance_number(Foca1) + instance_number(Foca2); 
var n_peces = instance_number(Pez); 
var n_orcas = instance_number(orca);

// 2. CONFIGURACIÓN VISUAL
var x1 = 20; 
var y1 = 20;
var ancho = 180; // Más angosto porque usamos iconos
var alto = 110;
var tam_icono = 24; // Tamaño de los dibujitos (24x24 px)

// Configurar fuente
draw_set_font(fnt_Botones); 
draw_set_halign(fa_left);
draw_set_valign(fa_middle); // Alineación vertical centrada para que cuadre con el icono

// 3. CAJA DE FONDO (Estilo oscuro como el menú)
var color_fondo = make_color_rgb(10, 20, 40);
draw_set_color(color_fondo);
draw_set_alpha(0.8);
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, false);

// Borde
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, true);


// --- FILA 1: FOCAS ---
var fila1_y = y1 + 25;
// Dibujamos el Sprite de la Foca (Asegúrate que el nombre sea el de tu sprite, ej: Foca1_R)
// draw_sprite_stretched(sprite, subimg, x, y, w, h)
draw_sprite_stretched(Foca1_R, 0, x1 + 15, fila1_y - 12, tam_icono, tam_icono);

// El número
draw_set_color(c_aqua);
draw_text(x1 + 50, fila1_y, "x " + string(n_focas));


// --- FILA 2: PECES ---
var fila2_y = y1 + 55;
// Sprite del Pez
draw_sprite_stretched(PezSprite, 0, x1 + 15, fila2_y - 12, tam_icono, tam_icono);

// El número
draw_set_color(c_lime);
// Muestra: "Capturados (Vivos)"
draw_text(x1 + 50, fila2_y, string(global.pescado_capturado) + " (" + string(n_peces) + ")");


// --- FILA 3: ORCAS ---
var fila3_y = y1 + 85;
// Sprite de la Orca
draw_sprite_stretched(OrcaSprite, 0, x1 + 15, fila3_y - 12, tam_icono, tam_icono);

// El número
draw_set_color(c_red);
draw_text(x1 + 50, fila3_y, "x " + string(n_orcas));


// Resetear configuración
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
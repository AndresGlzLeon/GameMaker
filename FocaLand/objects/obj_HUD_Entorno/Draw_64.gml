/// @description HUD COMPLETO (VIVOS + MUERTOS + RECURSOS)

// 1. OBTENER DATOS
var n_focas_vivas = instance_number(Foca1) + instance_number(Foca2); 
var n_muertas = global.focas_muertas; // Dato nuevo
var n_peces_vivos = instance_number(Pez); 
var n_orcas = instance_number(orca); // Asegúrate que el objeto sea obj_Orca u orca según tu proyecto

// 2. CONFIGURACIÓN VISUAL
var x1 = 20; 
var y1 = 20;
var ancho = 210; // Un poco más ancho para que quepa el texto de peces
var alto = 145;  // Más alto para la 4ta fila
var tam_icono = 24; 

draw_set_font(fnt_Botones); 
draw_set_halign(fa_left);
draw_set_valign(fa_middle); 

// 3. CAJA DE FONDO
var color_fondo = make_color_rgb(10, 20, 40);
draw_set_color(color_fondo);
draw_set_alpha(0.8);
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, false);

// Borde
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, true);


// --- FILA 1: FOCAS VIVAS ---
var fila1_y = y1 + 25;
draw_sprite_stretched(Foca1_R, 0, x1 + 15, fila1_y - 12, tam_icono, tam_icono);
draw_set_color(c_aqua);
draw_text(x1 + 50, fila1_y, "Vivas: " + string(n_focas_vivas));


// --- FILA 2: FOCAS MUERTAS (NUEVO) ---
var fila2_y = y1 + 55;
// Truco: Usamos 'draw_sprite_stretched_ext' para teñir el sprite de GRIS (c_gray)
draw_sprite_stretched_ext(Foca1_R, 0, x1 + 15, fila2_y - 12, tam_icono, tam_icono, c_gray, 1);
draw_set_color(c_gray); 
draw_text(x1 + 50, fila2_y, "Muertas: " + string(n_muertas));


// --- FILA 3: PECES ---
var fila3_y = y1 + 85;
draw_sprite_stretched(PezSprite, 0, x1 + 15, fila3_y - 12, tam_icono, tam_icono);
draw_set_color(c_lime);
// Muestra: "Peces: Dinero (Vivos en mar)"
draw_text(x1 + 50, fila3_y, "Peces: " + string(global.pescado_capturado) + " (" + string(n_peces_vivos) + ")");


// --- FILA 4: ORCAS ---
var fila4_y = y1 + 115;
draw_sprite_stretched(OrcaSprite, 0, x1 + 15, fila4_y - 12, tam_icono, tam_icono);
draw_set_color(c_red);
draw_text(x1 + 50, fila4_y, "Amenazas: " + string(n_orcas));


// Resetear configuración
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
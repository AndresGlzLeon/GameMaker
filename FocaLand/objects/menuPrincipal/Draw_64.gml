/// @description MENÚ NIVEL PRO (Estilo RPG)

var ancho = display_get_gui_width();
var alto = display_get_gui_height();
var centro_x = ancho / 2;
var centro_y = alto / 2;

// --- 1. FONDO OSCURO (Opcional, para resaltar si el fondo es muy claro) ---
// draw_set_color(c_black);
// draw_set_alpha(0.3);
// draw_rectangle(0, 0, ancho, alto, false);
// draw_set_alpha(1);

// --- 2. EL TÍTULO DE HIELO (Gradient + Borde) ---
var flotar = sin(current_time / 400) * 4; // Flota más rápido

draw_set_font(fnt_Titulo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Borde grueso negro (Dibujamos el texto 4 veces desplazado)
draw_set_color(c_black);
var offset = 3;
draw_text(centro_x + offset, 100 + flotar, "FOCALAND");
draw_text(centro_x - offset, 100 + flotar, "FOCALAND");
draw_text(centro_x, 100 + flotar + offset, "FOCALAND");
draw_text(centro_x, 100 + flotar - offset, "FOCALAND");

// Texto con DEGRADADO (Efecto Hielo: Blanco arriba, Azul abajo)
// draw_text_color(x, y, string, c1, c2, c3, c4, alpha);
draw_text_color(centro_x, 100 + flotar, "FOCALAND", c_white, c_white, c_aqua, c_blue, 1);


// --- 3. CAJA DE MENÚ ESTILO RPG ---
var caja_ancho = 350; // Más ancha para que respire
var caja_alto = (array_length(opciones) * espacio_entre_lineas) + 60;
var caja_x1 = centro_x - (caja_ancho / 2);
var caja_y1 = margen_y - 20;
var caja_x2 = centro_x + (caja_ancho / 2);
var caja_y2 = margen_y + caja_alto - 30;

// Fondo de la caja (Azul Noche muy oscuro, casi negro)
var color_fondo = make_color_rgb(10, 20, 40); 
draw_set_color(color_fondo);
draw_set_alpha(0.85); // Un poco transparente
draw_roundrect(caja_x1, caja_y1, caja_x2, caja_y2, false);

// Borde de la caja (Blanco o Celeste)
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(caja_x1, caja_y1, caja_x2, caja_y2, true); // true = solo contorno


// --- 4. BOTONES CON "PULSO" ---
draw_set_font(fnt_Botones);

for (var i = 0; i < array_length(opciones); i++) {
    
    var color_top = c_ltgray;
    var color_bot = c_gray;
    var escala = 1;
    var txt = opciones[i];
    
    // Si el mouse está encima
    if (seleccion == i) {
        // Efecto PULSO (Latido)
        var pulso = 1 + (sin(current_time / 150) * 0.05); 
        escala = pulso; 
        
        color_top = c_yellow; // Se pone amarillo dorado
        color_bot = c_orange;
        txt = "- " + txt + " -"; // Decoración extra
    }
    
    var pos_y = margen_y + (espacio_entre_lineas * i) + 10; // +10 para bajarlo un poco
    
    // Sombra del texto
    draw_set_color(c_black);
    draw_text_transformed(centro_x + 2, pos_y + 2, txt, escala, escala, 0);
    
    // Texto con degradado simple (hace que se vea metálico o con volumen)
    draw_text_transformed_color(centro_x, pos_y, txt, escala, escala, 0, color_top, color_top, color_bot, color_bot, 1);
}

// Resetear
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
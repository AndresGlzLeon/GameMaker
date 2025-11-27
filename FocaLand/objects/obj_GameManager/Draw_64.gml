/// @description DIBUJAR INTERFAZ

// 1. Marcador de Pescado (Arriba)
draw_set_color(c_white);
draw_text(32, 32, "Pescado: " + string(global.pescado_capturado));
draw_text(32, 52, "Enviando: " + string(cantidad_seleccionada) + " focas");

// --- FUNCIÓN AUXILIAR PARA DIBUJAR BOTONES ---
// (Esto evita repetir código 3 veces)

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

// --- BOTÓN 1 ---
var color1 = c_dkgray;
if (cantidad_seleccionada == 1) color1 = c_green; // Verde si está seleccionado
else if (point_in_rectangle(mouse_gui_x, mouse_gui_y, btn1_x, btn1_y, btn1_x+btn1_w, btn1_y+btn1_h)) color1 = c_gray; // Gris claro al pasar mouse

draw_set_color(color1);
draw_rectangle(btn1_x, btn1_y, btn1_x+btn1_w, btn1_y+btn1_h, false);
draw_set_color(c_white);
draw_text(btn1_x + 20, btn1_y + 10, "Enviar 1 Foca");

// --- BOTÓN 5 ---
var color5 = c_dkgray;
if (cantidad_seleccionada == 5) color5 = c_green; 
else if (point_in_rectangle(mouse_gui_x, mouse_gui_y, btn5_x, btn5_y, btn5_x+btn5_w, btn5_y+btn5_h)) color5 = c_gray;

draw_set_color(color5);
draw_rectangle(btn5_x, btn5_y, btn5_x+btn5_w, btn5_y+btn5_h, false);
draw_set_color(c_white);
draw_text(btn5_x + 20, btn5_y + 10, "Enviar 5 Focas");

// --- BOTÓN 10 ---
var color10 = c_dkgray;
if (cantidad_seleccionada == 10) color10 = c_green; 
else if (point_in_rectangle(mouse_gui_x, mouse_gui_y, btn10_x, btn10_y, btn10_x+btn10_w, btn10_y+btn10_h)) color10 = c_gray;

draw_set_color(color10);
draw_rectangle(btn10_x, btn10_y, btn10_x+btn10_w, btn10_y+btn10_h, false);
draw_set_color(c_white);
draw_text(btn10_x + 20, btn10_y + 10, "Enviar 10 Focas");
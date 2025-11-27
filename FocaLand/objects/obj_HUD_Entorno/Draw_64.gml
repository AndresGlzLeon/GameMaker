/// @description HUD DEL ECOSISTEMA

// 1. OBTENER DATOS DEL CENSO (Contamos los animales vivos)
// Asegúrate de escribir los nombres EXACTOS de tus objetos aquí:
var total_focas = instance_number(Foca1) + instance_number(Foca2); 
var total_peces = instance_number(Pez); 
var total_orcas = instance_number(orca); // Vi en tu foto que se llama "orca" (minúscula)

// 2. CONFIGURACIÓN DE DISEÑO
var x1 = 20;  // Posición izquierda
var y1 = 20;  // Posición arriba
var ancho = 200;
var alto = 110; // Altura del panel

// Configurar fuente
draw_set_font(fnt_Botones); // Usa tu fuente bonita
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// 3. DIBUJAR FONDO DEL PANEL
draw_set_color(c_black);
draw_set_alpha(0.6); // 60% transparente
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, false);

// Borde elegante
draw_set_alpha(1);
draw_set_color(c_white);
draw_roundrect(x1, y1, x1 + ancho, y1 + alto, true);

// 4. DIBUJAR LOS DATOS (Con colores para diferenciar)

// --- SECCIÓN FOCAS ---
draw_set_color(c_white); 
draw_text(x1 + 10, y1 + 10, "Población Focas:"); 
draw_set_color(c_aqua); // Color para el número
draw_text(x1 + 160, y1 + 10, string(total_focas));

// --- SECCIÓN PECES ---
draw_set_color(c_white);
draw_text(x1 + 10, y1 + 40, "Banco de Peces:");
draw_set_color(c_lime); // Verde para comida
draw_text(x1 + 160, y1 + 40, string(total_peces));

// --- SECCIÓN ORCAS ---
draw_set_color(c_white);
draw_text(x1 + 10, y1 + 70, "Amenaza (Orcas):");
draw_set_color(c_red); // Rojo para peligro
draw_text(x1 + 160, y1 + 70, string(total_orcas));

// 5. RESTAURAR COLOR (Buena práctica)
draw_set_color(c_white);
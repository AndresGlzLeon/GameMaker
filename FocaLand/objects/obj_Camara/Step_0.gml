/// @description Zoom y Movimiento

// =========================================================
//                     1. LÓGICA DE ZOOM
// =========================================================

// Detectar rueda del ratón
if (mouse_wheel_down()) zoom_destino += 0.1;
if (mouse_wheel_up())   zoom_destino -= 0.1;

// Limitar el zoom (Mínimo 0.5x, Máximo 2.0x)
// Ajusta estos números si quieres acercarte más o menos
zoom_destino = clamp(zoom_destino, 0.5, 2.0);

// Suavizado (Lerp): Hace que el zoom no sea "a saltos"
zoom_nivel = lerp(zoom_nivel, zoom_destino, 0.1);

// Calcular nuevo tamaño de la vista
var new_w = base_w * zoom_nivel;
var new_h = base_h * zoom_nivel;

// OBTENER EL CENTRO ACTUAL (Para hacer zoom al centro y no a la esquina)
var view_w_antiguo = camera_get_view_width(cam);
var view_h_antiguo = camera_get_view_height(cam);
var cur_x = camera_get_view_x(cam);
var cur_y = camera_get_view_y(cam);

var centro_x = cur_x + (view_w_antiguo / 2);
var centro_y = cur_y + (view_h_antiguo / 2);

// Aplicar el nuevo tamaño
camera_set_view_size(cam, new_w, new_h);

// Recalcular la posición para que el centro siga siendo el centro
var nueva_pos_x = centro_x - (new_w / 2);
var nueva_pos_y = centro_y - (new_h / 2);

// =========================================================
//                  2. MOVIMIENTO (WASD)
// =========================================================
var vel_move = 15 * zoom_nivel; // Más rápido si estás lejos

if (keyboard_check(ord("W"))) nueva_pos_y -= vel_move;
if (keyboard_check(ord("S"))) nueva_pos_y += vel_move;
if (keyboard_check(ord("A"))) nueva_pos_x -= vel_move;
if (keyboard_check(ord("D"))) nueva_pos_x += vel_move;

// =========================================================
//              3. MOVIMIENTO (MOUSE DRAG)
// =========================================================
// Estilo RTS: Clic derecho y arrastrar para mover el mundo

if (mouse_check_button_pressed(mb_right)) {
    dragging = true;
    drag_x = window_mouse_get_x(); // Guardamos donde hicimos clic en la pantalla
    drag_y = window_mouse_get_y();
}

if (mouse_check_button(mb_right) && dragging) {
    // Calcular cuánto se movió el mouse
    var _mx = window_mouse_get_x();
    var _my = window_mouse_get_y();
    
    // Mover la cámara en dirección contraria al mouse (efecto arrastre)
    // Multiplicamos por zoom_nivel para que la velocidad se sienta natural
    nueva_pos_x -= (_mx - drag_x) * zoom_nivel;
    nueva_pos_y -= (_my - drag_y) * zoom_nivel;
    
    // Actualizar referencia para el siguiente frame
    drag_x = _mx;
    drag_y = _my;
} else {
    dragging = false;
}

// =========================================================
//               4. LIMITES (CLAMP) Y APLICAR
// =========================================================

// Evitar salirnos del mapa (Mantenemos la cámara dentro de la Room)
nueva_pos_x = clamp(nueva_pos_x, 0, room_width - new_w);
nueva_pos_y = clamp(nueva_pos_y, 0, room_height - new_h);

// APLICAR POSICIÓN FINAL
camera_set_view_pos(cam, nueva_pos_x, nueva_pos_y);
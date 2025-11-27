// --- ZOOM (Rueda del Mouse) ---
if (mouse_wheel_down()) target_zoom += 0.1;
if (mouse_wheel_up()) target_zoom -= 0.1;

// Limites del zoom (entre 0.5x y 2.0x)
target_zoom = clamp(target_zoom, 0.5, 2.0);

// Suavizado del zoom (Interpolación)
zoom_nivel = lerp(zoom_nivel, target_zoom, 0.1);

// Aplicar tamaño a la cámara
var new_w = 1900 * zoom_nivel;
var new_h = 1200 * zoom_nivel;
camera_set_view_size(view_camera[0], new_w, new_h);

// --- MOVIMIENTO (Arrastrar con clic derecho o WASD) ---
// (Aquí puedes agregar la lógica de WASD si prefieres)
if (mouse_check_button(mb_right)) {
    var _x = camera_get_view_x(view_camera[0]);
    var _y = camera_get_view_y(view_camera[0]);
    
    // Moverse al contrario del mouse
    _x -= (window_mouse_get_x() - window_get_width()/2) * 0.05;
    _y -= (window_mouse_get_y() - window_get_height()/2) * 0.05;
    
    camera_set_view_pos(view_camera[0], _x, _y);
}
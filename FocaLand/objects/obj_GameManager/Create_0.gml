/// @description Configuración UI (Corregida)

// Inicializar variables globales si no existen
if (!variable_global_exists("pescado_capturado")) {
    global.pescado_capturado = 0;
}

if (!variable_global_exists("costo_expansion")) {
    global.costo_expansion = 100; 
}

if (!variable_global_exists("modo_carga")) {
    global.modo_carga = false;
}

// --- VARIABLES DE JUEGO ---
// SI ESTAMOS CARGANDO, NO REINICIALIZAR (el valor ya viene de cargar_partida_json)
// SI NO ESTAMOS CARGANDO, INICIALIZAR EN 0
if (!global.modo_carga) {
    global.pescado_capturado = 0;
}

show_debug_message("🎮 GameManager Init | Modo Carga: " + string(global.modo_carga) + " | Dinero: " + string(global.pescado_capturado));

focas_disponibles = 0;
focas_fuera = 0;

// --- 1. MENÚ ESCUADRÓN (ABAJO - Esto estaba bien) ---
menu_abierto = false;
cantidad_a_enviar = 1;

main_w = 200; main_h = 50;
main_x = (display_get_gui_width()/2) - (main_w/2);
main_y = display_get_gui_height() - 60; 

panel_w = 300; panel_h = 80;
panel_x = (display_get_gui_width()/2) - (panel_w/2);
panel_y = main_y - panel_h - 10;

btn_size = 40;
btn_minus_x = panel_x + 20; btn_minus_y = panel_y + 20;
btn_plus_x = panel_x + panel_w - 60; btn_plus_y = panel_y + 20;

// --- 2. BOTÓN EXPANSIÓN (MOVIDO A LA IZQUIERDA) ---
costo_expansion = 10; 
btn_exp_w = 220;
btn_exp_h = 40;

// CAMBIO AQUÍ: Lo movemos 480 pixeles a la izquierda para dejar espacio al Menú
btn_exp_x = display_get_gui_width() - 480; 
btn_exp_y = 20; 

draw_set_font(fnt_Botones);

// ... (Tus variables de UI y botones anteriores) ...

// --- SISTEMA DE VIDA ---
costo_reproduccion = 20;  // Cuesta 20 peces tener un bebé
alarm[0] = 300;           // El "Ciclo de la Vida" se revisa cada 5 segundos
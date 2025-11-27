/// @description Configuración del Menú

// Opciones del menú
opciones = ["Jugar", "Guardar Partida", "Cargar Partida", "Idioma: ESP", "Salir"];
seleccion = -1; // Cuál opción tiene el mouse encima

// Variables de diseño
margen_x = display_get_gui_width() / 2; // Centro de la pantalla
margen_y = display_get_gui_height() / 2 - 50; // Un poco arriba del centro
espacio_entre_lineas = 40; // Espacio entre botones

// Inicializar idioma si no existe
if (!variable_global_exists("idioma")) {
    global.idioma = "ESP"; 
}
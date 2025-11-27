/// @description Configuración del Menú

// Inicializar modo de carga (por si acaso viene del juego)
if (!variable_global_exists("modo_carga")) {
    global.modo_carga = false;
}

// Variables de diseño
margen_x = display_get_gui_width() / 2;
margen_y = display_get_gui_height() / 2 - 50; 
espacio_entre_lineas = 40; 
seleccion = -1; 

// --- GENERAR LA LISTA DE OPCIONES ---
// Dinámico: Si existe savegame, mostrar "Cargar Partida"
var existe_save = file_exists("savegame.ini");

if (existe_save) {
    opciones = ["Jugar", "Cargar Partida", "Salir"];
} else {
    opciones = ["Jugar", "Salir"];
}

show_debug_message("📋 Menú Principal Cargado | Archivo guardado existe: " + string(existe_save));
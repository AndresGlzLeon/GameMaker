/// @description Configuración del Menú
// Variables de diseño
margen_x = display_get_gui_width() / 2;
margen_y = display_get_gui_height() / 2 - 50; 
espacio_entre_lineas = 40; 
seleccion = -1; 

// Inicializar idioma si no existe
if (!variable_global_exists("idioma")) {
    global.idioma = "ESP"; 
}

// --- GENERAR LA LISTA DE OPCIONES ---
// Hacemos esto dinámico: Si existe savegame, ponemos Cargar. Si no, no.
// Y quitamos "Guardar" porque no tiene sentido en el menú principal.

var existe_save = file_exists("savegame.ini");

if (global.idioma == "ESP") {
    if (existe_save) {
        opciones = ["Jugar", "Cargar Partida", "Idioma: ESP", "Salir"];
    } else {
        opciones = ["Jugar", "Idioma: ESP", "Salir"];
    }
} else {
    // Versión en Inglés
    if (existe_save) {
        opciones = ["Play", "Load Game", "Language: ENG", "Exit"];
    } else {
        opciones = ["Play", "Language: ENG", "Exit"];
    }
}
/// @description Configuración del Menú
// Variables de diseño
margen_x = display_get_gui_width() / 2;
margen_y = display_get_gui_height() / 2 - 50; 
espacio_entre_lineas = 40; 
seleccion = -1; 

// --- GENERAR LA LISTA DE OPCIONES ---
// Hacemos esto dinámico: Si existe savegame, ponemos Cargar. Si no, no.
// Y quitamos "Guardar" porque no tiene sentido en el menú principal.

var existe_save = file_exists("savegame.ini");


    if (existe_save) {
        opciones = ["Jugar", "Cargar Partida", "Salir"];
    } else {
        opciones = ["Jugar", "Salir"];
    }
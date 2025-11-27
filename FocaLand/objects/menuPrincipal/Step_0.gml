/// @description Detectar Clicks

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

seleccion = -1; // Resetear selección

// Revisar si el mouse está sobre alguna opción
for (var i = 0; i < array_length(opciones); i++) {
    
    // Coordenadas del texto (debe coincidir con el Draw)
    var texto_y = margen_y + (espacio_entre_lineas * i);
    
    // Si el mouse está cerca verticalmente (zona de click simple)
    if (abs(mouse_gui_y - texto_y) < 15) { 
        seleccion = i;
        
        // --- SI HACE CLICK ---
        if (mouse_check_button_pressed(mb_left)) {
            
            switch(i) {
                case 0: // JUGAR
                    room_goto(R_Play); // OJO: Pon el nombre real de tu sala de juego
                    break;
                    
                case 1: // GUARDAR
                    game_save("savegame.dat"); // Guardado básico de GameMaker
                    show_message("¡Partida Guardada!");
                    break;
                    
                case 2: // CARGAR
                    if (file_exists("savegame.dat")) {
                        game_load("savegame.dat");
                    } else {
                        show_message("No hay partida guardada.");
                    }
                    break;
                    
                case 3: // IDIOMA (Cambiar texto)
                    if (global.idioma == "ESP") {
                        global.idioma = "ENG";
                        opciones = ["Play", "Save Game", "Load Game", "Language: ENG", "Exit"];
                    } else {
                        global.idioma = "ESP";
                        opciones = ["Jugar", "Guardar Partida", "Cargar Partida", "Idioma: ESP", "Salir"];
                    }
                    break;
                    
                case 4: // SALIR
                    game_end();
                    break;
            }
        }
    }
}
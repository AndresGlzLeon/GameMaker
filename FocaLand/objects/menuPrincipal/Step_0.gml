/// @description Detectar Clicks (Por nombre de botón)

var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

seleccion = -1; 

for (var i = 0; i < array_length(opciones); i++) {
    
    var texto_y = margen_y + (espacio_entre_lineas * i);
    
    // Si el mouse está encima
    if (abs(mouse_gui_y - texto_y) < 15) { 
        seleccion = i;
        
        if (mouse_check_button_pressed(mb_left)) {
            
            // OBTENEMOS EL TEXTO DEL BOTÓN PARA SABER QUÉ HACER
            var accion = opciones[i];
            
            // --- 1. JUGAR ---
            if (accion == "Jugar" || accion == "Play") {
                room_goto(R_Play); // Tu sala de juego
            }
            
            // --- 2. CARGAR PARTIDA ---
            else if (accion == "Cargar Partida" || accion == "Load Game") {
			   cargar_partida_json(); // <--- USA LA NUEVA FUNCIÓN
			}
            
            // --- 3. CAMBIAR IDIOMA (Lógica Completa) ---
            else if (string_count("Idioma", accion) > 0 || string_count("Language", accion) > 0) {
                // Cambiamos el idioma global
                if (global.idioma == "ESP") global.idioma = "ENG";
                else global.idioma = "ESP";
                
                // REGENERAMOS LA LISTA (Para mantener la lógica de Cargar/No Cargar)
                var existe_save = file_exists("savegame.dat");
                
                if (global.idioma == "ESP") {
                    if (existe_save) opciones = ["Jugar", "Cargar Partida", "Idioma: ESP", "Salir"];
                    else opciones = ["Jugar", "Idioma: ESP", "Salir"];
                } else {
                    if (existe_save) opciones = ["Play", "Load Game", "Language: ENG", "Exit"];
                    else opciones = ["Play", "Language: ENG", "Exit"];
                }
            }
            
            // --- 4. SALIR ---
            else if (accion == "Salir" || accion == "Exit") {
                game_end();
            }
            
            // Nota: Ya no ponemos "Guardar" aquí, porque eso solo está en el menú de pausa.
        }
    }
}
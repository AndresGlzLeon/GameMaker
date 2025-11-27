// Función de GUARDADO (Modo INI - A prueba de fallos)
function guardar_partida_json() {
    // 1. Abrir archivo (si no existe, lo crea solo)
    ini_open("savegame.ini");

    // 2. Escribir datos
    // Si no tienes variable idioma, guarda "ESP" por defecto
    var idioma_a_guardar = variable_global_exists("idioma") ? global.idioma : "ESP";
    
    ini_write_string("Datos", "Idioma", idioma_a_guardar);
    ini_write_real("Datos", "Focas", instance_number(Foca1) + instance_number(Foca2)); 
    // ^^^ OJO: Asegúrate que tus objetos se llaman Foca1 y Foca2
    
    ini_write_real("Datos", "Peces", instance_number(Pez)); 
    // ^^^ OJO: Asegúrate que tu objeto se llama Pez
    
    // 3. Cerrar archivo (OBLIGATORIO)
    ini_close();

    show_message("¡PARTIDA GUARDADA (INI)!");
}

// Función de CARGA
function cargar_partida_json() {
    if (file_exists("savegame.ini")) {
        
        ini_open("savegame.ini");
        
        // Leemos los datos (o ponemos valores por defecto si fallan)
        global.idioma = ini_read_string("Datos", "Idioma", "ESP");
        var num_focas = ini_read_real("Datos", "Focas", 0);
        var num_peces = ini_read_real("Datos", "Peces", 0);
        
        ini_close();
        
        // Ir al juego
        room_goto(R_Play);
        
    } else {
        show_message("No se encontró savegame.ini");
    }
}
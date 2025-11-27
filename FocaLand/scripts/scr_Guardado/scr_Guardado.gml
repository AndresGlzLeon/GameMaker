// Función de GUARDADO (Modo INI - A prueba de fallos)
function guardar_partida_json() {
    
    // 1. ¡TRUCO DE MAGIA! DESPERTAR A TODOS
    // Reactivamos todo para que GameMaker pueda contar las instancias
    instance_activate_all(); 

    // 2. ABRIR ARCHIVO
    ini_open("savegame.ini");

    // 3. GUARDAR DATOS
    var idioma_a_guardar = variable_global_exists("idioma") ? global.idioma : "ESP";
    ini_write_string("Datos", "Idioma", idioma_a_guardar);
    
    // AHORA SÍ funcionará el conteo porque están "despiertas"
    var total_focas = instance_number(Foca1) + instance_number(Foca2);
    ini_write_real("Datos", "Focas", total_focas); 
    
    var total_peces = instance_number(Pez); 
    ini_write_real("Datos", "Peces", total_peces); 
    
    ini_close();

    // 4. (Opcional) VOLVER A DORMIRLOS
    // Como estamos en el botón de pausa, es bueno desactivarlos otra vez
    // para que no se vea un "parpadeo", aunque el obj_Pausa lo haría en el siguiente frame.
    // Desactivamos todo MENOS el objeto que está ejecutando esto (la Pausa)
    instance_deactivate_all(true);
    
    // Aseguramos que el sistema de pausa y el menú sigan activos
    instance_activate_object(obj_Sistema_Pausa);

    show_message("¡PARTIDA GUARDADA CORRECTAMENTE!\nFocas guardadas: " + string(total_focas));
}

// Función de CARGA
function cargar_partida_json() {
    if (file_exists("savegame.ini")) {
        
        ini_open("savegame.ini");
        
        // 1. LEER DATOS Y GUARDARLOS EN GLOBALES TEMPORALES
        global.idioma = ini_read_string("Datos", "Idioma", "ESP");
        
        // ¡Aquí está la magia! Guardamos cuántas focas había en una variable global
        global.focas_guardadas = ini_read_real("Datos", "Focas", 20); 
        global.peces_guardados = ini_read_real("Datos", "Peces", 15);
        
        global.modo_carga = true; // <--- ACTIVAMOS EL MODO CARGA
        
        ini_close();
        
        // 2. IR AL JUEGO
        room_goto(R_Play);
        
    } else {
        show_message("No existe partida guardada.");
    }
}
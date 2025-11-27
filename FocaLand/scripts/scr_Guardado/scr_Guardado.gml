// FUNCIÓN PARA GUARDAR (Desde el Menú de Pausa)
function guardar_partida_json() {
    
    // 1. IMPORTANTE: Despertar a todos los objetos para poder contarlos
    // (Si están desactivados por la pausa, instance_number devolvería 0)
    instance_activate_all(); 

    // 2. Abrir archivo INI
    ini_open("savegame.ini");

    // 3. Guardar Datos Generales
    var idioma_actual = variable_global_exists("idioma") ? global.idioma : "ESP";
    ini_write_string("Datos", "Idioma", idioma_actual);
    
    // 4. CENSAR LA POBLACIÓN (Guardar cantidades exactas)
    // Asegúrate de que tus objetos se llaman Foca1, Foca2, Pez y orca
    var total_focas = instance_number(Foca1) + instance_number(Foca2);
    ini_write_real("Datos", "Focas", total_focas); 
    
    var total_peces = instance_number(Pez); 
    ini_write_real("Datos", "Peces", total_peces);
    
    var total_orcas = instance_number(orca); 
    ini_write_real("Datos", "Orcas", total_orcas);
    
    // 5. Cerrar archivo
    ini_close();

    // 6. Volver a congelar el juego (Porque seguimos en el menú de pausa)
    instance_deactivate_all(true);
    // Reactivar solo el sistema de pausa para que no desaparezca el menú
    instance_activate_object(obj_Sistema_Pausa);

    show_message("¡PARTIDA GUARDADA!\nFocas: " + string(total_focas) + "\nPeces: " + string(total_peces));
}

// FUNCIÓN PARA CARGAR (Desde el Menú Principal)
function cargar_partida_json() {
    if (file_exists("savegame.ini")) {
        
        ini_open("savegame.ini");
        
        // 1. Leer Configuración
        global.idioma = ini_read_string("Datos", "Idioma", "ESP");
        
        // 2. Leer Poblaciones y guardarlas en variables globales
        // Estas variables las leerán los controladores al iniciar la sala
        global.focas_guardadas = ini_read_real("Datos", "Focas", 20); 
        global.peces_guardados = ini_read_real("Datos", "Peces", 15);
        global.orcas_guardadas = ini_read_real("Datos", "Orcas", 1);
        
        // 3. ACTIVAR MODO CARGA (La bandera clave)
        global.modo_carga = true; 
        
        ini_close();
        
        // 4. Ir al juego
        room_goto(R_Play);
        
    } else {
        show_message("No se encontró archivo de guardado.");
    }
}
// FUNCIÓN PARA GUARDAR (Desde el Menú de Pausa)
function guardar_partida_json() {
    try {
        // 1. DESPERTAR A TODOS (Para poder contarlos)
        instance_activate_all(); 

        // 2. Abrir archivo INI
        ini_open("savegame.ini");

        // --- SECCIÓN A: DATOS GENERALES ---
        var idioma_actual = variable_global_exists("idioma") ? global.idioma : "ESP";
        ini_write_string("Datos", "Idioma", idioma_actual);
        
        // --- SECCIÓN B: ECONOMÍA ---
        ini_write_real("Economia", "Dinero", global.pescado_capturado);
        
        var costo_actual = variable_global_exists("costo_expansion") ? global.costo_expansion : 100;
        ini_write_real("Economia", "CostoExpansion", costo_actual);

        // --- SECCIÓN C: POBLACIÓN ---
        // Contar focas vivas y muertas
        var total_focas_vivas = instance_number(Foca1) + instance_number(Foca2);
        var total_focas_muertas = variable_global_exists("focas_muertas") ? global.focas_muertas : 0;
        ini_write_real("Poblacion", "Focas", total_focas_vivas);
        ini_write_real("Poblacion", "FocasMuertas", total_focas_muertas);
        
        var total_peces = instance_number(Pez); 
        ini_write_real("Poblacion", "Peces", total_peces);
        
        var total_orcas = instance_number(orca); 
        ini_write_real("Poblacion", "Orcas", total_orcas);
        
        // --- SECCIÓN D: TERRENO ---
        var nivel_isla_actual = 1;
        if (instance_exists(obj_Mapa)) {
            nivel_isla_actual = obj_Mapa.nivel_isla;
        }
        ini_write_real("Terreno", "NivelIsla", nivel_isla_actual);
        
        // 3. Cerrar archivo
        ini_close();

        show_debug_message("✓ GUARDADO EXITOSO - Dinero: " + string(global.pescado_capturado) + ", Focas Vivas: " + string(total_focas_vivas) + ", Focas Muertas: " + string(total_focas_muertas) + ", Orcas: " + string(total_orcas) + ", Nivel Isla: " + string(nivel_isla_actual));
        
        // Mostrar mensaje al usuario (sin pausar más)
        show_message("¡PARTIDA GUARDADA!\n\nFocas Vivas: " + string(total_focas_vivas) + "\nFocas Muertas: " + string(total_focas_muertas) + "\nPeces: " + string(total_peces) + "\nOrcas: " + string(total_orcas) + "\nDinero: " + string(global.pescado_capturado) + "\nNivel Isla: " + string(nivel_isla_actual));
        
        // 4. Volver a congelar solo lo necesario (sin tocar HUD)
        instance_deactivate_all(true);
        instance_activate_object(obj_Sistema_Pausa);
        if (instance_exists(obj_HUD_Entorno)) instance_activate_object(obj_HUD_Entorno);
        
    } catch (error) {
        show_message("❌ ERROR AL GUARDAR:\n" + string(error));
        show_debug_message("ERROR EN GUARDADO: " + string(error));
    }
}

// FUNCIÓN PARA CARGAR (Desde el Menú Principal)
function cargar_partida_json() {
    if (file_exists("savegame.ini")) {
        
        try {
            ini_open("savegame.ini");
            
            // 1. CARGAR CONFIGURACIÓN
            global.idioma = ini_read_string("Datos", "Idioma", "ESP");
            
            // 2. CARGAR ECONOMÍA
            global.pescado_capturado = ini_read_real("Economia", "Dinero", 0);
            global.costo_expansion = ini_read_real("Economia", "CostoExpansion", 100);
            
            // 3. CARGAR POBLACIÓN (Para los generadores)
            global.focas_guardadas = ini_read_real("Poblacion", "Focas", 20);
            global.focas_muertas = ini_read_real("Poblacion", "FocasMuertas", 0);
            global.peces_guardados = ini_read_real("Poblacion", "Peces", 15);
            global.orcas_guardadas = ini_read_real("Poblacion", "Orcas", 1);
            
            // 4. CARGAR TERRENO
            global.nivel_isla_guardado = ini_read_real("Terreno", "NivelIsla", 1);
            
            // 5. ACTIVAR MODO CARGA
            global.modo_carga = true; 
            
            ini_close();
            
            show_debug_message("✓ CARGA EXITOSA - Dinero: " + string(global.pescado_capturado) + ", Focas: " + string(global.focas_guardadas) + ", Focas Muertas: " + string(global.focas_muertas) + ", Orcas: " + string(global.orcas_guardadas) + ", Nivel Isla: " + string(global.nivel_isla_guardado));
            
            // 6. Ir al juego
            room_goto(R_Play);
            
        } catch (error) {
            show_message("❌ ERROR AL CARGAR:\n" + error.message);
            show_debug_message("ERROR EN CARGA: " + error.message);
        }
        
    } else {
        show_message("❌ No se encontró archivo de guardado.");
        show_debug_message("Archivo savegame.ini no existe.");
    }
}
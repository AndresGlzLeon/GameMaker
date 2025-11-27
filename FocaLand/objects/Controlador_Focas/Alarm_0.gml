/// @description GENERAR MANADA (INTELIGENTE)

// 1. DECIDIR CUÁNTAS FOCAS CREAR
var cantidad_focas = 20; // Valor por defecto (Nueva Partida)

// Si estamos en "Modo Carga", usamos el valor del archivo
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    cantidad_focas = global.focas_guardadas;
    
    // (Opcional) Debug para que veas que funciona
    show_debug_message("MODO CARGA: Creando solo " + string(cantidad_focas) + " focas.");
}

// ---------------------------------------------------------
// EL RESTO DE TU CÓDIGO SIGUE IGUAL (Solo cambié la variable de arriba)
// ---------------------------------------------------------

var creadas = 0;
var intentos = 0;

// Verificamos que el mapa exista
if (!variable_global_exists("tilemap_nieve")) {
    alarm[0] = 5; 
    exit;
}

// BUCLE DE CREACIÓN
while (creadas < cantidad_focas && intentos < 1000) {
    intentos++;
    
    var pos_x = irandom_range(64, room_width - 64);
    var pos_y = irandom_range(64, room_height - 64);

    if (tilemap_get_at_pixel(global.tilemap_nieve, pos_x, pos_y) > 0) {
        
        var tipo_foca = choose(Foca1, Foca2);
        instance_create_layer(pos_x, pos_y, "Instances", tipo_foca);
        
        creadas++;
    }
}

// IMPORTANTE: Apagar el modo carga para que no se quede pegado para siempre
if (variable_global_exists("modo_carga")) {
    global.modo_carga = false; 
}
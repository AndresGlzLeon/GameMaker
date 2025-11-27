/// @description REPRODUCCIÓN Y GAME OVER

// 1. Reiniciar el reloj (Ciclo infinito)
alarm[0] = 300; 

// =========================================================
//        CONDICIÓN DE DERROTA (EXTINCIÓN)
// =========================================================
var total_poblacion = instance_number(Foca1) + instance_number(Foca2);

if (total_poblacion == 0) {
    show_message("☠️ GAME OVER ☠️\n\nTu colonia se ha extinguido.");
    game_restart();
    exit;
}

// =========================================================
//        REPRODUCCIÓN AUTOMÁTICA
// =========================================================

// 2. Censo de Padres Disponibles
var padres_listos = 0;

with (Foca1) { if (estado == "PASEAR" && cooldown_susto <= 0) padres_listos++; }
with (Foca2) { if (estado == "PASEAR" && cooldown_susto <= 0) padres_listos++; }

// 3. ¿Ocurre el milagro?
if (global.pescado_capturado >= costo_reproduccion && padres_listos >= 2) {
    
    // Pagar el costo
    global.pescado_capturado -= costo_reproduccion;
    
    // Nace el bebé en el centro
    var centro_x = room_width / 2;
    var centro_y = room_height / 2;
    
    var nacer_x = centro_x + irandom_range(-40, 40);
    var nacer_y = centro_y + irandom_range(-40, 40);
    
    var tipo_bebe = choose(Foca1, Foca2);
    
    instance_create_layer(nacer_x, nacer_y, "Instances", tipo_bebe);
    
    // --- CORRECCIÓN AQUÍ ---
    // Usamos 'ef_ring' (Anillo) en lugar de 'ef_heart'
    effect_create_above(ef_ring, nacer_x, nacer_y, 1, c_red); 
    
    show_debug_message("❤️ ¡Ha nacido una nueva foca! (Población: " + string(total_poblacion + 1) + ")");
}
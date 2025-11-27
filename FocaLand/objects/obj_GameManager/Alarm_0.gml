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

/// @description SOLO CHECK DE GAME OVER

alarm[0] = 60; // Checar cada segundo

var total_poblacion = instance_number(Foca1) + instance_number(Foca2);

if (total_poblacion == 0) {
    show_message("☠️ GAME OVER ☠️\n\nTu colonia se ha extinguido.");
    game_restart();
    exit;
}
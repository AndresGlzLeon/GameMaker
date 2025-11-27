/// @description VERTIDO TÓXICO (Muy Raro)

// Seguridad básica
if (!variable_global_exists("tilemap_agua")) { alarm[0] = 60; exit; }

// --- 1. FACTOR SUERTE (La clave para que sea raro) ---
// Lanzamos un dado de 0 a 4 (5 caras).
// Solo si sale 0 (20% de probabilidad) generamos la mancha.
// Si sale 1, 2, 3 o 4, no pasa nada y solo reiniciamos el reloj.
var suerte = irandom(4);

if (suerte == 0) {
    
    // ¡MALA SUERTE! TOCA CONTAMINACIÓN
    var cantidad = irandom_range(2, 4); // Entre 2 y 4 manchas
    var creadas = 0;
    var intentos = 0;

    while (creadas < cantidad && intentos < 1000) {
        intentos++;
        
        var px = irandom(room_width);
        var py = irandom(room_height);
        
        // Filtros de terreno
        var es_agua = tilemap_get_at_pixel(global.tilemap_agua, px, py) > 0;
        var es_nieve = tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0;
        var libre = !position_meeting(px, py, Pollution); 
        
        if (es_agua && !es_nieve && libre) {
            var nueva = instance_create_layer(px, py, "Instances", Pollution);
            nueva.image_angle = irandom(360);
            creadas++;
        }
    }
    
    if (creadas > 0) {
        show_debug_message("☢️ ¡DESASTRE! Se ha generado un vertido tóxico.");
    }

} else {
    // Si no tocó (80% de las veces)
    show_debug_message("🍀 El mar sigue limpio por ahora...");
}

// --- 2. REINICIAR TEMPORIZADOR LARGO ---
// Usamos game_get_speed para calcular segundos reales sin importar tus FPS
var un_minuto = game_get_speed(gamespeed_fps) * 60;

// Revisar de nuevo entre 1 y 3 MINUTOS
alarm[0] = irandom_range(un_minuto * 1, un_minuto * 3);
/// @description VERTIDO PROGRESIVO

if (!variable_global_exists("tilemap_agua")) { alarm[0] = 60; exit; }

// =========================================================
//        CÁLCULO DE PROBABILIDAD DINÁMICA
// =========================================================

// 1. Obtenemos el nivel de la isla (Progreso)
// Si no existe el mapa aún, asumimos nivel 1
var nivel_actual = 1;
if (instance_exists(obj_Mapa)) nivel_actual = obj_Mapa.nivel_isla;

// 2. Fórmula de Probabilidad
// Base: 5% (Muy raro al inicio)
// Incremento: +2% por cada nivel de isla
var probabilidad = 5 + (nivel_actual * 2);

// Tope máximo: Nunca más del 40% para no hacerlo injugable
if (probabilidad > 40) probabilidad = 40;

// Tiramos el dado (0 a 99)
var dado = irandom(100);

show_debug_message("🎲 Probabilidad de Contaminación: " + string(probabilidad) + "% (Nivel " + string(nivel_actual) + ")");

// =========================================================
//        GENERACIÓN
// =========================================================

if (dado < probabilidad) {
    
    // ¡TOCA CONTAMINACIÓN!
    var cantidad = irandom_range(2, 5);
    var creadas = 0;
    var intentos = 0;

    while (creadas < cantidad && intentos < 1000) {
        intentos++;
        var px = irandom(room_width);
        var py = irandom(room_height);
        
        var es_agua = tilemap_get_at_pixel(global.tilemap_agua, px, py) > 0;
        var es_nieve = tilemap_get_at_pixel(global.tilemap_nieve, px, py) > 0;
        var libre = !position_meeting(px, py, Pollution); 
        
        if (es_agua && !es_nieve && libre) {
            var nueva = instance_create_layer(px, py, "Instances", Pollution);
            nueva.image_angle = irandom(360);
            creadas++;
        }
    }
    show_debug_message("☢️ ¡VERTIDO TÓXICO GENERADO!");
} 
else {
    show_debug_message("🍀 El mar se mantiene limpio.");
}

// --- REINICIAR TEMPORIZADOR ---
// Chequear de nuevo en 1 a 2 minutos
alarm[0] = irandom_range(3600, 7200);
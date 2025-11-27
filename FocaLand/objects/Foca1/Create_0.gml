/// @description Configuración Foca Gris

// --- MOVIMIENTO ---
// ... (resto de variables) ...
cooldown_susto = 0;   // Tiempo que se queda en tierra por miedo
velocidad_propia = 1.5;   // Velocidad en tierra
velocidad_caza = 3.5;     // Velocidad en agua (¡Más rápida!)
dir_movimiento = irandom(359);
image_speed = 0.5;

// --- INTELIGENCIA ARTIFICIAL (ESTADOS) ---
estado = "PASEAR";      // Puede ser: "PASEAR", "CAZAR", "REGRESAR"
rango_vision = 250;     // Distancia a la que ve un pez
pez_objetivo = noone;   // Variable para recordar a qué pez persigue

// --- MAPA ---
// Aseguramos que la variable global del mapa exista (creada por obj_Mapa)
if (!variable_global_exists("tilemap_nieve")) {
    // Intento de rescate si obj_Mapa no cargó primero
    var lay_id = layer_get_id("TilesSnow");
    global.tilemap_nieve = layer_tilemap_get_id(lay_id);
}

// ... (Tus variables anteriores se quedan igual) ...

// --- SISTEMA DE NECESIDADES ---
hambre = 0;             // Empieza llena
limite_hambre = 300;    // Tiempo antes de querer salir a cazar (aprox 5-10 segundos)
tiempo_en_agua = 0;     // Para que no se quede nadando eternamente si no encuentra nada
max_tiempo_agua = 600;  // Si en 10 seg no encuentra nada, vuelve a descansar

// ... (código anterior) ...

// --- SISTEMA DE ESTAMINA (RESISTENCIA) ---
estamina_max = 300;     // Dura 5 segundos corriendo (a 60 FPS)
estamina = estamina_max; 
cansada = false;        // Bandera para saber si ya se agotó

// --- SISTEMA DE ENFERMEDAD ---
tiempo_enfermedad = 0; // Contador: Si es > 0, está envenenado
duracion_veneno = 1200; // 20 SEGUNDOS de enfermedad (60fps * 20)
/// @description IA: Depredador Implacable

if (!variable_global_exists("tilemap_nieve")) exit;

// =========================================================
//                  ESTADO 1: PATRULLAR
// =========================================================
if (estado == "PATRULLAR") {
    
    var _dx = lengthdir_x(velocidad_patrulla, dir_movimiento);
    var _dy = lengthdir_y(velocidad_patrulla, dir_movimiento);
    var choco = false;

    // --- COLCHÓN DE SEGURIDAD AUMENTADO ---
    // Aumentamos la distancia del sensor a 120 pixeles.
    // La orca girará MUCHO antes de tocar la orilla blanca.
    var dist_sensor = 320; 

    // Chequeo Horizontal
    if (tilemap_get_at_pixel(global.tilemap_nieve, x + lengthdir_x(dist_sensor, dir_movimiento), y) > 0) {
        _dx = -_dx; 
        x -= sign(_dx) * 10; // Empujón fuerte hacia atrás
        choco = true;
    }
    
    // Chequeo Vertical
    if (tilemap_get_at_pixel(global.tilemap_nieve, x, y + lengthdir_y(dist_sensor, dir_movimiento)) > 0) {
        _dy = -_dy; 
        y -= sign(_dy) * 10; // Empujón fuerte hacia atrás
        choco = true;
    }
    
    // Límites del mundo (igual que antes)
    if (x < 0 || x > room_width || y < 0 || y > room_height) {
        dir_movimiento += 180; choco = true;
    }

    if (choco) {
        // Al chocar, gira hacia el mar abierto
        dir_movimiento = point_direction(room_width/2, room_height/2, x, y) + irandom_range(-45, 45);
    }

    x += _dx;
    y += _dy;
}
    
    // ... (El resto del código de Acecho y Radar sigue igual abajo) ...

// =========================================================
//                  ESTADO 2: PERSEGUIR
// =========================================================
else if (estado == "PERSEGUIR") {
    
    // Si la foca murió o desapareció
    if (!instance_exists(objetivo)) { estado = "PATRULLAR"; exit; }
    
    // Si la foca llegó a tierra firme -> FRUSTRACIÓN
    if (tilemap_get_at_pixel(global.tilemap_nieve, objetivo.x, objetivo.y) > 0) {
        estado = "PATRULLAR";
        // Girar e irse rápido para no quedarse "campeando"
        dir_movimiento += 180 + irandom_range(-30, 30);
        objetivo = noone;
        exit;
    }
	
	// --- MECÁNICA: SONAR (LLAMADA DE AUXILIO) ---
    // Probabilidad de "gritar" (aprox. 1 vez por segundo)
    if (irandom(60) == 0) {
        
        var mi_presa = objetivo; // La foca que estoy persiguiendo
        var yo_mismo = id;       // Mi ID para no llamarme a mí misma
        
        // Buscar orcas aliadas en un radio de 800 pixeles
        with (orca) {
            // Si soy otra orca, estoy patrullando (libre) y estoy cerca...
            if (id != yo_mismo && estado == "PATRULLAR") {
                
                var distancia_al_grito = point_distance(x, y, other.x, other.y);
                
                if (distancia_al_grito < 800) {
                    // ¡Cambio de planes! Ayudar a la compañera
                    estado = "PERSEGUIR";
                    objetivo = mi_presa; // Copiamos el objetivo de la orca que gritó
                    
                    // Efecto visual (Opcional): Un pequeño salto para indicar que se activó
                    y -= 5; 
                    show_debug_message("¡Refuerzos en camino!");
                }
            }
        }
    }

    // PERSECUCIÓN DIRECTA
    var dir = point_direction(x, y, objetivo.x, objetivo.y);
    
    // Movimiento
    x += lengthdir_x(velocidad_caza, dir);
    y += lengthdir_y(velocidad_caza, dir);
    
    // Animación
    if (objetivo.x - x != 0) image_xscale = sign(objetivo.x - x);
	
	// ... (Cierre de estados)

// =========================================================
//        SISTEMA ANTI-ATASCO (Siempre Activo)
// =========================================================

// Si por alguna razón estoy pisando nieve...
if (tilemap_get_at_pixel(global.tilemap_nieve, x, y) > 0) {
    
    // Calcular dirección hacia afuera del centro
    var dir_afuera = point_direction(room_width/2, room_height/2, x, y);
    
    // Empujón fuerte hacia el mar (independiente de la velocidad)
    x += lengthdir_x(5, dir_afuera);
    y += lengthdir_y(5, dir_afuera);
    
    // Si estaba persiguiendo, cancelo para no insistir contra la pared
    if (estado == "PERSEGUIR") {
        estado = "PATRULLAR";
        objetivo = noone;
        dir_movimiento = dir_afuera; // Mirar hacia el mar
    }
}

// ... (Aquí terminan tus estados) ...

// =========================================================
//        SISTEMA DE SEGURIDAD (ANTI-FUGA)
// =========================================================

// 1. Forzar posición dentro del mapa (con margen de 50px)
x = clamp(x, 50, room_width - 50);
y = clamp(y, 50, room_height - 50);

// 2. Si tocan el borde, girar hacia el centro
if (x <= 50 || x >= room_width - 50 || y <= 50 || y >= room_height - 50) {
    dir_movimiento = point_direction(x, y, room_width/2, room_height/2);
    // Un pequeño empujón aleatorio para que no se vean robóticas
    dir_movimiento += irandom_range(-20, 20);
}
}
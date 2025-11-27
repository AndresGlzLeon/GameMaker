/// @description TRUCO: Aumentar Nivel de Isla

// Acceder al objeto mapa y subir nivel
with(obj_Mapa) {
    nivel_isla++;
    event_user(0); // Forzar redibujado del mapa
}
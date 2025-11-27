/// @description Comer Foca
instance_destroy(other); // Destruye la foca
estado = "PATRULLAR";    // Vuelve a patrullar
show_debug_message("¡Una orca se comió una foca! 🩸");

// 1. Contador de Focas Muertas 
global.focas_muertas += 1;

// 2. Destruir y Resetear
instance_destroy(other); 
estado = "PATRULLAR";
dir_movimiento += 180; 
show_debug_message("¡Tienes una Foca menos!");
/// @description Morir por Contaminación

// Efecto visual de muerte tóxica (Burbujas verdes/negras)
effect_create_above(ef_smoke, x, y, 0, c_dkgray);

// Destruir al pez
instance_destroy();

show_debug_message("☠️ Un pez murió por contaminación.");
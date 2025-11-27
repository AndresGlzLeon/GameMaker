/// @description COMER PEZ

// 1. Destruir al pez
instance_destroy(other);

// 2. Sumar al contador global
if (variable_global_exists("pescado_capturado")) {
    global.pescado_capturado += 1;
}

// 3. Volver a casa
estado = "REGRESAR";
pez_objetivo = noone;
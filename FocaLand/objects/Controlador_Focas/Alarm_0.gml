/// @description Apagar Modo Carga (Después de que carguen todas las especies)
// Este evento se ejecuta 5 frames después del Create
// Damos tiempo a que todos los controladores lean sus datos antes de apagar
if (variable_global_exists("modo_carga") && global.modo_carga == true) {
    global.modo_carga = false;
    show_debug_message("✓ MODO CARGA FINALIZADO - Todas las especies restauradas.");
}

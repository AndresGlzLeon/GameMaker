// ... (Tu código de movimiento/respiración anterior se queda igual) ...

// --- CUENTA REGRESIVA ---
if (vida > 0) {
    vida--; // Restar tiempo
} else {
    desvaneciendo = true; // ¡Se acabó el tiempo!
}

// --- DESAPARECER (FADE OUT) ---
if (desvaneciendo) {
    // Bajamos la transparencia poco a poco
    image_alpha -= 0.01; 
    
    // Si ya es invisible, destruir el objeto para liberar memoria
    if (image_alpha <= 0) {
        instance_destroy();
    }
}
/// @description Animación y Desaparición

// --- 1. EFECTO VISUAL (Respiración) ---
image_angle += 0.05; // Girar lento

tiempo++;
var oscilacion = sin(tiempo * 0.05) * 0.05;

// Aplicar oscilación sobre el tamaño actual
// (Usamos += para que sea suave y no resetee la escala)
image_xscale += oscilacion * 0.005; 
image_yscale += oscilacion * 0.005; 


// --- 2. LÓGICA DE VIDA ---
if (vida > 0) {
    vida--; // Cuenta regresiva
} else {
    desvaneciendo = true; // ¡Se acabó el tiempo!
}

// --- 3. DESAPARECER (FADE OUT) ---
if (desvaneciendo) {
    // Se vuelve transparente poco a poco
    image_alpha -= 0.005; 
    
    // Cuando es invisible, se destruye
    if (image_alpha <= 0) {
        instance_destroy();
    }
}
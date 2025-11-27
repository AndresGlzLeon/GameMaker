function scr_GetTileIndex(_grid, _x, _y){
    
    var ancho = ds_grid_width(_grid);
    var alto = ds_grid_height(_grid);
    
    // 1. Detectar vecinos (1 = Hay Nieve, 0 = Agua)
    var norte = 0;
    var oeste = 0;
    var este  = 0;
    var sur   = 0;
    
    // Check Norte
    if (_y - 1 < 0) norte = 1; // Borde del mundo cuenta como nieve
    else if (_grid[# _x, _y - 1] > 0) norte = 1;
    
    // Check Oeste
    if (_x - 1 < 0) oeste = 1;
    else if (_grid[# _x - 1, _y] > 0) oeste = 1;
    
    // Check Este
    if (_x + 1 >= ancho) este = 1;
    else if (_grid[# _x + 1, _y] > 0) este = 1;
    
    // Check Sur
    if (_y + 1 >= alto) sur = 1;
    else if (_grid[# _x, _y + 1] > 0) sur = 1;
    
    // 2. Calcular Máscara (Bitmasking)
    // N=1, O=2, E=4, S=8
    var mask = (norte * 1) + (oeste * 2) + (este * 4) + (sur * 8);
    
    var tile_final = 0;
    
    // 3. DICCIONARIO CORREGIDO SEGÚN TU IMAGEN
    // Basado en el orden: 1=EsqSI, 2=Arriba, 3=EsqSD, 4=Izq, 5=Centro, etc.
    
    switch(mask) {
        case 0:  tile_final = 0;  break; // Agua (Solo)
        
        // --- EL CENTRO Y BORDES PRINCIPALES ---
        case 15: tile_final = 5;  break; // Centro Sólido (N+S+E+O)
        
        case 14: tile_final = 2;  break; // Borde Superior (S+E+O)
        case 13: tile_final = 4;  break; // Borde Izquierdo (N+S+E)
        case 11: tile_final = 6;  break; // Borde Derecho (N+S+O)
        case 7:  tile_final = 8;  break; // Borde Inferior (N+E+O)
        
        // --- LAS ESQUINAS ---
        case 12: tile_final = 1;  break; // Esquina Sup-Izq (E+S)
        case 10: tile_final = 3;  break; // Esquina Sup-Der (O+S)
        case 5:  tile_final = 7;  break; // Esquina Inf-Izq (N+E)
        case 3:  tile_final = 9;  break; // Esquina Inf-Der (N+O)
        
        // --- SITUACIONES RARAS (Líneas delgadas) ---
        // Si la isla es muy delgada (1 bloque de ancho), usamos piezas que se vean bien
        case 1:  tile_final = 8;  break; // Punta final (Solo Norte) -> Usamos borde abajo
        case 4:  tile_final = 4;  break; // Punta final (Solo Este) -> Usamos borde izq
        case 2:  tile_final = 6;  break; // Punta final (Solo Oeste) -> Usamos borde der
        case 8:  tile_final = 2;  break; // Punta final (Solo Sur) -> Usamos borde arriba
        case 6:  tile_final = 5;  break; // Pasillo horizontal -> Usamos centro
        case 9:  tile_final = 5;  break; // Pasillo vertical -> Usamos centro
        
        default: tile_final = 5; break; // Ante la duda, pon nieve sólida
    }
    
    return tile_final;
}
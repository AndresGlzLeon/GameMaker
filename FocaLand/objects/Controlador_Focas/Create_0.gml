/// Crear focas al inicio

var cantidad_focas = 10;

for (var i = 0; i < cantidad_focas; i++) {
    var pos_x = irandom_range(50, room_width - 50);
    var pos_y = irandom_range(50, room_height - 50);

    // Crear una foca aleatoria (entre los dos tipos)
    if (irandom(1) == 0) {
        instance_create_layer(pos_x, pos_y, "Instances", Foca1);
    } else {
        instance_create_layer(pos_x, pos_y, "Instances", Foca2);
    }
}

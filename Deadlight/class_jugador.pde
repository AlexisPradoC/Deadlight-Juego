class Jugador {

  PVector posicion;
  PVector velocidad;

  float velocidadMovimiento = 3;
  PImage sprite;

  Jugador(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    sprite = img;
  }

  void actualizar() {

    velocidad.set(0, 0);

    if (keyPressed) {

      if (key == 'w' || key == 'W') {
        velocidad.y = -velocidadMovimiento;
      }
      if (key == 's' || key == 'S') {
        velocidad.y = velocidadMovimiento;
      }

      if (key == 'a' || key == 'A') {
        velocidad.x = -velocidadMovimiento;
      }

      if (key == 'd' || key == 'D') {
        velocidad.x = velocidadMovimiento;
      }
    }

    posicion.add(velocidad);

    posicion.x = constrain(posicion.x, 20, width - 20);
    posicion.y = constrain(posicion.y, 20, height - 20);
  }

  void mostrar() {
    imageMode(CENTER);
    image(sprite, posicion.x, posicion.y, 70, 70);
  }
}

void keyPressed() {
  if (estadoDelJuego == 1 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 2;
  } 
  else if (estadoDelJuego == 2 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 1;
  }
}

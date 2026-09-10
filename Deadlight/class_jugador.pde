class Jugador {

  PVector posicion;
  PVector velocidad;

  float velocidadMovimiento = 3;

  Jugador(float x, float y) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
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

    fill(255);
    noStroke();

    ellipse(posicion.x, posicion.y, 30, 30);
  }
}


void keyPressed() {


  if (estadoDelJuego == 0 && keyCode == ENTER) {
    estadoDelJuego = 1;
  }


  else if (estadoDelJuego == 1 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 2;
  }


  else if (estadoDelJuego == 2 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 1;
  }


  else if (estadoDelJuego == 3 && keyCode == ENTER) {
    estadoDelJuego = 0;
  }
}

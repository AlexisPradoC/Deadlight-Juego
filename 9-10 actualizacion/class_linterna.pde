class Linterna {
  PVector posicion;
  float alcance = 250;
  float ancho = PI / 3;
  float angulo;
  
  float distanciaMano = 35;
  float desplazamientoLateral = 17.2;

  Linterna() {
    posicion = new PVector();
  }

  void actualizar(PVector posicionJugador) {
    angulo = atan2(
      mouseY - posicionJugador.y,
      mouseX - posicionJugador.x
    );
    
    posicion.x = posicionJugador.x + cos(angulo) * distanciaMano + cos(angulo - HALF_PI) * desplazamientoLateral;
    posicion.y = posicionJugador.y + sin(angulo) * distanciaMano + sin(angulo - HALF_PI) * desplazamientoLateral;
  }

  void mostrar() {
    pushMatrix();
    translate(posicion.x, posicion.y);
    rotate(angulo);
    fill(255, 255, 180, 60);
    noStroke();

    arc(
      0,
      0,
      alcance * 2,
      alcance * 2,
      -ancho / 2,
      ancho / 2,
      PIE
    );

    popMatrix();
  }

  boolean ilumina(Enemigo enemigo) {
    PVector direccion = PVector.sub(
      enemigo.posicion,
      posicion
    );

    float distancia = direccion.mag();

    if (distancia > alcance) {
      return false;
    }

    float anguloEnemigo = atan2(
      direccion.y,
      direccion.x
    );

    float diferencia = abs(
      atan2(
        sin(anguloEnemigo - angulo),
        cos(anguloEnemigo - angulo)
      )
    );

    if (diferencia <= ancho / 2) {
      return true;
    }

    return false;
  }
}

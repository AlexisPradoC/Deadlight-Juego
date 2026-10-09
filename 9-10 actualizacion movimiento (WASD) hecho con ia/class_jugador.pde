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

    // Evaluamos las banderas globales de las teclas
    if (movUp)    velocidad.y = -velocidadMovimiento;
    if (movDown)  velocidad.y = velocidadMovimiento;
    if (movLeft)  velocidad.x = -velocidadMovimiento;
    if (movRight) velocidad.x = velocidadMovimiento;

    // Normaliza el vector para evitar que en diagonal se mueva más rápido
    if (velocidad.mag() > 0) {
      velocidad.normalize();
      velocidad.mult(velocidadMovimiento);
    }

    posicion.add(velocidad);

    // Límites de la pantalla
    posicion.x = constrain(posicion.x, 20, width - 20);
    posicion.y = constrain(posicion.y, 20, height - 20);
  }

  void mostrar() {
    pushMatrix();
    imageMode(CENTER);
    translate(posicion.x, posicion.y);
    rotate(linterna.angulo);
    image(sprite, 0, 0, 90, 90);
    popMatrix();
  }
}

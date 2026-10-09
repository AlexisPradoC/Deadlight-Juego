class Jugador {
  PVector posicion;
  PVector velocidad;

  float velocidadMovimiento = 3;
  PImage sprite;

  // Salud de 200 puntos
  float vidaMax = 200;
  float vida = 200;
  float radioColision = 20;

  Jugador(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    sprite = img;
  }

  void actualizar() {
    velocidad.set(0, 0);

    if (movUp)    velocidad.y = -velocidadMovimiento;
    if (movDown)  velocidad.y = velocidadMovimiento;
    if (movLeft)  velocidad.x = -velocidadMovimiento;
    if (movRight) velocidad.x = velocidadMovimiento;

    // Normalización para diagonales fluidas
    if (velocidad.mag() > 0) {
      velocidad.normalize();
      velocidad.mult(velocidadMovimiento);
    }

    posicion.add(velocidad);

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

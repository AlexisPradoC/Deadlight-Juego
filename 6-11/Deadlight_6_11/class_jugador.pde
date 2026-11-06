class Jugador {

  PVector posicion;
  PVector velocidad;

  float velocidadMovimiento = 3;
  float angulo = 0;
  PImage sprite;

  Jugador(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    sprite = img;
  }

    void actualizar() {
    // 1. Calculamos hacia dónde queremos ir
    float dx = 0;
    float dy = 0;

    if (movUp)    dy -= 1;
    if (movDown)  dy += 1;
    if (movLeft)  dx -= 1;
    if (movRight) dx += 1;

    // Normalizamos para que en diagonal no vaya más rápido
    PVector dir = new PVector(dx, dy);
    if (dir.mag() > 0) {
      dir.normalize();
      dir.mult(velocidadMovimiento);
    }

    // 2. Movemos el eje X solo si no choca
    if (!chocaConPared(posicion.x + dir.x, posicion.y)) {
      posicion.x += dir.x;
    }

    // 3. Movemos el eje Y solo si no choca
    if (!chocaConPared(posicion.x, posicion.y + dir.y)) {
      posicion.y += dir.y;
    }

    // Límites de la pantalla
    posicion.x = constrain(posicion.x, 20, width - 20);
    posicion.y = constrain(posicion.y, 20, height - 20);
    
    // Ángulo de la linterna
    angulo = atan2(mouseY - posicion.y, mouseX - posicion.x);
  }


  // Función que revisa si en una coordenada hay una pared/mesa
  boolean chocaConPared(float proxX, float proxY) {
    float radioJugador = 20; // Ajustá esto si tu personaje es más grande o chico

    for (float[] hb : hitboxes) {
      // Comprobación matemática de colisión (AABB)
      if (proxX + radioJugador > hb[0] && proxX - radioJugador < hb[0] + hb[2] &&
          proxY + radioJugador > hb[1] && proxY - radioJugador < hb[1] + hb[3]) {
        return true; // Hay choque
      }
    }
    return false; // Está libre
  }

  void mostrar() {
    pushMatrix();
    imageMode(CENTER);
    translate(posicion.x, posicion.y);
    rotate(angulo);
    image(sprite, 0, 0, 90, 90);
    popMatrix();
  }
}

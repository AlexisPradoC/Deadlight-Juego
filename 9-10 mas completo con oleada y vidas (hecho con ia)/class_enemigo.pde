class Enemigo {
  PVector posicion;
  float radio = 20;
  boolean iluminado = false;

  float vidaMax = 75;
  float vida = 75;

  Enemigo(float x, float y) {
    posicion = new PVector(x, y);
  }

  void actualizar(Linterna linterna) {
    iluminado = linterna.ilumina(this);
    
    // Daño de 15 por segundo si la luz lo alumbra
    if (iluminado && linterna.energia > 0) {
      vida -= 15.0 / 60.0;
      if (vida < 0) vida = 0;
    }

    PVector direccion = PVector.sub(
      jugador.posicion,
      posicion
    );

    float distancia = direccion.mag();

    if (distancia > 0) {
      direccion.normalize();
      if (iluminado && linterna.energia > 0) {
        direccion.mult(-1);
      }
      posicion.add(PVector.mult(direccion, 1.0));
    }

    // Daño al jugador por contacto físico
    if (distancia < radio + jugador.radioColision) {
      jugador.vida -= 20.0 / 60.0;
      if (jugador.vida < 0) jugador.vida = 0;
    }
  }

  void mostrar() {
    noStroke();
    if (iluminado) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }

    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);

    // Barra de salud del enemigo
    float anchoBarra = 40;
    float altoBarra = 5;
    float xBarra = posicion.x - anchoBarra / 2;
    float yBarra = posicion.y - radio - 10;

    fill(60, 60, 60);
    rect(xBarra, yBarra, anchoBarra, altoBarra, 2);

    fill(0, 255, 0);
    float anchoActual = (vida / vidaMax) * anchoBarra;
    rect(xBarra, yBarra, anchoActual, altoBarra, 2);
  }
}

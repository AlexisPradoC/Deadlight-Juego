class Enemigo {
  PVector posicion;
  float radio = 20;
  boolean iluminado = false;

  Enemigo(float x, float y) {
    posicion = new PVector(x, y);
  }

  void actualizar(Linterna linterna) {
    iluminado = linterna.ilumina(this);
  }

  void mostrar() {
    noStroke();
    if (iluminado) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }

    ellipse(
      posicion.x,
      posicion.y,
      radio * 2,
      radio * 2
      );
  }
}

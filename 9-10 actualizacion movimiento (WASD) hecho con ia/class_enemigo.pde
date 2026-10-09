class Enemigo {
  PVector posicion;
  float radio = 20;
  boolean iluminado = false;

  Enemigo(float x, float y) {
    posicion = new PVector(x, y);
  }

void actualizar(Linterna linterna) {
    iluminado = linterna.ilumina(this);
    PVector direccion = PVector.sub(
      jugador.posicion,
      posicion
    );
    if(direccion.mag() > 0) {
      direccion.normalize();
      if(iluminado) {
        direccion.mult(-1);
      }
      posicion.add(PVector.mult(direccion,
      1.0));
    }
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

class Bateria {
  PVector posicion;
  float radio = 12;

  Bateria(float x, float y) {
    posicion = new PVector(x, y);
  }

  void mostrar() {
    pushStyle();
    rectMode(CENTER);
    
    // Cuerpo de la batería
    fill(255, 215, 0);
    stroke(255);
    strokeWeight(1.5);
    rect(posicion.x, posicion.y, 14, 22, 3);
    
    // Polo positivo
    fill(200);
    rect(posicion.x, posicion.y - 13, 6, 4, 1);
    
    popStyle();
  }

  boolean recogida(Jugador j) {
    float distancia = PVector.dist(posicion, j.posicion);
    return distancia < radio + j.radioColision;
  }
}

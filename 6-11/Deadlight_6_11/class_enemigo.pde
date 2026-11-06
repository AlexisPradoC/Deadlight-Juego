class Enemigo {
  PVector posicion;
  float radio = 20;
  boolean iluminado = false;
  
  PImage sprite;
  float angulo = 0;


  Enemigo(float x, float y, PImage img) {
    posicion = new PVector(x, y);
    sprite = img;
  }

  void actualizar(Linterna linterna) {
    iluminado = linterna.ilumina(this);
    
    PVector direccion = PVector.sub(jugador.posicion, posicion);
    
    if (direccion.mag() > 0) {
      angulo = atan2(direccion.y, direccion.x);
      
      direccion.normalize();
      if (iluminado) {
        direccion.mult(-1);
      }
      posicion.add(PVector.mult(direccion, 1.0));
    }
  }

  void mostrar() {
    pushMatrix();
    translate(posicion.x, posicion.y);
    rotate(angulo); 
    
    imageMode(CENTER);


    if (iluminado) {
      tint(255, 50, 50); 
    }

  
    image(sprite, 0, 0, radio * 2.5, radio * 2.5);

    noTint(); 
    popMatrix();
  }
}

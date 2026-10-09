class Boss extends Enemigo {

  Boss(float x, float y) {
    super(x, y);
    radio = 40;     
    vidaMax = 300;      
    vida = 300;
  }

  void actualizar(Linterna linterna) {
    iluminado = linterna.ilumina(this);
    
    if (iluminado && linterna.energia > 0) {
      vida -= 10.0 / 60.0;
      if (vida < 0) vida = 0;
    }

    PVector direccion = PVector.sub(jugador.posicion, posicion);
    float distancia = direccion.mag();

    if (distancia > 0) {
      direccion.normalize();
      if (iluminado && linterna.energia > 0) {
        direccion.mult(-0.4); 
      } else {
        direccion.mult(1.1);  
      }
      posicion.add(direccion);
    }

    // Daño elevado del Boss al tocar al jugador
    if (distancia < radio + jugador.radioColision) {
      jugador.vida -= 35.0 / 60.0;
      if (jugador.vida < 0) jugador.vida = 0;
    }
  }

  void mostrar() {
    noStroke();
    
    if (iluminado) {
      fill(220, 20, 120); 
    } else {
      fill(130, 0, 40);    
    }

    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);

    // Barra de salud del Boss
    float anchoBarra = 70;
    float altoBarra = 7;
    float xBarra = posicion.x - anchoBarra / 2;
    float yBarra = posicion.y - radio - 15;

    fill(60, 60, 60);
    rect(xBarra, yBarra, anchoBarra, altoBarra, 3);

    fill(255, 128, 0); 
    float anchoActual = (vida / vidaMax) * anchoBarra;
    rect(xBarra, yBarra, anchoActual, altoBarra, 3);
  }
}

class Linterna {
  PVector posicion;
  float alcance = 250;
  float ancho = PI / 3;
  float angulo;
  
  float distanciaMano = 35;
  float desplazamientoLateral = 17.2;

  // 20 segundos de energía
  float energiaMax = 20.0;
  float energia = 20.0;

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

    // Consumo gradual (1 segundo cada 60 frames)
    if (energia > 0) {
      energia -= 1.0 / 60.0;
      if (energia < 0) {
        energia = 0;
      }
    }
  }

  void mostrar() {
    if (energia <= 0) return;

    float alfaLuz = 60;

    // Efecto de parpadeo cuando quedan 4 segundos o menos
    if (energia <= 3.0) {
      if (random(1) < 0.3) {
        alfaLuz = random(10, 25);
      }
      if (random(1) < 0.25) {
        return; 
      }
    }

    pushMatrix();
    translate(posicion.x, posicion.y);
    rotate(angulo);
    fill(255, 255, 180, alfaLuz);
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
    if (energia <= 0) return false;

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

  void recargar(float cantidad) {
    energia += cantidad;
    if (energia > energiaMax) {
      energia = energiaMax;
    }
  }
}

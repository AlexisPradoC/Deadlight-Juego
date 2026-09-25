Jugador jugador;
Linterna linterna;

ArrayList<Enemigo> enemigos;

int estadoDelJuego = 0; 

PImage spriteJugador;

void setup() {
  size(800, 600);


  spriteJugador = loadImage("jugador.png");

  jugador = new Jugador(width/2, height/2, spriteJugador);
  linterna = new Linterna();

  enemigos = new ArrayList<Enemigo>();

  enemigos.add(new Enemigo(200, 150));
  enemigos.add(new Enemigo(700, 150));
  enemigos.add(new Enemigo(700, 450));
  enemigos.add(new Enemigo(200, 450));
  enemigos.add(new Enemigo(500, 250));
}

void draw() {
  background(30);

  if (estadoDelJuego == 0) {
    mostrarMenu();
  } 
  else if (estadoDelJuego == 1) {
    jugar();
  } 
  else if (estadoDelJuego == 2) {

    jugar(); 

    mostrarPausa();
  } 
  else if (estadoDelJuego == 3) {
    mostrarGameOver();
  }
  else if (estadoDelJuego == 4) {
    mostrarOpciones();
  }
  else if (estadoDelJuego == 5) {
    mostrarCreditos();
  }
}

void jugar() {

  if (estadoDelJuego == 1) {
    jugador.actualizar();
    linterna.actualizar(jugador.posicion);
    for (Enemigo enemigo : enemigos) {
      enemigo.actualizar(linterna);
    }
  }

  linterna.mostrar();
  jugador.mostrar();

  for (Enemigo enemigo : enemigos) {
    enemigo.mostrar();
  }
}


void mostrarMenu() {
  fill(255);
  textAlign(LEFT, CENTER);

  textSize(60);
  text("DeadLight", 80, 120);


  crearBoton(80, 220, 220, 50, "JUGAR", LEFT);
  crearBoton(80, 290, 220, 50, "OPCIONES", LEFT);
  crearBoton(80, 360, 220, 50, "CRÉDITOS", LEFT);
  crearBoton(80, 430, 220, 50, "SALIR", LEFT);


  imageMode(CENTER);

  image(spriteJugador, 600, 350, 250, 250);
}


void mostrarOpciones() {
  fill(255);
  textAlign(LEFT, CENTER);
  
  textSize(40);
  text("OPCIONES", 80, 120);
  
  textSize(20);
  text("Controles:\n- WASD: Moverse\n- Mouse: Apuntar linterna\n- Tecla P: Pausa", 80, 240);

  crearBoton(80, 430, 220, 50, "VOLVER", LEFT);
}


void mostrarCreditos() {
  fill(255);
  textAlign(LEFT, CENTER);
  
  textSize(40);
  text("CRÉDITOS", 80, 120);
  
  textSize(20);
  text("Desarrollado por: Alexis P. - Leonel A.\nJuego en Processing Beta 1.1", 80, 240);

  crearBoton(80, 430, 220, 50, "VOLVER", LEFT);
}


void mostrarPausa() {

  fill(0, 0, 0, 160);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, CENTER);

  textSize(50);
  text("PAUSA", width/2, 180);

  crearBoton(width/2 - 100, 260, 200, 50, "REANUDAR", CENTER);
  crearBoton(width/2 - 100, 330, 200, 50, "SALIR AL MENÚ", CENTER);
}


void mostrarGameOver() {
  fill(255);
  textAlign(CENTER, CENTER);

  textSize(50);
  text("GAME OVER", width/2, 200);

  crearBoton(width/2 - 100, 300, 200, 50, "MENÚ PRINCIPAL", CENTER);
}


boolean sobreBoton(float x, float y, float ancho, float alto) {
  return mouseX >= x && mouseX <= x + ancho && mouseY >= y && mouseY <= y + alto;
}

void crearBoton(float x, float y, float ancho, float alto, String texto, int alineacion) {
  boolean sobre = sobreBoton(x, y, ancho, alto);

  rectMode(CORNER);
  stroke(255);
  strokeWeight(2);

  if (sobre) {
    fill(255, 255, 180, 220);
  } else {
    fill(40, 40, 40, 200);
  }

  rect(x, y, ancho, alto, 10);

  fill(sobre ? 0 : 255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(texto, x + ancho/2, y + alto/2);
}


void mouseClicked() {
  if (estadoDelJuego == 0) {
    if (sobreBoton(80, 220, 220, 50)) {
      estadoDelJuego = 1;
    } else if (sobreBoton(80, 290, 220, 50)) {
      estadoDelJuego = 4;
    } else if (sobreBoton(80, 360, 220, 50)) {
      estadoDelJuego = 5;
    } else if (sobreBoton(80, 430, 220, 50)) {
      exit();
    }
  } 
  else if (estadoDelJuego == 2) {
    if (sobreBoton(width/2 - 100, 260, 200, 50)) {
      estadoDelJuego = 1;
    } else if (sobreBoton(width/2 - 100, 330, 200, 50)) {
      estadoDelJuego = 0;
    }
  } 
  else if (estadoDelJuego == 3) {
    if (sobreBoton(width/2 - 100, 300, 200, 50)) {
      estadoDelJuego = 0;
    }
  }
  else if (estadoDelJuego == 4 || estadoDelJuego == 5) {
    if (sobreBoton(80, 430, 220, 50)) {
      estadoDelJuego = 0;
    }
  }
}

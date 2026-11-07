Jugador jugador;
Linterna linterna;
ArrayList<float[]> hitboxes; 
boolean mostrarHitboxes = false; // Para ver los cuadros rojos al calibrar


ArrayList<Enemigo> enemigos;

int estadoDelJuego = 0; 

PImage spriteJugador;
PImage spriteEnemigo; 
PImage fondoMapa;

Nuevo//PImage fondoMapa2;

Nuevo//int escenaActual = 1;
// Banderas globales para el movimiento(WASD)
boolean movUp, movDown, movLeft, movRight;

void setup() {
  size(800, 600);

  spriteJugador = loadImage("jugador.png");
  spriteEnemigo = loadImage("enemigo.png");
  fondoMapa = loadImage("mapa.png");
fondoMapa2 = loadImage("mapa2.png"); //nuevo
  jugador = new Jugador(width/2, height/2, spriteJugador);
  linterna = new Linterna();

  enemigos = new ArrayList<Enemigo>();

  enemigos.add(new Enemigo(200, 150, spriteEnemigo));
  enemigos.add(new Enemigo(700, 150, spriteEnemigo));
  enemigos.add(new Enemigo(700, 450, spriteEnemigo));
  enemigos.add(new Enemigo(200, 450, spriteEnemigo));
  enemigos.add(new Enemigo(500, 250, spriteEnemigo));
  
  
    // --- CREACIÓN DE LAS HITBOXES ---
  hitboxes = new ArrayList<float[]>();
  
  // Coordenadas basadas en marcas rojas:
  hitboxes.add(new float[]{55, 0, 180, 145});   // 1. Mesa arriba izq
  hitboxes.add(new float[]{265, 0, 160, 115});  // 2. Tanques verdes arriba
  hitboxes.add(new float[]{510, 0, 215, 115});  // 3. Mesa arriba der
  hitboxes.add(new float[]{740, 135, 60, 160}); // 4. Tanque der
  hitboxes.add(new float[]{615, 230, 165, 110}); // 5. Mesa medio der
  hitboxes.add(new float[]{45, 300, 115, 55});   // 6. Camilla medio izq
  hitboxes.add(new float[]{330, 440, 150, 120}); // 7. Mueble abajo medio
  
}

void draw() {
  

  if (estadoDelJuego == 0 || estadoDelJuego == 4 || estadoDelJuego == 5) {
    background(30); 
    
  } else {
    imageMode(CORNER); 
    image(fondoMapa, 0, 0, width, height);
 
//Nuevo// if (escenaActual == 1) {
  image(fondoMapa, 0, 0, width, height);
}
else if (escenaActual == 2) {
  image(fondoMapa2, 0, 0, width, height);
  }
NUevo//
// Efecto de oscuridad
    fill(0, 100); 
    noStroke();
    rect(0, 0, width, height);
  }

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
  
    // MODO DEBUG: Ver hitboxes
  if (mostrarHitboxes && estadoDelJuego == 1) {
    noFill();
    stroke(255, 0, 0); 
    strokeWeight(2);
    for (float[] hb : hitboxes) {
      rect(hb[0], hb[1], hb[2], hb[3]);
    }
    noStroke();
  }
  
}

void jugar() {
  if (estadoDelJuego == 1) {
    jugador.actualizar();
    linterna.actualizar(jugador.posicion, jugador.angulo); 
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





NUevo/
void jugar() {
  if (estadoDelJuego == 1) {
    jugador.actualizar();

    // PASAR DE HABITACION 1 A 2
    if (escenaActual == 1 &&
        jugador.posicion.x >= width &&
        jugador.posicion.y > 250 &&
        jugador.posicion.y < 430) {

      escenaActual = 2;

      jugador.posicion.x = 30;
      jugador.posicion.y = 340;
    }

    // VOLVER DE HABITACION 2 A 1
    if (escenaActual == 2 &&
        jugador.posicion.x <= 0 &&
        jugador.posicion.y > 250 &&
        jugador.posicion.y < 430) {

      escenaActual = 1;

      jugador.posicion.x = width - 30;
      jugador.posicion.y = 340;
    }

    // ACTUALIZAR LINTERNA
    linterna.actualizar(jugador.posicion, jugador.angulo);

    // ACTUALIZAR ENEMIGOS
    for (Enemigo enemigo : enemigos) {
      enemigo.actualizar(linterna);
    }

    // MOSTRAR ELEMENTOS
    linterna.mostrar();
    jugador.mostrar();

    for (Enemigo enemigo : enemigos) {
      enemigo.mostrar();
    }
  }
}
Nuevi//
// CONTROL DE TECLADO

void keyPressed() {
  if (key == 'w' || key == 'W') movUp = true;
  if (key == 's' || key == 'S') movDown = true;
  if (key == 'a' || key == 'A') movLeft = true;
  if (key == 'd' || key == 'D') movRight = true;
 
  if (key == 'h' || key == 'H') {
    mostrarHitboxes = !mostrarHitboxes;
  }
  // Pausa con la tecla P dentro del juego
  if (estadoDelJuego == 1 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 2;
  } 
  else if (estadoDelJuego == 2 && (key == 'p' || key == 'P')) {
    estadoDelJuego = 1;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') movUp = false;
  if (key == 's' || key == 'S') movDown = false;
  if (key == 'a' || key == 'A') movLeft = false;
  if (key == 'd' || key == 'D') movRight = false;
}


// INTERFACES Y MENÚS
void mostrarMenu() {
  fill(255);
  textAlign(LEFT, CENTER);

  textSize(60);
  text("DeadLight", 80, 120);

  crearBoton(80, 220, 220, 50, "JUGAR", LEFT);
  crearBoton(80, 290, 220, 50, "OPCIONES", LEFT);
  crearBoton(80, 360, 220, 50, "CREDITOS", LEFT);
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
  text("CREDITOS", 80, 120);
  
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
  crearBoton(width/2 - 100, 330, 200, 50, "SALIR AL MENU", CENTER);
}

void mostrarGameOver() {
  fill(255);
  textAlign(CENTER, CENTER);

  textSize(50);
  text("GAME OVER", width/2, 200);

  crearBoton(width/2 - 100, 300, 200, 50, "MENU PRINCIPAL", CENTER);
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

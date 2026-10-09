Jugador jugador;
Linterna linterna;

ArrayList<Enemigo> enemigos;
ArrayList<Bateria> baterias;

int estadoDelJuego = 0; 
PImage spriteJugador;

// Sistema de Oleadas y Tiempos de Espera
int oleadaActual = 1;
int timerTransicion = 0;     // Cartel de "¡Oleada X!" (2 segundos)
int timerRecoleccion = 0;    // Tiempo para lootear baterías (10 segundos / 600 frames)

// Banderas para el movimiento fluido (WASD)
boolean movUp, movDown, movLeft, movRight;

void setup() {
  size(800, 600);

  spriteJugador = loadImage("jugador.png");

  jugador = new Jugador(width/2, height/2, spriteJugador);
  linterna = new Linterna();

  enemigos = new ArrayList<Enemigo>();
  baterias = new ArrayList<Bateria>();

  iniciarOleada();
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

// ==========================================
// LÓGICA DE OLEADAS Y JUEGO
// ==========================================
void iniciarOleada() {
  enemigos.clear();
  // Nota: Ya no limpiamos las baterías aquí para que no desaparezcan de golpe al terminar la oleada.

  if (oleadaActual == 10) {
    // Oleada 10: Boss Final
    enemigos.add(new Boss(width / 2, 150));
  } else {
    // Oleadas normales
    int cantidadEnemigos = oleadaActual * 2 + 2;
    for (int i = 0; i < cantidadEnemigos; i++) {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      enemigos.add(new Enemigo(x, y));
    }
  }
}

void jugar() {
  if (estadoDelJuego == 1) {
    
    // 1. FASE DE RECOLECCIÓN (10 segundos al matar a todos los enemigos)
    if (timerRecoleccion > 0) {
      timerRecoleccion--;
      
      // Permitimos mover al jugador y recoger baterías durante este tiempo
      jugador.actualizar();
      linterna.actualizar(jugador.posicion);
      
      for (int i = baterias.size() - 1; i >= 0; i--) {
        Bateria bat = baterias.get(i);
        if (bat.recogida(jugador)) {
          linterna.recargar(5);
          baterias.remove(i);
        }
      }

      // Dibujar elementos en pantalla durante el looteo
      for (Bateria bat : baterias) {
        bat.mostrar();
      }
      linterna.mostrar();
      jugador.mostrar();
      mostrarHUD();

      // Pantalla de aviso de tiempo para recolectar
      fill(0, 0, 0, 160);
      rect(0, 0, width, height);
      fill(255, 255, 0);
      textSize(30);
      textAlign(CENTER, CENTER);
      int segundosRestantes = ceil(timerRecoleccion / 60.0);
      text("¡OLEADA SUPERADA!\nTiempo para recolectar baterías: " + segundosRestantes + "s", width / 2, height / 2);

      // Cuando se acaba el tiempo de recolección, limpiamos baterías sobrantes y avanzamos
      if (timerRecoleccion == 0) {
        baterias.clear();
        oleadaActual++;
        if (oleadaActual > 10) {
          oleadaActual = 10; 
        }
        iniciarOleada();
        timerTransicion = 120; // 2 segundos de cartel de nueva oleada
      }
      return;
    }

    // 2. FASE DE TRANSICIÓN DE NUEVA OLEADA (2 segundos)
    if (timerTransicion > 0) {
      timerTransicion--;
      
      fill(0, 0, 0, 200);
      rect(0, 0, width, height);
      
      fill(255, 255, 0);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("¡OLEADA " + oleadaActual + "!", width / 2, height / 2);
      return; 
    }

    // 3. JUEGO NORMAL
    jugador.actualizar();
    linterna.actualizar(jugador.posicion);
    
    // Actualizar enemigos y manejar muertes / probabilidad de baterías (60%)
    for (int i = enemigos.size() - 1; i >= 0; i--) {
      Enemigo enemigo = enemigos.get(i);
      enemigo.actualizar(linterna);
      
      if (enemigo.vida <= 0) {
        if (random(1) < 0.6) {
          baterias.add(new Bateria(enemigo.posicion.x, enemigo.posicion.y));
        }
        enemigos.remove(i);
      }
    }

    // Si se eliminaron todos los enemigos, activamos los 10 segundos de recolección
    if (enemigos.size() == 0 && timerRecoleccion == 0 && timerTransicion == 0) {
      timerRecoleccion = 600; // 600 frames = 10 segundos (a 60 FPS)
    }

    // Actualizar baterías en el suelo
    for (int i = baterias.size() - 1; i >= 0; i--) {
      Bateria bat = baterias.get(i);
      if (bat.recogida(jugador)) {
        linterna.recargar(5);
        baterias.remove(i);
      }
    }

    // Comprobar si el jugador muere
    if (jugador.vida <= 0) {
      estadoDelJuego = 3;
    }
  }

  for (Bateria bat : baterias) {
    bat.mostrar();
  }

  linterna.mostrar();
  jugador.mostrar();

  for (Enemigo enemigo : enemigos) {
    enemigo.mostrar();
  }

  mostrarHUD();
}

void mostrarHUD() {
  pushStyle();
  
  // Salud del Jugador
  fill(50);
  rect(20, 20, 200, 20, 5);
  fill(0, 200, 0);
  float anchoSalud = map(jugador.vida, 0, jugador.vidaMax, 0, 200);
  rect(20, 20, anchoSalud, 20, 5);
  fill(255);
  textSize(14);
  textAlign(LEFT, CENTER);
  text("SALUD: " + int(jugador.vida) + " / " + int(jugador.vidaMax), 25, 30);

  // Energía de la Linterna
  fill(50);
  rect(20, 50, 200, 20, 5);
  fill(255, 200, 0);
  float anchoEnergia = map(linterna.energia, 0, linterna.energiaMax, 0, 200);
  rect(20, 50, anchoEnergia, 20, 5);
  fill(255);
  text("LINTERNA: " + nf(linterna.energia, 1, 1) + "s", 25, 60);

  // Oleada actual en pantalla
  fill(255);
  textSize(18);
  textAlign(RIGHT, CENTER);
  text("OLEADA: " + oleadaActual + " / 10", width - 30, 30);

  popStyle();
}

// ==========================================
// CONTROL DE TECLADO
// ==========================================
void keyPressed() {
  if (key == 'w' || key == 'W') movUp = true;
  if (key == 's' || key == 'S') movDown = true;
  if (key == 'a' || key == 'A') movLeft = true;
  if (key == 'd' || key == 'D') movRight = true;

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

// ==========================================
// MENÚS Y BOTONES
// ==========================================
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
  fill(0, 0, 0, 180);
  rect(0, 0, width, height);
  fill(255, 0, 0);
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
      oleadaActual = 1;
      timerRecoleccion = 0;
      timerTransicion = 0;
      iniciarOleada();
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
      reiniciarJuego();
    }
  } 
  else if (estadoDelJuego == 3) {
    if (sobreBoton(width/2 - 100, 300, 200, 50)) {
      estadoDelJuego = 0;
      reiniciarJuego();
    }
  }
  else if (estadoDelJuego == 4 || estadoDelJuego == 5) {
    if (sobreBoton(80, 430, 220, 50)) {
      estadoDelJuego = 0;
    }
  }
}

void reiniciarJuego() {
  jugador = new Jugador(width/2, height/2, spriteJugador);
  linterna = new Linterna();
  oleadaActual = 1;
  timerRecoleccion = 0;
  timerTransicion = 0;
  iniciarOleada();
}

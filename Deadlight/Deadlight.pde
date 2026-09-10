Jugador jugador;
Linterna linterna;

ArrayList<Enemigo> enemigos;
int estadoDelJuego = 0;



void setup() {
  size(900, 600);

  jugador = new Jugador(width/2, height/2);
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

  if (estadoDelJuego == 1) {
    jugar();
  }

  if (estadoDelJuego == 2) {
    mostrarPausa();
  }

  if (estadoDelJuego == 3) {
    mostrarGameOver();
  }
}

void jugar() {

  jugador.actualizar();

  linterna.actualizar(jugador.posicion);

  linterna.mostrar();

  jugador.mostrar();

  for (Enemigo enemigo : enemigos) {
    enemigo.actualizar(linterna);
    enemigo.mostrar();
  }
}

void mostrarMenu() {

  fill(255);
  textAlign(CENTER);

  textSize(50);
  text("DeadLight", width/2, 200);

  textSize(25);
  text("ENTER para Empezar", width/2, 300);
}


void mostrarPausa() {

  fill(255);
  textAlign(CENTER);

  textSize(50);
  text("PAUSA", width/2, 250);

  textSize(25);
  text("P para continuar", width/2, 300);
}



void mostrarGameOver() {

  fill(255);
  textAlign(CENTER);

  textSize(50);
  text("GAME OVER", width/2, 250);

  textSize(25);
  text("Presiona ENTER para volver al menú", width/2, 300);
}

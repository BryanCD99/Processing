
// Clase que calcula el DeltaTime **********************
static class DeltaTime {
  //Almacena la ultima vez que se llamo a esta funcion
  private static long lastTime = 0;
  // Calcula el DeltaTime a partir del tiempo actual y el tiempo anterior 
  public static float getDeltaTime() {
    long currentTime = System.currentTimeMillis();
    float deltaTime = (currentTime - lastTime);
    lastTime = currentTime;
    return deltaTime;
  }
}

float sign(float num) {
  if (num > 0) {
    return 1;
  } else if (num < 0) {
    return -1;
  } else {
    return 1;
  }
}

float Modulo(float X, float Y){
  return sqrt(pow(X, 2) + pow(Y, 2));
}

// Crea un icono triangular para indicar la posicion del jugador en el mapa 2D
class IconPlayer {
  public float w;
  public float h;
  public color c;
  private float x;
  private float y;
  private float angle;
  private PGraphics buffer;
  // Crea el icono con ancho y alto (w,h), un color (c), una posicion (x,y) y un angulo de direccion (angle)
  public IconPlayer(float w, float h, color c, float x, float y, float angle, PGraphics buffer) {
    this.w = w;  // Ancho del icono
    this.h = h;  // Alto del icono
    this.c = c;  // Color del icono
    this.x = x;  // Posicion X del icono
    this.y = y;  // Posicion Y del icono
    this.angle = angle;  // Angulo inicial del icono
    this.buffer = buffer;
  }
  // Dibuja el icono
  public void drawIcon(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.buffer.push();
    this.buffer.translate(this.x, this.y);
    this.buffer.rotate(this.angle);
    this.buffer.fill(this.c);
    this.buffer.noStroke();
    this.buffer.triangle(-this.w/2, this.h/2, this.w/2, this.h/2, 0, -this.h/2);
    this.buffer.pop();
  }
};

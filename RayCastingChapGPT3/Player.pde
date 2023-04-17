class Player {
  public float x, y;  // posición del jugador
  public float angle; // ángulo de dirección del jugador
  public float FOV;   // campo de visión del jugador
  public boolean CameraTurn;  // Habilita o deshabilita el giro de la camara
  
  private Collision PlayerCollision = null;  //Colisionador del jugador
  
  public Player(float x, float y, float angle, float FOV) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.FOV = FOV;
    this.CameraTurn = true;
  }
  
  // Carga el collider a la clase jugador
  public void LoadCollision(Collision PlayerCollision){
    this.PlayerCollision = PlayerCollision;
  }  
  
  // Mueve al jugador en X acorde al sistema de coordenadas del jugador
  public void moveX(float speed) {
    if (PlayerCollision == null) {
      throw new RuntimeException("No se ha agregado una referencia al colider");
    }
    float dx = speed * cos(this.angle);
    if (!PlayerCollision.checkCollision(this.x + dx, this.y)) {
      this.x += dx;
    }
    float dy = speed * sin(this.angle);
    if (!PlayerCollision.checkCollision(this.x, this.y + dy)) {
      this.y += dy;
    }
  }
  
  // Mueve al jugador en Y acorde al sistema de coordenadas del jugador
  public void moveY(float speed) {
    if (PlayerCollision == null) {
      throw new RuntimeException("No se ha agregado una referencia al colider");
    }
    float dx = speed * sin(this.angle);
    if (!PlayerCollision.checkCollision(this.x + dx, this.y)) {
      this.x += dx;
    }
    float dy = -speed * cos(this.angle);
    if (!PlayerCollision.checkCollision(this.x, this.y + dy)) {
      this.y += dy;
    }
  }

  //// Mueve al jugador en la direccion del angulo a una velocidad "speed"
  //public void move(float speed) {
  //  // Si no existe un colisionador referenciado, entonces se lanza la exepcion
  //  if (PlayerCollision == null){
  //    throw new RuntimeException("No se ha agregado una referencia al colider");
  //  }
  //  float dx = speed * sin(this.angle);
  //  float dy = -speed * cos(this.angle);
  //  // Si el movimiento calculado impacta con un muro, entonces no se mueve
  //  if (!PlayerCollision.checkCollision(this.x + dx, this.y)) {
  //    this.x += dx;
  //  }
  //  if (!PlayerCollision.checkCollision(this.x, this.y + dy)) {
  //    this.y += dy;
  //  }
  //}  
  // Rota la camara del jugador en direccion del angulo indicado
  public void rotate(float angle) {
    if(this.CameraTurn){
      this.angle += radians(angle % 360);  // Establece un rango para el angulo ingresado de 0 a 360
      this.angle = this.angle%(2*PI);
    }
  } 
};

class Minimapa {
  private char[][] map;
  private int BlockSize;
  private PGraphics buffer;
  private Player player = null;
  private IconPlayer IconPlayer = null;       // Icono 2D del jugador en el miniMapa
  private float x;
  private float y;  
  public float Scale;
  public boolean Visible;
  public float playerWidth;
  public float playerHeigth;
 
  // Constructor del minimapa *********
  public Minimapa(char[][] map, int BlockSize, PGraphics buffer) {
    this.map = map;
    this.BlockSize = BlockSize;
    this.x = 0;
    this.y = 0;
    this.buffer = buffer;   
    this.Visible = true;
    this.Scale = 1;
    this.playerWidth = this.BlockSize;
    this.playerHeigth = this.BlockSize*1.2;
  }

  // Configura el jugador que se va a mostrar en el minimapa
  public void setPlayer(Player player) {
    this.player = player;
    this.IconPlayer = new IconPlayer(this.playerWidth*this.Scale, this.playerHeigth*this.Scale, color(220,220,0), this.player.x*this.Scale, this.player.y*this.Scale, this.player.angle,this.buffer);  
  }
  // Ubica el mapa en un posion de la pantalla
  public void place(float x, float y) {
    this.x = x;
    this.y = y;
  }
  // Dibuja el mapa en el buffer
  public void drawMap() {
    if(player == null){
      throw new RuntimeException("No se ha ajustado un jugador en el minimapa");
    }
    // Si el mapa no se desea ver, entonces no se dibuja
    if(!this.Visible){
      return;
    }
    // ********* Dibujamos el mapa 2D *************************
    for (int i = 0; i < this.map.length; i++) {
      for (int j = 0; j < this.map[i].length; j++) {
        if (this.map[i][j] == 'X') {
          this.buffer.stroke(color(125,125,125));
          this.buffer.fill(255);
          this.buffer.rectMode(CORNER);
          this.buffer.rect(j * this.BlockSize*this.Scale + this.x, i * this.BlockSize*this.Scale + this.y, this.BlockSize*this.Scale, this.BlockSize*this.Scale);
        }
      }
    }  

    // Dibujamos al jugador en 2D
    this.IconPlayer.w = this.playerWidth*this.Scale;
    this.IconPlayer.h = this.playerHeigth*this.Scale;
    this.IconPlayer.drawIcon(this.player.x*this.Scale + this.x, this.player.y*this.Scale + this.y, this.player.angle);
  }
};

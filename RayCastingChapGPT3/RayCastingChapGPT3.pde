// Crear el back buffer
PGraphics buffer;


final int BlockSize = 15;                            // Tamaño de los bloques del mapa (cada bloque tendria una area de 10x10 unidades
final int GridSize = 20;                            // Tamaño de cada bloque del grid que constituira el mapa
final float playerX = 2*GridSize-GridSize/2;      // Inicia en posicion relativa x = 2 con respecto al mapa
final float playerY = 2*GridSize-GridSize/2;       // Inicia en posicion relativa y = 2 con respecto al mapa
final float playerA = PI;                            // Angulo inicial en radianes del jugador  
final float playerSpeed = (2*GridSize)*1e-3f;       // Velocidad inicial del jugador
final float fov = (PI / 180)*80;                    // FOV del jugador
final int RayResolution = 1050;                       // Cantidad de rayos para el raycasting

// Dimension de la pantalla
final int ScreenWidth = 1050;
final int ScreenHeight = 600;

// Variables de uso general
float deltaTime;

Collision MapCollision;      // Objeto collider para la colision con los muros
Player Player1;              // Jugador 1
RayCasting rayCasting;       // Objeto RayCasting para el calculo de los rayos y distancias que existen desde el jugador hacia el mapa
Render3D RenderMap;          // Objeto de renderizado 3D a partir de los rayos del RayCasting
CreateMap GameMap;           // Crea el mapa
Minimapa Minimapa;           // Crea un minimapa

// Funcion para poner texto xD
void drawText(String text, float x, float y, int textSize, color textColor) {
  buffer.textSize(textSize);
  buffer.fill(textColor);
  buffer.text(text, x, y);
}

void setup() {
  // Configuracion del tamaño de la pantalla
  size(1050, 600);
  
  noCursor();
  // Inicializa los controles
  Controls.initialize(ScreenWidth,ScreenHeight);
  
  // Crea el BackBuffer para pre-renderizar los objetos antes de mostrar en pantalla
  buffer = createGraphics(ScreenWidth, ScreenHeight);
  
  // Crea el mapa *******************
  GameMap = new CreateMap(map,BlockSize,GridSize);
  
  // Crea el colisionador general para el mapa ****************
  MapCollision = new Collision(map,GridSize);
  
  // Crea los jugadores **************
  Player1 = new Player(playerX, playerY, playerA , fov);        // Crea un jugador
  Player1.LoadCollision(MapCollision);                          // Carga el colisionador con el cual va a interactuar el jugador
  
  // Crea el objeto RayCasting  ***********
  rayCasting = new RayCasting(ScreenWidth,ScreenHeight, RayResolution, buffer);  // Inicializa el objeto RayCasting
  rayCasting.LoadMap(GameMap);                            // Carga el mapa en el objeto RayCasting
  rayCasting.addPlayer("Player1",Player1);                      // Añade el jugador 1 al RayCasting
  
  // Cra el objeto de renderizado 3D
  RenderMap = new Render3D(ScreenWidth,ScreenHeight,buffer);
  
  // Crea un minimapa
  Minimapa = new Minimapa(map,GridSize,buffer);
  Minimapa.place(0,0);
  Minimapa.setPlayer(Player1);
  Minimapa.Scale = 1;
}

void draw() {  
  // DeltaTime ***************+
  deltaTime = DeltaTime.getDeltaTime();
  
  // Controles del jugador ******
  keyControl();
  MouseControl();
  
  // Inicia el buffer para dibujar la escena
  buffer.beginDraw();
  
  // Coloca el fondo
  buffer.background(0); 
    
  // Calculamos los rayos del jugador 1
  Ray[] rays = rayCasting.castRays("Player1");
  
  // ********** Dibuja el mapa 3D **********
  RenderMap.render(rays);
  
  // ********** Dibuja un minimapa 2D *******
  Minimapa.drawMap();
    // Dibujamos los rayos
    //for (int i = 0; i < rays.length; i++) {
    //  rays[i].drawRay();
    //}    
  // Coloca el Texto de X,Y y los FPS
  Muro xd = (Muro)GameMap.Grid.getEntity(3,4);
  xd.angle += 0.05;//*deltaTime;
  xd.x = 95;
  xd.y = 75;
  //if (xd.x>70){
  //  xd.x -= 0.05;
  //}else{
  //  xd.x = 90;
  //}
  GameMap.Grid.updateGrid(xd);
  
  drawText("X: " + str(Player1.x/BlockSize),900,50,15,color(255,255,255));
  drawText("Y: " + str(Player1.y/BlockSize),900,70,15,color(255,255,255));
  drawText("FPS: " + str(round(1/(deltaTime*1e-3f))),900,90,15,color(255,255,255));
  
  buffer.endDraw();
  
  // Dibuja en la pantalla la escena del backbuffer
  image(buffer, 0, 0); // Muestra el back buffer en pantalla
}

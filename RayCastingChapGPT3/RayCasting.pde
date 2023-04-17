import java.util.HashMap;

class Ray {
  private float x;        // Posicion X desde donde se lanza el rayo
  private float y;        // Posicion Y desde donde se lanza el rayo
  private float angle;    // Angulo de disparo del rayo
  private float PlayerAngle;  // Angulo de enfoque de la camara
  private float distance;     // Longitud del rayo
  //private int Block_i;        // Posicion i del bloque al que impacto el rayo
  //private int Block_j;        // Posicion j del bloque al que impacto el rayo
  //private float BlockSize;    // Tamaño del bloque
  private PGraphics buffer;   // Buffer de dibujado
  
  public String ImpactDirection;
  
  // Construye un rayo con posicion inicial (x,y) y angulo de disparo angle. Tambien recibe la referencia la backbuffer sobre el cual dibujar
  public Ray(float x, float y, float angle,float PlayerAngle,  PGraphics buffer) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.PlayerAngle = PlayerAngle;
    this.distance = Float.POSITIVE_INFINITY;      // El rayo inicial tiene longitud infinita indicando que no ha chocado con nada
    this.buffer = buffer;
    this.ImpactDirection = "";
  } 
  // Almacena las coordenadas y la dimension del bloque en el que impacto el rayo
  //public void SetImpactBlock(int i, int j, float BlockSize){
  //  this.Block_i = i;
  //  this.Block_j = j;
  //  this.BlockSize = BlockSize;
  //}
  public void SetImpactDirection(String ImpactDirection){
    this.ImpactDirection = ImpactDirection;
  }
  // Calcula la direccion de impacto (Up-Bottom-Left-Right) en el que impacto el rayo en el bloque
  //public String GetImpactDirection() {
  //  // Obtiene las coordenadas del bloque en el cual impacto el rayo
  //  float BlockX = (float)this.Block_i + 0.5;
  //  float BlockY = (float)this.Block_j + 0.5;

    
  //  // Determina el deltaX y deltaY (distancias de impacto relativas a las coordenadas del bloque)
  //  float deltaX = (this.x - cos(this.angle) * this.distance)/this.BlockSize - BlockX; //Xf-Xi
  //  //deltaX += (deltaX >= 0) ? 0.3:-0.3;
  //  float deltaY = (this.y - sin(this.angle) * this.distance)/this.BlockSize - BlockY; //Yf-Yi
  //  //deltaY += (deltaY >= 0) ? 0.3:-0.3;
    
  //  // Determina el lado donde ocurrio el impacto
  //  float CurrentAngle = (deltaX >= 0) ? atan2(deltaX,deltaY) : 2*PI + atan2(deltaX,deltaY);

  //  if(this.distance == Float.POSITIVE_INFINITY){
  //    return "unknown";
  //  }else if ((CurrentAngle >= PI/4)&&(CurrentAngle < 3*PI/4)){
  //    return "R";    //Right
  //  }else if ((CurrentAngle >= 3*PI/4)&&(CurrentAngle < 5*PI/4)){
  //    return "U";    //Up  //<>//
  //  }else if ((CurrentAngle >= 5*PI/4)&&(CurrentAngle < 7*PI/4)){
  //    return "L";    //Left
  //  }else{
  //    return "B";    //Bottom
  //  }
  //}

  // Configura una nueva longitud del rayo
  public void setDistance(float distance) {
    this.distance = distance;
  }
  
  // Devuelve la distancia perpendicular desde el punto de impacto al punto (x,y)
  public float distanceTo() {
    float x = this.x - cos(this.angle) * this.distance;
    float y = this.y - sin(this.angle) * this.distance;    
    return dist(this.x, this.y, x, y) * cos(this.PlayerAngle-this.angle+PI/2);    // Distancia perpendicular hacia el objeto
  }
  
  // Funcion de dibujo del rayo 
  public void drawRay() {
    this.buffer.stroke(color(120,0,0));
    this.buffer.line(this.x, this.y, this.x - cos(this.angle) * this.distance, this.y - sin(this.angle) * this.distance);
  }
};

class RayCasting {

  private PGraphics buffer;  
  private HashMap<String, Object> players;
  //private char[][] map = null;
  private Grid CurrentMap = null;
  private float mapWidth;
  private float mapHeight;
  
  float BlockSize;  
  float GridSize;
  int RayResolution;
  int ScreenHeight;
  int ScreenWidth; 
    
  // Crea un jugador en la posicion (x,y) mirando en direccion del angulo (angle) con un FOV establecido
  public RayCasting(int ScreenWidth,int ScreenHeight, int RayResolution, PGraphics buffer) {
    this.RayResolution = RayResolution;
    this.ScreenHeight = ScreenHeight;
    this.ScreenWidth = ScreenWidth;
    this.buffer = buffer;
    this.BlockSize = 32;  // Tamaño por defecto del bloque
    this.players = new HashMap<String, Object>();
  }
  
  // Añade un jugador sobre el cual se aplicara el raycasting
  public void addPlayer(String key, Object obj){
    this.players.put(key, obj);
  }  
 
  // Carga el mapa donde se movera el jugador
  public void LoadMap(CreateMap CurrentMap){
    //this.map = map;
    //this.mapWidth = this.map[0].length;
    //this.mapHeight = this.map.length;
    //this.BlockSize = BlockSize;
    this.CurrentMap = CurrentMap.Grid;
    this.mapWidth = this.CurrentMap.width;
    this.mapHeight = this.CurrentMap.height;
    this.GridSize = this.CurrentMap.gridsize;
  }
 
  // Calcula los rayos del raycast para la obtencion de las distancias a los objetos de la camara
  public Ray[] castRays(String key) {
    
    // Si la clave no existe o el diccionario esta vacio entonces lanza una execpcion
    if ((!players.containsKey(key))||(players.isEmpty())){
      throw new RuntimeException("Esta clave no se encontro en el diccionario");
    }
    // Obtiene el objeto player al cual se le aplicara el RayCasting
    Player CurrentPlayer = (Player)this.players.get(key);
    
    // Crea un arreglo de objetos para los rayos
    Ray[] rays = new Ray[this.RayResolution];
    float DV = (this.ScreenWidth/2)/tan(CurrentPlayer.FOV / 2);
    float ScreenStep = this.ScreenWidth/this.RayResolution;
    
    // Calcula los rayos del raycast
    for (int i = 0; i < rays.length; i++) {
      // Angulos del raycast de acuerdo al FOV del jugador
      float currentAngle = (CurrentPlayer.angle+PI/2) + atan(((-this.ScreenWidth/2) + ScreenStep*i)/DV);
      float CX = -cos(currentAngle);
      float CY = -sin(currentAngle);
      float distanceToWall = Float.POSITIVE_INFINITY;
      float t = 0;
      // Linea parametrica de direccion del rayo
      float RayX = CurrentPlayer.x;// + t*CX;
      float RayY = CurrentPlayer.y;// + t*CY;
      // Posicion del grid a analizar
      int Current_i =  (int)floor(RayX/ this.GridSize);
      int Current_j =  (int)floor(RayY/ this.GridSize);
      
      // Crea el rayo de acuerdo a la posicion X,Y y el angulo del rayo
      rays[i] = new Ray(CurrentPlayer.x, CurrentPlayer.y, currentAngle, CurrentPlayer.angle, this.buffer);  
      
      // Rayos lanzados hacia los muros
      while ((RayX < this.mapWidth*this.GridSize  &&  RayX > 0) && (RayY < this.mapHeight*this.GridSize  &&  RayY > 0)){  // Envia un rayo a una velocidad t hasta que impacta con un muro
        //int CurrentX = int(floor(RayX/this.GridSize));
        //int CurrentY = int(floor(RayY/this.GridSize));
          
        boolean breakWhile = false;
        // Pregunta se el objeto en cuestion es una instancia del objeto muro
        if (CurrentMap.containsObject(Current_j,Current_i)){
          
          t = (RayX - CurrentPlayer.x)/CX;
          int Current_Object_i = Current_i;
          int Current_Object_j = Current_j;
          boolean isNowCurrentGrid = false;
          while(CurrentMap.containsObject(Current_Object_j,Current_Object_i)){
            if (CurrentMap.getEntity(Current_j,Current_i) instanceof Muro) {
              Muro CurrentMuro = (Muro)CurrentMap.getEntity(Current_j,Current_i);
              if (CurrentMuro.isPointInside(RayX,RayY)){
                distanceToWall = min(distanceToWall,dist(RayX,RayY,CurrentPlayer.x,CurrentPlayer.y));  //sqrt(pow(RayX - CurrentPlayer.x, 2) + pow(RayY - CurrentPlayer.y, 2))
                rays[i].ImpactDirection = CurrentMuro.getClosestSide(RayX,RayY);
                // Obtiene el bloque al cual ha impactado el rayo
                //rays[i].SetImpactBlock(CurrentX,CurrentY,this.BlockSize);
                breakWhile = true;
                break;
              }
            }
            // Sale del ciclo si se ha topado con un bloque
            if (breakWhile){
              break;
            }
            t += this.GridSize/200;
            RayX = CurrentPlayer.x + t*CX;
            RayY = CurrentPlayer.y + t*CY;            

            Current_i =  (int)floor(RayX/ this.GridSize);
            Current_j =  (int)floor(RayY/ this.GridSize);
            // Si el indice sale del mapa, se sale del bucle
            if(Current_i<0||Current_i>(this.mapWidth-1)||Current_j<0||Current_j>(this.mapHeight-1)){
              break;
            }
            // Sirve para esperar a que el rayo ingrese de forma correecta al grid
            if ((Current_i == Current_Object_i)&&(Current_j == Current_Object_j)){
              isNowCurrentGrid = true;
            }else{
              // Si se sale del grid entonces se sale de este bloque
              if(isNowCurrentGrid){
                            //println(Current_i,Current_j);
                break;
              }
            }
          }
        }else{  
          
          // Si el grid actual no contiene ningun objeto, se calcula el proximo grid al cual acceder
          float Next_i = (float)Current_i + sign(CX);
          float Next_j = (float)Current_j + sign(CY);
          float Ray_i = RayX/ this.GridSize;
          float Ray_j = RayY/ this.GridSize;
          // Se calcula Y1 y se da a X el siguiente bloque
          float local_x =  Next_i + ((sign(CX) == -1)?1:0) - Ray_i;        // Movimiento en X    
          float local_y = Next_j + ((sign(CY) == -1)?1:0)- Ray_j;         // Movimiento en Y
          
          float dy = tan(currentAngle)*local_x;  //Movimiento en Y en base a X
          float Y1 = dy + Ray_j;
          float X1 = local_x + Ray_i;
          
          // Se calcula X2 y se da a Y el siguiente bloque
          float dx = local_y/tan(currentAngle);
          float Y2 = local_y + Ray_j;
          float X2 = dx + Ray_i;
          
          if (Modulo(local_x,dy)<= Modulo(dx,local_y)){
            // Resultado para el calculo de Y1
            RayX = X1* this.GridSize;
            RayY = Y1* this.GridSize;
            Current_i = (int)Next_i;
          }else{
            // Resultado para el calculo de X2
            RayX = X2* this.GridSize;
            RayY = Y2* this.GridSize;
            Current_j = (int)Next_j;
          }
        }
        // Si se ha topado con un muro, entonces rompe
        if (breakWhile){
          break;
        }
        
        //else {
        //  // Optimizacion para avanzar de grid en grid cuando el rayo encuentra un grid null
        //  // Check if the ray can move to the next grid
        //  float dx = (float)(CurrentX + ((CurrentX + sign(CX) > 0)?sign(CX):((CurrentX + sign(CX) < this.mapWidth)?sign(CX):0)) )*this.GridSize-RayX;//(RayX + this.GridSize) - RayX;
        //  float dy = (float)(CurrentY + ((CurrentY + sign(CY) > 0)?sign(CY):((CurrentY + sign(CY) < this.mapHeight)?sign(CY):0)))*this.GridSize-RayY;//(RayY + this.GridSize) - RayY;
        //  float xStep = dx / CX;
        //  float yStep = dy / CY;

        //  if (abs(xStep) >= abs(yStep)) {
        //    RayX += xStep * CX;
        //    RayY += xStep * CY;
        //  } else {
        //    RayX += yStep * CX;
        //    RayY += yStep * CY;
        //  }
        //}
        //println(RayX,RayY);
        
        
          //println(RayX,RayY);
        //if (map[CurrentY][CurrentX] == 'X') {
        //  while(map[int(floor(RayY/BlockSize))][int(floor(RayX/this.BlockSize))] == 'X'){
        //    CurrentX = int(floor(RayX/this.BlockSize));
        //    CurrentY = int(floor(RayY/this.BlockSize));
        //    // Regresa el rayo un poco para coincidir correctamenta con el perimetro del bloque
        //    t -= 0.02;  // Velocidad de retroceso del rayo
        //    // Nuevo vector del rayo
        //    RayX = CurrentPlayer.x + t*CX;
        //    RayY = CurrentPlayer.y + t*CY;
        //  }
        //  // Obtiene la distancia desde el jugador al rayo
        //  distanceToWall = min(distanceToWall,sqrt(pow(RayX - CurrentPlayer.x, 2) + pow(RayY - CurrentPlayer.y, 2)));
        //  // Obtiene el bloque al cual ha impactado el rayo
        //  rays[i].SetImpactBlock(CurrentX,CurrentY,this.BlockSize);
        //  break;
        //}
          // Se ajusta la distancia del rayo en el objeto especificado
          //t += 0.05;  // Velocidad de avance del rayo       
      }
      //distanceToWall = min(distanceToWall,sqrt(pow(RayX - CurrentPlayer.x, 2) + pow(RayY - CurrentPlayer.y, 2)));
      rays[i].setDistance(distanceToWall);//distanceToWall
    }  
    return rays;
  }
};

class Render3D {
  int screenWidth, screenHeight;     // Tamaño de la pantalla
  color c;                            // Color para aplicar
  color C1 = color(139, 0, 0);//color(176, 224, 230);    // Color por defecto horizontal
  color C2 = color(0, 100, 0);//color(106, 154, 150);    // Color por defecto vertical
  color C3 = color(176, 224, 230);
  color C4 = color(128, 0, 128);
  private PGraphics buffer;

  public Render3D(int screenWidth, int screenHeight, PGraphics buffer) {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.buffer = buffer;
  }
  
  public color changeBrightness(color col, float brightnessValue) {
    //float currentBrightness = brightness(col);
    //float newBrightness = brightnessValue;
    float newBrightness = constrain(brightnessValue, 0, 255);
    color newColor = color(hue(col), saturation(col), newBrightness);
    return newColor;
  }

  public void render(Ray[] Rays) {
    float[] distances = new float[Rays.length];
    
    for (int i = 0; i < Rays.length; i++) {
      distances[i] = Rays[i].distanceTo();
    }
    int numRects = distances.length;
    float rectMaxHeight = (float) (this.screenHeight / 3);            // height of the farthest rectangle
    int rectWidth = ceil((float)this.screenWidth/numRects);      // Ancho de los rectangulos
    int VirtualscreenWidth = rectWidth*numRects;                 // Algunos anchos de pantalla no dan un resultado exacto para el ancho de los rectangulos para determinada cantidad de rayos
                                                                 // por lo que se recalcula un tamaño exacto para los rectangulos y se calcula un ancho de pantalla virtual sobre el cual dibujar
    int indexStart = -(VirtualscreenWidth-this.screenWidth)/2;   // Con este indice se centra el dibujo de la pantalla con el nuevo ancho de pantalla

    for (float rectX = 0; rectX < VirtualscreenWidth; rectX+=rectWidth) {     
      int i = int(rectX/rectWidth);
      int rectHeight = (int)(rectMaxHeight*30/(distances[i])); //((-rectMaxHeight + 50) / (10 - 0) * (distances[i] - 0) + 50); // update height for next rectangle
      int rectY = int((screenHeight / 2.0f) - (rectHeight/2));  // Posicion Y al medio de la pantalla
      this.buffer.noStroke();
      //this.buffer.stroke(c);
      //println(Rays[i].GetImpactDirection());
      if((Rays[i].ImpactDirection =="L")||(Rays[i].ImpactDirection =="L")){
        this.buffer.fill(color(red(this.C1),green(this.C1),blue(this.C1),255*15/distances[i]));
      }
      if((Rays[i].ImpactDirection =="U")||(Rays[i].ImpactDirection =="U")){
        this.buffer.fill(color(red(this.C2),green(this.C2),blue(this.C2),255*15/distances[i]));
      }
      if((Rays[i].ImpactDirection =="R")||(Rays[i].ImpactDirection =="R")){
        this.buffer.fill(color(red(this.C3),green(this.C3),blue(this.C3),255*15/distances[i]));
      }
      if((Rays[i].ImpactDirection =="B")||(Rays[i].ImpactDirection =="B")){
        this.buffer.fill(color(red(this.C4),green(this.C4),blue(this.C4),255*15/distances[i]));
      }
      //this.buffer.fill(c);
      // Dibuja un rectangulo de acuerdo a la altura calculada por el raycasting
      this.buffer.rectMode(CORNER);
      this.buffer.rect(rectX+indexStart,rectY,rectWidth, rectHeight);
    }
  }
};

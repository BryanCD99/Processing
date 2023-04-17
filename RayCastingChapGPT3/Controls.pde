

//************* Controles del jugador *******************
void keyControl(){
  //***************** Movemos al jugador **********************
  if (Controls.getKey('w')) {
    Player1.moveY(playerSpeed*deltaTime);
  }
  if (Controls.getKey('s')) {
    Player1.moveY(-playerSpeed*deltaTime);
  }
  if (Controls.getKey('d')) {
    Player1.moveX(playerSpeed*deltaTime);
    //Player1.rotate(0.2*deltaTime);
  }
  if (Controls.getKey('a')) {
    Player1.moveX(-playerSpeed*deltaTime);
    //Player1.rotate(-0.2*deltaTime);
  }
  
  //***************** Control del minimapa ******************
  if (Controls.getKeyOnce('m')) {
    Minimapa.Visible = !Minimapa.Visible;
  }
  
  if (Controls.getKeyOnce('p')) {
    Controls.blockMouse = !Controls.blockMouse;
    Player1.CameraTurn = !Player1.CameraTurn;
    if(Controls.blockMouse){
      noCursor();
    }else{
      cursor();
    }
  }
}

//*********** Controles del mouse *************
void MouseControl(){
  
  // Calcula el desplazamiento del mouse con respecto al centro de la pantalla
  Controls.CalculateShiftMouse(mouseX,mouseY);
  
  // Si hay desplazamiento del mouse, entonces se mueve la camara en ese angulo
  if(abs(Controls.DMX)>0){
    float currentAngle = map(1*Controls.DMX, -200, 200, -0.3, 0.3);
    Player1.rotate(currentAngle*deltaTime);
   }
}

import java.awt.Robot;
import java.awt.AWTException;
import java.awt.MouseInfo;
import java.awt.Window;

// Clase estatica para el manejo de entradas del teclado y movimiento de mouse
static class Controls{
  // Array que almacena las teclas presionadas
  private static ArrayList<Character> CodesPresed = new ArrayList<Character>();
  private static ArrayList<Character> CodesRead = new ArrayList<Character>();
  public static int ScreenWidth;
  public static int ScreenHeight;
  public static float DMX,DMY;
  public static boolean blockMouse;    // Bloque el puntero del mouse al centro de la ventana

  public static void initialize(int ScreenWidth,int ScreenHeight) {
    Controls.ScreenWidth = ScreenWidth;
    Controls.ScreenHeight = ScreenHeight;
    Controls.blockMouse = true;
  }
  // Retorna un boolean que indica que una key especificada ha sido presionada
  public static boolean getKey(char key){
    return Controls.CodesPresed.contains(key);
  }
  // Retorna un boolean verdadero una sola vez cuando se llama al metodo y la key ha sido presionada. Retorna falso despues de la primera llamada hasta que la key sea liberada
  public static boolean getKeyOnce(char key){
    if (Controls.CodesPresed.contains(key)){
      if (!Controls.CodesRead.contains(key)){
        Controls.CodesRead.add(key);
        return true;
      }
    }
    return false;
  }
  
  public static void CalculateShiftMouse(int mouseX, int mouseY){
    
    // Coordenadas del centro de la ventana
    int MCX = int(MouseInfo.getPointerInfo().getLocation().x - mouseX + (float)Controls.ScreenWidth/2);
    int MCY = int(MouseInfo.getPointerInfo().getLocation().y - mouseY + (float)Controls.ScreenHeight/2);
    
    // Si se ha detectado movimiento con respecto al centro, entonces se calcula cuanto ha sido
    if((abs(mouseX)>0)||(abs(mouseY)>0)){
      // Bloquea el mouse al centro de la ventana
      if(Controls.blockMouse){
        try {
          Robot r = new Robot();
          r.mouseMove(MCX,MCY);
        } 
        catch (AWTException e) {
          e.printStackTrace();
        }    
      }
      Controls.DMX = mouseX - (float)Controls.ScreenWidth/2;
      Controls.DMY = mouseY - (float)Controls.ScreenHeight/2;    
    }
  }
};

// Si se ha presionado una tecla se guarda su codigo en la memoria
void keyPressed() {
  if (!Controls.CodesPresed.contains(key)){
    Controls.CodesPresed.add(key);
  }
}
// Si se ha soltado una tecla, se elimina su codigo de la memoria
void keyReleased() {
  if (Controls.CodesPresed.contains(key)){
    Controls.CodesPresed.remove(Controls.CodesPresed.indexOf(key));
  }
  if (Controls.CodesRead.contains(key)){
    Controls.CodesRead.remove(Controls.CodesRead.indexOf(key));
  }
}

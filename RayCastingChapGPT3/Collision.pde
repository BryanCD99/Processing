class Collision {
  private char[][] map;
  private int BlockSize;
  private float mapWidth;
  private float mapHeight;
  boolean Enable;
  
  public Collision(char[][] map, int BlockSize) {
    this.map = map;
    this.BlockSize = BlockSize;
    this.mapWidth = this.map[0].length;
    this.mapHeight = this.map.length;
    this.Enable = true;
  }
  
  // Checa las colisiones con el muro o con el tamaño del mapa
  public boolean checkCollision(float x, float y) {
    int i = floor(x / this.BlockSize);
    int j = floor(y / this.BlockSize);
    if (i < 0 || i >= this.mapWidth || j < 0 || j >= this.mapHeight) {
      return true;
    }
    if(!this.Enable){
      return false;
    }
    return map[j][i] == 'X';
  }
};

public enum ColliderType {
    RECTANGLE,
    ELLIPSES
}
public class Collision2 {
    private float x;
    private float y;
    private float w;
    private float h;
    private float angle;
    private boolean allowSliding;



    private ColliderType colliderType;

    public Collision2(float x, float y, float w, float h, float angle, boolean allowSliding, ColliderType colliderType) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.angle = angle;
        this.allowSliding = allowSliding;
        this.colliderType = colliderType;
    }

    public boolean collides(float px, float py) {
        // Rotate point to match the orientation of the collision box
        float cosAngle = cos(-angle);
        float sinAngle = sin(-angle);
        float rx = cosAngle * (px - x) - sinAngle * (py - y) + x;
        float ry = sinAngle * (px - x) + cosAngle * (py - y) + y;

        if (colliderType == ColliderType.RECTANGLE) {
            // Check collision for a rectangle
            float left = x - w / 2;
            float right = x + w / 2;
            float top = y - h / 2;
            float bottom = y + h / 2;

            if (rx >= left && rx <= right && ry >= top && ry <= bottom) {
                // Point is inside the rectangle
                return true;
            } else if (allowSliding) {
                // Check for sliding collision
                if (rx < left) {
                    // Point collided with left side of rectangle
                    return true;
                } else if (rx > right) {
                    // Point collided with right side of rectangle
                    return true;
                } else if (ry < top) {
                    // Point collided with top side of rectangle
                    return true;
                } else if (ry > bottom) {
                    // Point collided with bottom side of rectangle
                    return true;
                }
            }
        } else if (colliderType == ColliderType.ELLIPSES) {
            // Check collision for an ellipse
            float rx2 = (rx - x) / (w / 2);
            float ry2 = (ry - y) / (h / 2);

            if (rx2 * rx2 + ry2 * ry2 <= 1) {
                // Point is inside the ellipse
                return true;
            } else if (allowSliding) {
                // Check for sliding collision
                float angle = atan2(ry2 * (w / h), rx2);
                float dx = cos(angle) * (w / 2);
                float dy = sin(angle) * (h / 2);

                if (dist(rx, ry, x + dx, y + dy) <= 1) {
                    // Point collided with the ellipse
                    return true;
                }
            }
        }

        // Point is not colliding with the collision box
        return false;
    }
};

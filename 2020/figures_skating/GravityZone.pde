class GravityZone {
  float x, y, w, h;
  PVector gravity;
  boolean isHovered;
  
  GravityZone(float x, float y, float w, float h, PVector gravity) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.gravity = gravity;
    
    isHovered = false;
  }
  
  // check if input coordinate contained in rectangle
  boolean checkOverlap(float posX, float posY) {
    if (posX > x && posX < x + w && posY > y && posY < y + h)
      return true;
    
    return false;
  }
  
  void update() {
    isHovered = checkOverlap(mouseX, mouseY);
  }
  
  void display() {
    fill(255, isHovered ? 0 : 30);
    noStroke();
    rect(x, y, w, h);
  }
}

class MouseController {
  float x, y, w, h;
  float zoneSize;
  GravityZone[] zones;
  PVector currGravity;
  
  MouseController(float x, float y, float w, float h, float zoneSize) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.zoneSize = zoneSize;
    
    zones = new GravityZone[4];
    
    currGravity = new PVector(0, 0);
    
    // add zones
    zones[0] = new GravityZone(x, y, zoneSize, h, new PVector(-10, 0));                  // L
    zones[1] = new GravityZone(x, y, w, zoneSize, new PVector(0, -10));                  // T
    zones[2] = new GravityZone(w + x - zoneSize, y, zoneSize, h, new PVector(10, 0));    // R
    zones[3] = new GravityZone(x, h + y - zoneSize, w, zoneSize, new PVector(0, 10));    // B
  }
  
  void update() {
    PVector gravity = new PVector(0, 0);
    for (GravityZone g: zones) {
      g.update();
      
      if (g.isHovered) {
        gravity.add(g.gravity);
      }
    }
    
    // we consider that all PVector instances use the Processing coordinate system
    // so to compensate the disparity, we invert on the Y axis when transferring to Box2D
    if (PVector.sub(currGravity, gravity).mag() != 0) {
      box2d.setGravity(gravity.x, -gravity.y);
    }
    
    currGravity = gravity.copy();
  }
  
  void display() {
    for (GravityZone g : zones) g.display();
  }
}

class Polygon {
  int n;
  float r;
  color strokeColor;
  
  Polygon(int n_, float r_, color strokeColor_) {
    n = n_;
    r = r_;
    strokeColor = strokeColor_;
  }
  
  void display() {
    noFill();
    stroke(strokeColor);
    strokeWeight(2);
    
    beginShape();
    for (int i = 0; i <= n; i++) {
      float theta = (float)i / n;
      PVector pos = new PVector(cos(theta * TWO_PI), sin(theta * TWO_PI));
      pos.mult(r);
      
      vertex(pos.x, pos.y);
    }
    endShape();
  }
}

class Blob {
  int n;
  float r, c;
  PVector[] points;
  PVector drawOffset;
  
  Blob(int n_, float r_, float c_) {
    n = n_;
    r = r_;
    c = c_;
    
    // create points
    points = new PVector[n];
    for (int i = 0; i < n; i++) {
      float theta = (float)i / n;
      PVector p = new PVector(cos(theta * TWO_PI), sin(theta * TWO_PI));
      
      if (random(1) > 0.7) {
        // displacer
        PVector offset = p.copy();
        offset.mult(-1);
        offset.mult(pow(random(1), 2.0) * 0.3);
        
        p.add(offset);
      }
      p.mult(r*c);
      
      // set to points array
      points[i] = p;
    }
    
    // set offset on display
    drawOffset = PVector.random2D().mult(r/5);
  }
  
  void display() {
    noFill();
    stroke(30, 130);
    
    PVector p0, p1, p2, p3;
    
    beginShape();
    for (int i = 0; i < n; i++) {
      // get points
      p0 = points[i].copy();
      p3 = points[(i + 1)%n].copy();
      
      // handles
      PVector p1Offset = p0.copy().rotate(HALF_PI).div(n * 0.5);
      p1 = PVector.add(p0, p1Offset);
      PVector p2Offset = p3.copy().rotate(-HALF_PI).div(n * 0.5);
      p2 = PVector.add(p3, p2Offset);
      
      // set vertices
      if (i == 0) vertex(p0.x, p0.y);
      bezierVertex(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }
    endShape();
  }
}

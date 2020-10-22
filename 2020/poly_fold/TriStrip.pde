class TriStrip {
  int n;
  float r;
  int kind;
  color fillColor, strokeColor;
  
  ArrayList<PVector> points;
  
  TriStrip(int n_, float r_, int kind_, color fillColor_, color strokeColor_) {
    n = n_;
    r = r_;
    kind = kind_;
    fillColor = fillColor_;
    strokeColor = strokeColor_;
    
    createPoints();
  }
  
  void createPoints() {
    points = new ArrayList<PVector>();
    
    for (int i = 0; i < n; i++) {
      // polar to cartesian
      float theta = (float)i / n;
      PVector pos = new PVector(cos(theta * TWO_PI), sin(theta * TWO_PI));
      pos.mult(r);
      
      float rand = random(1);
      if (rand > 0.5) {
        // get a random polygon index
        float nextTheta = (float)int(random(n)) / n;
        // prevent self-connecting
        if (nextTheta == theta) return;
        
        // calculate destination point
        PVector nextPos = new PVector(cos(nextTheta * TWO_PI), sin(nextTheta * TWO_PI));
        nextPos.mult(r);
        
        // add points to array
        points.add(pos);
        points.add(nextPos);
      }
    }
  }
  
  void display() {
    strokeWeight(1);
  
    if (alpha(fillColor) == 0) noFill();
    else fill(fillColor);
    
    if (alpha(strokeColor) == 0) noStroke();
    else stroke(strokeColor);
    
    beginShape(kind);
    for (int i = 0; i < points.size(); i++) {
      vertex(points.get(i).x, points.get(i).y);
    }
    endShape();
  }
}

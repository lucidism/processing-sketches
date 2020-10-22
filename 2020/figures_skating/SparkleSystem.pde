class SparkleSystem {
  ArrayList<Sparkle> sparkles;
  
  SparkleSystem() {
    sparkles = new ArrayList<Sparkle>();
  }
  
  void addSparkle(Vec2 pos) {
    Vec2 rand = new Vec2(random(-1, 1), random(-1, 1));
    rand.mulLocal(4);
    Vec2 out = pos.add(rand);
    
    Sparkle s = new Sparkle(out.x, out.y, new PVector(random(-0.8, 0.8), random(-0.3, -0.6)));
    sparkles.add(s);
  }
  
  void update(Vec2 pos) {
    if (mousePressed && frameCount % 2 == 0) {
      addSparkle(pos);
    }
    
    Iterator<Sparkle> it = sparkles.iterator();
    while (it.hasNext()) {
      Sparkle s = it.next();
      
      // "gravity"
      PVector gravity = new PVector(0, 0.05);
      s.applyForce(gravity);
      
      s.update();
      if (s.isDead()) {
        it.remove();
      }
    }
  }
  
  void display() {
    for (Sparkle s: sparkles) {
      s.display();
    }
  }
}

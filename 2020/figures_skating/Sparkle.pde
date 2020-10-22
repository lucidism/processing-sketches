class Sparkle {
  PVector pos, vel, accel;
  PVector initialImpulse;

  int life;        // in frames
  float lifeSpan;  // in seconds

  float alpha;

  Sparkle(float x, float y, PVector initialImpulse) {
    pos = new PVector(x, y);
    vel = initialImpulse.copy();
    accel = new PVector(0, 0);

    life = 0;
    lifeSpan = random(0.6, 1);
  }

  void applyForce(PVector force) {
    accel.add(force);
  }

  void update() {
    vel.add(accel);
    pos.add(vel);
    accel.mult(0);

    life++;
    alpha = pow(map(life, 0, lifeSpan * 60, 0.9, 0), 2.0) * 255;
  }

  void display() {
    noStroke();
    fill(255, alpha);
    ellipse(pos.x, pos.y, 3, 3);
  }

  boolean isDead() {
    return life > lifeSpan * 60;
  }
}

// manages drawing in a separate PGraphics

class Sketcher {
  // pg1 = contains sketch
  // pg2 = parses pg1 through shader
  PGraphics pg1, pg2;
  PShader s;

  Sketcher() {
    pg1 = createGraphics(width - 20, height - 20, P2D);
    pg2 = createGraphics(width - 20, height - 20, P2D);

    s = loadShader("Sketcher.glsl");
  }

  // fired on right mouse click
  void setBackLayer() {
    // write sketch layer to temp
    // with add. alpha and blur operations
    PGraphics temp = createGraphics(width - 20, height - 20, P2D);
    temp.beginDraw();
    temp.tint(255, 130);
    temp.image(pg1, 0, 0);
    temp.filter(BLUR, 3);
    temp.endDraw();

    // re-apply to sketch layer
    pg1.beginDraw();
    pg1.clear();
    pg1.image(temp, 0, 0);
    pg1.endDraw();
  }

  // fired on left mouse click
  void drawLine(float x1, float y1, float x2, float y2, float alpha) {
    pg1.beginDraw();
    pg1.noFill();
    pg1.strokeWeight(map(sin(frameCount * TWO_PI / 60.0), -1, 1, 0.5, 3));
    pg1.stroke(255, 100); // TODO: change to custom color w/ func. argument
    pg1.line(x1 - 10, y1 - 10, x2 - 10, y2 - 10);
    pg1.endDraw();
  }

  // fired on collision
  void drawShape(Quill q, float radius) {
    Vec2 pos = q.pos.sub(new Vec2(10, 10));

    pg1.beginDraw();
    pg1.noFill();
    pg1.strokeWeight(1);
    pg1.stroke(255);

    pg1.pushMatrix();
    pg1.translate(pos.x, pos.y);
    pg1.rotate(-q.angle);

    switch (q.type) {
      case QuillType.CIRCLE:
        pg1.ellipse(0, 0, radius*2, radius*2);
        break;
      case QuillType.SQUARE:
        pg1.rect(-radius, -radius, radius*2, radius*2);
        break;
      case QuillType.TRIANGLE:
        pg1.triangle(-radius, -radius, 0, radius, radius, -radius);
        break;
    }

    pg1.popMatrix();
    pg1.endDraw();
  }

  void display() {
    // apply shader on sketch layer
    pg2.beginDraw();
    pg2.shader(s);
    pg2.clear();
    pg2.image(pg1, 0, 0);
    pg2.endDraw();
    // draw shadered layer
    image(pg2, 10, 10);
  }
}

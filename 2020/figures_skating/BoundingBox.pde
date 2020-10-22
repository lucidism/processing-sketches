// creates a 4-sided static box

class BoundingBox {
  Body body;
  MouseController mc;
  ArrayList<Vec2> sides;
  float x, y, w, h;
  PShader shader;
  PGraphics bgLayer;

  BoundingBox(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    // load shader
    bgLayer = createGraphics(width, height, P2D);
    shader = loadShader("BgFrag.glsl");
    shader.set("resolution", width, height);

    ChainShape boundary = new ChainShape();

    // Processing coords...
    sides = new ArrayList<Vec2>();
    sides.add(new Vec2(x, y));
    sides.add(new Vec2(x + w, y));
    sides.add(new Vec2(x + w, y + h));
    sides.add(new Vec2(x, y + h));
    sides.add(new Vec2(x, y));

    // ...to Box2D world coords
    Vec2[] vertices = new Vec2[sides.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(sides.get(i));
    }
    boundary.createChain(vertices, vertices.length);

    // create body w/ chain vertex data
    BodyDef bd = new BodyDef();
    body = box2d.createBody(bd);
    body.createFixture(boundary, 1);
    
    body.setUserData(this);
  }
  
  PImage getBgGraphics() {
    return bgLayer;
  }

  void display() {
    shader.set("time", frameCount / 60.0);
    
    bgLayer.beginDraw();
    bgLayer.shader(shader);
    bgLayer.fill(0);
    bgLayer.rect(0,0,width,height);
    bgLayer.endDraw();
    image(bgLayer, 0, 0);
  }
}

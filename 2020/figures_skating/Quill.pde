// dynamic quill object

class QuillType {
  public static final int CIRCLE = 0,
                          SQUARE = 1,
                          TRIANGLE = 2;
}

class Quill {
  float mass, angle;
  int type;
  Body body;
  Vec2 pos, prevPos;

  SparkleSystem sparkler;

  Quill(float x, float y, float mass) {
    this.mass = mass;
    this.type = floor(random(3));

    // create body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    Vec2 center = box2d.coordPixelsToWorld(x, y);
    bd.position.set(center);
    bd.bullet = true;
    body = box2d.createBody(bd);

    // create fixture
    FixtureDef fd = new FixtureDef();

    switch (type) {
      case QuillType.CIRCLE:
        CircleShape cs = new CircleShape();
        cs.m_radius = box2d.scalarPixelsToWorld(mass);
        fd.shape = cs;
        break;
      case QuillType.SQUARE:
        PolygonShape ss = new PolygonShape();
         ss.setAsBox(box2d.scalarPixelsToWorld(mass), box2d.scalarPixelsToWorld(mass));
        fd.shape = ss;
        break;
      case QuillType.TRIANGLE:
        PolygonShape ts = new PolygonShape();
        Vec2[] vertices = getTriangleVertices(mass*2, mass*2);
        ts.set(vertices, vertices.length);
        fd.shape = ts;
        break;
    }

    fd.density = mass / 5;
    fd.friction = 1;
    fd.restitution = 0.5;
    body.createFixture(fd);

    body.setUserData(this);

    // create sparkler
    sparkler = new SparkleSystem();
  }

  // generate triangle vertices for PolygonShape
  Vec2[] getTriangleVertices(float tWidth, float tHeight) {
    Vec2[] vertices = new Vec2[3];

    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-tWidth/2, -tHeight/2));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(0, tHeight/2));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(tWidth/2, -tHeight/2));

    return vertices;
  }

  void display() {
    // get position and angle values
    pos = box2d.getBodyPixelCoord(body);
    angle = body.getAngle();

    // draw to screen
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-angle);

    noFill();
    if (mousePressed && mouseButton == LEFT) fill(255, 100);

    stroke(255);
    strokeWeight(1);

    // draw shape
    switch (type) {
      case QuillType.CIRCLE:
        ellipse(0, 0, mass*2, mass*2);
        break;
      case QuillType.SQUARE:
        rect(-mass, -mass, mass*2, mass*2);
        break;
      case QuillType.TRIANGLE:
        triangle(-mass, -mass, 0, mass, mass, -mass);
        break;
    }

    popMatrix();

    // draw line to sketcher if mouse is pressed
    if (mousePressed && mouseButton == LEFT) {
      sketcher.drawLine(prevPos.x, prevPos.y, pos.x, pos.y, 255);
    }

    // draw sparkler
    sparkler.update(pos);
    sparkler.display();

    // copy previous state once everything is done
    prevPos = new Vec2(pos);
  }
}

// manage collisions
void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Quill.class && o2.getClass() == Quill.class) {
    Quill q1 = (Quill)o1;
    Quill q2 = (Quill)o2;

    sketcher.drawShape(q1, q1.mass);
    sketcher.drawShape(q2, q2.mass / 5.0);
  }
}
void endContact(Contact cp) {}

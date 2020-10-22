// -- Figures Skating --
// Left Click: draw on background
// Right Click: set back current background
// Enter Key: save to file

// applied gravity changes depending on which translucent white box is hovered
// no hovered box = no gravity
// hovering over corners will apply both overlapping gravity values


import java.util.Iterator;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// Box2D
Box2DProcessing box2d;

// properties
int numQuills;
int saveCounter;
boolean frameSave;

// objects
BoundingBox container;
MouseController mouseController;
Sketcher sketcher;
Quill[] quills;


void setup() {
  size(720, 480, P2D);
  pixelDensity(2);

  // initialize Box2D world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -1);
  box2d.listenForCollisions();

  // initialize props
  numQuills = floor(random(6, 10));
  saveCounter = 0;
  frameSave = false;

  // initialize objects
  sketcher = new Sketcher();
  container = new BoundingBox(10, 10, width - 20, height - 20);
  mouseController = new MouseController(10, 10, width - 20, height - 20, 30);

  quills = new Quill[numQuills];
  for (int i = 0; i < quills.length; i++) {
    float theta = TWO_PI * i / quills.length;
    quills[i] = new Quill((width / 2) + cos(theta) * 100, (height / 2) + sin(theta) * 100, random(4, 16));
  }
}


void draw() {
  background(0);

  box2d.step();

  // display + update objects
  container.display();
  sketcher.display();
  mouseController.update();
  
  // objects that are hidden on frame export
  if (!frameSave) {
    mouseController.display();
    for (int i = 0; i < quills.length; i++) {
      quills[i].display();
    }
  }
  
  // save to file
  if (frameSave) {
    save("exports/screen-" + String.format("%04d", saveCounter) + ".png");
    saveCounter++;
    frameSave = false;
  }
}


// blur+alpha effect on sketcher
void mousePressed() {
  if (mouseButton != RIGHT) return;
  sketcher.setBackLayer();
}


// toggle save flag
void keyPressed() {
  if (keyCode != ENTER) return;
  frameSave = true;
}

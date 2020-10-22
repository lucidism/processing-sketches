import processing.pdf.*;

// objects and variables
int n;
float r;

TriStrip bgStrip1, bgStrip2;
Blob[] b;
PVector bOffset;
Polygon p;
TriStrip precore, polycords, core;
color bgColor;

boolean isRecording;


void setup() {
  size(800, 800);
  //frameRate(10);
  
  isRecording = false;
  
  generatePrimitives();
}


void generatePrimitives() {
  // set basic variables
  bgColor = color(random(240, 255), random(240, 255), random(240, 255));
  n = int(random(5, 10));
  r = random(200, 250);
  bOffset = PVector.random2D().mult(r/20);
  
  // 0. bg triangulations
  bgStrip1 = new TriStrip(min(n, 7), r * 3, TRIANGLE_STRIP, color(60, 5), color(0, 0));
  bgStrip2 = new TriStrip(min(n*2, 12), r * 1.5, TRIANGLE_STRIP, color(30, 7), color(0, 0));
  
  // 1. computed bezier blob
  int numBlobs = floor(random(5, 25));
  b = new Blob[numBlobs];
  for (int i = 0; i < numBlobs; i++) {
    float fb = random(0.85, 1);
    
    b[i] = new Blob(n, r * 1.1 * map(i, 0, numBlobs, 1, fb), random(0.97, 1)*1.1);
  }
  
  // 2. polygon
  p = new Polygon(n, r * 0.8, color(30));
  
  // 3. pre-core tristrip halo
  precore = new TriStrip(n * 3, r / 2.0, TRIANGLE_STRIP, color(255, 80), color(0, 0));
  polycords = new TriStrip(n, r * 0.8, LINES, color(0, 0), color(30));
  core = new TriStrip(n * 3, r / 3.0, TRIANGLE_STRIP, color(bgColor, 150), color(30, 20));
}


void draw() {
  if (isRecording) beginRecord(PDF, "frame.pdf");
  
  background(bgColor);
  
  // move to center
  pushMatrix();
  translate(width/2, height/2);
  
  // draw objects
  bgStrip1.display();
  bgStrip2.display();
  
  pushMatrix();
  translate(bOffset.x, bOffset.y);
  for (int i = 0; i < b.length; i++) {
    b[i].display();
  }
  popMatrix();
  
  p.display();
  precore.display();
  polycords.display();
  core.display();
  
  // reset matrix
  popMatrix();
  
  if (isRecording) {
    endRecord();
    isRecording = false;
  }
}

// redraw on left mouse click
void mousePressed() {
  if (mouseButton != LEFT) return;
  generatePrimitives();
}

// save to PDF on S keypress
void keyPressed() {
  if (key == 's') {
    isRecording = true;
  }
}

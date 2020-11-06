float r;
int iter;

PGraphics stamp;
PShader s;

//color[] colors = { #2772B0, #475b6b, #50D4C9, #D69081, #A12823 };
//color[] colors = { #CCC90E, #6B6A37, #FFDB59, #88ABEB, #0481CC };
//color[] colors = { #EBE6B0, #2BB383, #FFF15E, #4C1AD6, #D6583A };
//color[] colors = { #6FA696, #DC54F0, #3BF0BE, #F0BA24, #A38121 };
color[] colors = { #15998B, #71BF69, #FFEF45, #E69429, #FF4638 };
//color[] colors = { #53396B, #9AF0B7, #263B4C, #54542E, #756245 };

void setup() {
  size(800, 800);
  smooth(8);

  stamp = createGraphics(width, height);

  noLoop();
}

void draw() {
  background(colors[floor(random(colors.length))]);

  noStroke();
  
  r = floor(random(6, 9));;
  iter = floor(random(2, 5));

  for (int k = 0; k < iter; k++) {
    // filter per iteration
    filter(BLUR, map(k, 0, iter, 5, 2));

    float p = r * pow(2, k);

    boolean reverseX = random(1) < 0.5;
    boolean reverseY = random(1) < 0.5;

    for (int i = 0; i < p; i++) {
      for (int j = 0; j < p; j++) {
        int mi = reverseX ? floor(p) - i - 1 : i;
        int mj = reverseY ? floor(p) - j - 1 : j;

        float globalScale = (floor(random(4))) * (random(1) > 0.8 ? 1 : 0) + 1;
        float probability = (float)k / iter;
        fractal(mi, mj, width * globalScale / p, height * globalScale / p, p, probability);

        if (random(1) > map(iter, 2, 4, 0.85, 0.97))
          diagLine(mi, mj, p);
      }
    }
  }
}

void fractal(float i, float j, float w, float h, float r, float probability) {
  if (random(1) < map(probability, 0, 1, 0.6, 0.9)) return;

  //noStroke();
  tint(255, map(pow(probability, 1.5), 0, 1, 150, 500));

  //pushMatrix();
  //translate(i*width/r, j*height/r);
  float xoff = i*width/r;
  float yoff = j*height/r;

  //if (random(1) < 0.15) stroke(255);
  //else noStroke();

  if (random(1) > 0.3) {
    // shading
    float theta = random(1) < 0.2 ? radians(-45) : 0;
    if (theta < 0) {
      stampRect(xoff, yoff, -h*0.03, h*0.03, w, h, theta, color(0, 70));
    } else {
      stampRect(xoff, yoff, 0, h*0.04, w, h, theta, color(0, 70));
    }

    // shape
    stampRect(xoff, yoff, 0, 0, w, h, theta, colors[floor(random(colors.length))]);

  } else {
    float ellipseScale = random(0.8, 1.2) * (random(1) > 0.8 ? 0 : 1);
    float ellipseR = w*ellipseScale;

    xoff += w/2;
    yoff += h/2;
    float theta = floor(random(8)) * QUARTER_PI;
    float arcTheta = floor(random(4)) * HALF_PI + HALF_PI;

    // shading
    stampEllipse(xoff, yoff, 0, h*0.04, ellipseR, theta, arcTheta, color(0, 50));
    stampEllipse(xoff, yoff, 0, -h*0.02, ellipseR, theta, arcTheta, color(255, 120));
    // shape
    stampEllipse(xoff, yoff, 0, 0, ellipseR, theta, arcTheta, colors[floor(random(colors.length))]);
  }
  
  // blur per shape
  if (random(1) < map(probability, 0, 1, 0.2, 0.05) && min(w, h) > 30)
    filter(BLUR, map(pow(random(1), 2.0), 0, 1, 0.2, 1.2) * (random(1) < 0.001 ? 5 : 1));

  if (random(1) < 0.45) {
    int d = floor(random(2, 4));
    for (int a = 0; a < d; a++) {
      for (int b = 0; b < d; b++) {
        if (random(1) < map(probability, 0, 1, 0.3, 0.5))
          fractal(i+(a/d), j+(b*d), w/d, h/d, r, probability);
      }
    }
  }
}

void diagLine(float i, float j, float r) {
  float scale = pow(random(0.05, 2.5), 2.0);
  float aOff = random(-r/2, r/2);

  PVector a = new PVector(i*width/r + aOff, j*height/r + aOff);
  PVector offset = new PVector(r, r);
  offset.mult(scale);

  if (random(1) < 0.2) offset.y *= -1;
  else if (random(1) < 0.3) offset.x *= 0;
  else if (random(1) < 0.4) offset.y *= 0;

  PVector b;
  if (random(1) < 0.7)
    b = PVector.add(a, offset);
  else
    b = PVector.sub(a, offset);

  stroke(255, map(pow(random(1), 2.0), 0, 1, 60, 255));
  strokeWeight(random(1) < 0.35 ? 2 : 1);
  noFill();
  line(a.x, a.y, b.x, b.y);

  if (random(1) < 0.6) {
    float spread = 0.35;
    diagLine(i + random(-spread, spread), j + random(-spread, spread), r);
  }
}

void stampRect(float xoff, float yoff, float x, float y, float w, float h, float theta, color c) {
  stamp.beginDraw();
  stamp.clear();
  stamp.fill(c);
  stamp.noStroke();
  stamp.translate(xoff, yoff);
  stamp.rotate(theta);
  stamp.rect(x, y, w, h);
  stamp.endDraw();

  image(stamp, 0, 0);
}

void stampEllipse(float xoff, float yoff, float x, float y, float r, float theta, float arcTheta, color c) {
  stamp.beginDraw();
  stamp.clear();
  stamp.translate(xoff, yoff);
  stamp.rotate(theta);
  stamp.noStroke();
  stamp.fill(c);
  stamp.arc(x, y, r, r, 0, arcTheta, PIE);
  stamp.endDraw();

  image(stamp, 0, 0);
}

void keyPressed() {
  if (keyCode != ENTER) return;

  save("output.png");
}

void mousePressed() {
  redraw();
}

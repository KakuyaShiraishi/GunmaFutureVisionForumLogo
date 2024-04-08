PShape gunma;
PGraphics maskCanvas;
PGraphics canvas;

int numSprings = 70;

Spring[] blueW1 = new Spring[numSprings];
Spring[] blueW2 = new Spring[numSprings];
Spring[] blueH1 = new Spring[numSprings];
Spring[] blueH2 = new Spring[numSprings];

Spring[] yellowW1 = new Spring[numSprings];
Spring[] yellowW2 = new Spring[numSprings];
Spring[] yellowH1 = new Spring[numSprings];
Spring[] yellowH2 = new Spring[numSprings];

int limit = 500;
int range = 400;

int speed = 300;
int speedRange = 150;

void setup() {
  size(500, 500);
  background(255);

  initializeSprings();
  initializeGraphics();

  smooth();
  strokeWeight(0.5);

  gunma = loadShape("gunma.svg");
  maskCanvas = createGraphics(limit, limit);
  maskCanvas.beginDraw();
  maskCanvas.shape(gunma, (width - gunma.width)/2, (height - gunma.height)/2);
  maskCanvas.endDraw();

  canvas = createGraphics(limit, limit);
}

void draw() {
  background(255);
  updateSprings();
  drawCanvas();
  
  fill(0);
  text("Press the space key.", 10, 20);
}

void keyPressed() {
  if (key == ' ') {
    resetSprings();
  }
}

void initializeSprings() {
  for (int i = 0; i < numSprings; i++) {
    initializeSpring(blueW1, speed, speedRange, limit, range);
    initializeSpring(blueW2, speed, speedRange, limit, range);
    initializeSpring(blueH1, speed, speedRange, limit, range);
    initializeSpring(blueH2, speed, speedRange, limit, range);

    initializeSpring(yellowW1, speed, speedRange, limit, range);
    initializeSpring(yellowW2, speed, speedRange, limit, range);
    initializeSpring(yellowH1, speed, speedRange, limit, range);
    initializeSpring(yellowH2, speed, speedRange, limit, range);
  }
}

void initializeSpring(Spring[] springs, int speed, int speedRange, int limit, int range) {
  for (int i = 0; i < numSprings; i++) {
    springs[i] = new Spring(speed + random(-speedRange, speedRange));
    float rand1 = random(limit);
    springs[i].target = rand1;
    springs[i].pos = rand1;
  }
}

void initializeGraphics() {
  canvas = createGraphics(limit, limit);
}

void updateSprings() {
  for (int i = 0; i < numSprings; i++) {
    updateSpring(blueW1[i]);
    updateSpring(blueW2[i]);
    updateSpring(blueH1[i]);
    updateSpring(blueH2[i]);

    updateSpring(yellowW1[i]);
    updateSpring(yellowW2[i]);
    updateSpring(yellowH1[i]);
    updateSpring(yellowH2[i]);
  }
}

void updateSpring(Spring spring) {
  spring.update();
}

void drawCanvas() {
  canvas.beginDraw();
  canvas.background(255);
  canvas.smooth();
  canvas.strokeWeight(0.7);
  
  canvas.stroke(255, 241, 1, 255);
  drawLines(yellowW1, yellowW2, yellowH1, yellowH2, canvas);

  canvas.stroke(0, 174, 239, 255);
  drawLines(blueW1, blueW2, blueH1, blueH2, canvas);
  
  canvas.endDraw();
  canvas.mask(maskCanvas);
  image(canvas, 0, 0);
}

void drawLines(Spring[] w1, Spring[] w2, Spring[] h1, Spring[] h2, PGraphics canvas) {
  for (int i = 0; i < numSprings; i++) {
    canvas.line(0, w1[i].pos, limit, w2[i].pos);
    canvas.line(h1[i].pos, 0, h2[i].pos, limit);
  }
}

void resetSprings() {
  resetSpringSet(blueW1, blueW2, blueH1, blueH2);
  resetSpringSet(yellowW1, yellowW2, yellowH1, yellowH2);
}

void resetSpringSet(Spring[] w1, Spring[] w2, Spring[] h1, Spring[] h2) {
  for (int i = 0; i < numSprings; i++) {
    float rand1 = random(limit);
    w1[i].target = rand1;
    float rand1_range = random(rand1 - range, rand1 + range);
    w2[i].target = rand1_range;
    float rand2 = random(limit);
    h1[i].target = rand2;
    float rand2_range = random(rand2 - range, rand2 + range);
    h2[i].target = rand2_range;
  }
}

void resetToExtremes() {
  for (int i = 0; i < numSprings; i++) {
    resetSpringSetToExtremes(blueW1, blueW2, blueH1, blueH2);
    resetSpringSetToExtremes(yellowW1, yellowW2, yellowH1, yellowH2);
  }
}

void resetSpringSetToExtremes(Spring[] w1, Spring[] w2, Spring[] h1, Spring[] h2) {
  for (int i = 0; i < numSprings; i++) {
    w1[i].target = 0;
    w2[i].target = 0;
    h1[i].target = 0;
    h2[i].target = 0;
  }
  for (int i = 0; i < numSprings; i++) {
    w1[i].target = limit;
    w2[i].target = limit;
    h1[i].target = limit;
    h2[i].target = limit;
  }
}

class Spring {
  float pos;
  float vel;
  float target;
  float k;
  float deltaTime = 1.0f / 300;
  
  Spring(float _k) {
    k = _k;
  }
  
  void update() {
    float force = -k * (pos - target);
    float damping = -2.0 * vel * sqrt(k);
    vel += (force + damping) * deltaTime;
    pos += vel * deltaTime;
  }
}

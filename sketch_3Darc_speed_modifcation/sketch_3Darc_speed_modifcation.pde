final int TOTAL_ARCS = 200;

float[] arcFeats;
int[] arcStyles;

void setup() {
  size(1024, 768, P3D);
  background(0);

  arcFeats = new float[6 * TOTAL_ARCS]; // rotx, roty, deg, rad, w, speed
  arcStyles = new int[2 * TOTAL_ARCS]; // color, render style

  int index = 0;
  for (int i = 0; i < TOTAL_ARCS; i++) {
    arcFeats[index++] = random(TAU); // Random X axis rotation
    arcFeats[index++] = random(TAU); // Random Y axis rotation

    arcFeats[index++] = random(45, 90); // Short to half-circle arcs
    if (random(100) > 85) {
      arcFeats[index] = floor(random(10, 30)) * 10;
    }

    arcFeats[index++] = int(random(5, 60) * 5); // Radius

    arcFeats[index++] = random(5, 40); // Width of band
    if (random(100) > 85) {
      arcFeats[index] = random(50, 70); // Wider bands
    }

    arcFeats[index++] = radians(random(10, 35)) / 5; // Speed of rotation

    float prob = random(100);
    if (prob < 50) {
      arcStyles[i * 2] = blendColors(random(1), 255, 69, 0, 255, 140, 0, 210); // Red to Dark Orange
    } else if (prob < 90) {
      arcStyles[i * 2] = blendColors(random(1), 255, 140, 0, 255, 165, 0, 210); // Dark Orange to Orange
    } else {
      arcStyles[i * 2] = color(255, 99, 71, 220); // Tomato
    }

    arcStyles[i * 2 + 1] = floor(random(100)) % 3;

  }
}

void draw() {
  background(0);

  translate(width / 2, height / 2, 0);
  rotateX(PI / 2);
  rotateY(PI / 6);

  int index = 0;
  float speedMultiplier = abs(sin(millis() * 0.001));
  for (int i = 0; i < TOTAL_ARCS; i++) {
    pushMatrix();
    rotateX(arcFeats[index++]);
    rotateY(arcFeats[index++]);

    if (arcStyles[i * 2 + 1] == 0) {
      stroke(arcStyles[i * 2]);
      noFill();
      strokeWeight(1);
      drawArcWave(0, 0, arcFeats[index++], arcFeats[index++], arcFeats[index++]);

    } else if (arcStyles[i * 2 + 1] == 1) {
      fill(arcStyles[i * 2]);
      noStroke();
      drawArcWaveBars(0, 0, arcFeats[index++], arcFeats[index++], arcFeats[index++]);

    } else {
      fill(arcStyles[i * 2]);
      noStroke();
      drawSolidWaveArc(0, 0, arcFeats[index++], arcFeats[index++], arcFeats[index++]);
    }

    arcFeats[index - 5] += arcFeats[index] / 10 * speedMultiplier;
    arcFeats[index - 4] += arcFeats[index++] / 20 * speedMultiplier;

    popMatrix();
  }
}

int blendColors(float fraction, float r1, float g1, float b1, float r2, float g2, float b2, float alpha) {
  return color(r1 + (r2 - r1) * fraction,
               g1 + (g2 - g1) * fraction,
               b1 + (b2 - b1) * fraction, alpha);
}

void drawArcWave(float x, float y, float degrees, float radius, float w) {
  int lineCount = floor(w / 2);
  float waveFrequency = 2;
  float waveAmplitude = 10;
  for (int j = 0; j < lineCount; j++) {
    beginShape();
    for (int i = 0; i < degrees; i++) {
      float angle = radians(i);
      float wave = sin(angle * waveFrequency) * waveAmplitude;
      vertex(x + cos(angle) * (radius + wave), y + sin(angle) * (radius + wave));
    }
    endShape();
    radius += 2;
  }
}

void drawArcWaveBars(float x, float y, float degrees, float radius, float w) {
  float waveFrequency = 2;
  float waveAmplitude = 10;
  beginShape(QUADS);
  for (int i = 0; i < degrees / 4; i += 4) {
    float angle = radians(i);
    float wave = sin(angle * waveFrequency) * waveAmplitude;
    vertex(x + cos(angle) * (radius + wave), y + sin(angle) * (radius + wave));
    vertex(x + cos(angle) * (radius + w + wave), y + sin(angle) * (radius + w + wave));
    angle = radians(i + 2);
    wave = sin(angle * waveFrequency) * waveAmplitude;
    vertex(x + cos(angle) * (radius + w + wave), y + sin(angle) * (radius + w + wave));
    vertex(x + cos(angle) * (radius + wave), y + sin(angle) * (radius + wave));
  }
  endShape();
}

void drawSolidWaveArc(float x, float y, float degrees, float radius, float w) {
  float waveFrequency = 2;
  float waveAmplitude = 10;
  beginShape(QUAD_STRIP);
  for (int i = 0; i < degrees; i++) {
    float angle = radians(i);
    float wave = sin(angle * waveFrequency) * waveAmplitude;
    vertex(x + cos(angle) * (radius + wave), y + sin(angle) * (radius + wave));
    vertex(x + cos(angle) * (radius + w + wave), y + sin(angle) * (radius + w + wave));
  }
  endShape();
}

/**
 * Processing_fadecandy_testcard.pde
 */

OPC opc;
final String fcServerHost = "127.0.0.1";
final int fcServerPort = 7890;

final int boxesAcross = 4;
final int boxesDown = 3;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;

int exitTimer = 0; // Run forever unless set by command line

void setup() {

  apply_cmdline_args();

  size(640, 480);
  colorMode(HSB);

  // Connect to an instance of fcserver
  opc = new OPC(this, fcServerHost, fcServerPort);
  opc.showLocations(false);

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }
}

void draw() {

  fill(1, 10);
  noStroke();
  rect(0, 0, width, height);

  if (millis() < 5000) {
    warmup();
  } else {
    switch (((millis() - 5000) / 5000) % 4) {
    case 0:
      text_id_grids();
      break;
    case 1:
      wipe_right();
      break;
    case 2:
      wipe_down();
      break;
    case 3:
      wipe_diagonal();
      break;
    default:
      break;
    }
  }

  check_exit();
}

void warmup() {
  int bri = 255;
  for (int y = 0; y < boxesDown * ledsDown; y++) {
    for (int x = 0; x < boxesAcross * ledsAcross; x++) {
      if (random(1.0) < 0.01) { // set the pixel
        int hue = (int)random(256);
        int sat = (int)random(256);
        fill(hue, sat, bri);
        square(x0 + spacing * x - spacing / 2, y0 + spacing * y - spacing / 2, spacing - 3);
      }
    }
  }
}

void text_id_grids() {
  int sat = 255;
  int bri = 255;
  int hue = 0;
  int size =  (int)(spacing * (boxesDown * ledsDown - 1) / boxesDown);
  textSize(size);
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      String txt = "R";
      if (y > 0) {
        if (x < 2) {
          txt = "G";
          hue = 71;
        } else {
          txt = "B";
          hue = 168;
        }
      }
      // Apply a little shadow so that letter is rendered better on LEDs
      fill(hue, sat, bri / 2);
      text(txt, x0 + spacing * (x * ledsDown) + spacing / 4, y0 + spacing * (y * ledsAcross) + (3 * size / 4) + spacing / 4);
      fill(hue, sat, bri * 3 / 4);
      text(txt, x0 + spacing * (x * ledsDown) + spacing / 8, y0 + spacing * (y * ledsAcross) + (3 * size / 4) + spacing / 8);
      fill(hue, sat, bri);
      text(txt, x0 + spacing * (x * ledsDown), y0 + spacing * (y * ledsAcross) + (3 * size / 4));
    }
  }
}

void wipe_right() {
  int hue = (int)random(256);
  int sat = 0;
  int bri = 255;
  float progression = (float)(millis() % 1000) / 1000;
  int x = (int)(boxesAcross * ledsAcross * progression);

  fill(hue, sat, bri);

  for (int y = 0; y < boxesDown * ledsDown; y++) {
    square(x0 + spacing * x - spacing / 2, y0 + spacing * y - spacing / 2, spacing - 3);
  }
}

void wipe_down() {
  int hue = (int)random(256);
  int sat = 0;
  int bri = 255;
  float progression = (float)(millis() % 1000) / 1000;
  int y = (int)(boxesDown * ledsDown * progression);

  fill(hue, sat, bri);

  for (int x = 0; x < boxesAcross * ledsAcross; x++) {
    square(x0 + spacing * x - spacing / 2, y0 + spacing * y - spacing / 2, spacing - 3);
  }
}

void wipe_diagonal() {
  int hue = (int)random(256);
  int sat = 0;
  int bri = 255;
  float progression = (float)(millis() % 1000) / 1000;

  fill(hue, sat, bri);

  int k = (int)((boxesAcross * ledsAcross + boxesDown * ledsDown - 1) * progression);
  for (int y = 0; y < boxesDown * ledsDown; y++) {
    int x = k - y;
    if (x >= 0 && x < boxesAcross * ledsAcross) {
      square(x0 + spacing * x - spacing / 2, y0 + spacing * y - spacing / 2, spacing - 3);
    }
  }
}

void apply_cmdline_args() {

  if (args == null) {
    return;
  }

  for (String exp: args) {
    String[] comp = exp.split("=");
    switch (comp[0]) {
    case "exit":
      exitTimer = parseInt(comp[1], 10);
      println("exit after " + exitTimer + "s");
      break;
    }
  }
}

void check_exit() {

  if (exitTimer == 0) { // skip if not run from cmd line
    return;
  }

  int m = millis();
  if (m / 1000 >= exitTimer) {
    exit();
  }
}

PImage logo;
PGraphics pg;
String path;
String name = "aves-#####.jpg";

void icon() {
  logo = loadImage("logo.png");
  logo.resize(100, 0);
  path = sketchPath();
  surface.setIcon(logo);
  surface.setTitle("Aves");
}
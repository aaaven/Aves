import controlP5.*;
ControlP5 myp5;

float sepatateMagnitude =5.0;
float cohesionMagnitude =0.5;
float alignMagnitude =2.0;

void setupP5() {
  myp5 = new ControlP5(this);
  myp5.addSlider("sepatateMagnitude")
    .setPosition(10, 25)
    .setRange(1, 15)
    ;

  myp5.addSlider("cohesionMagnitude")
    .setPosition(10, 45)
    .setRange(0.01, 2)
    ;

  myp5.addSlider("alignMagnitude")
    .setPosition(10, 65)
    .setRange(1, 15)
    ; 
  myp5.setAutoDraw(false);
}

void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();

  myp5.draw();
  shape(logo, width-60,height-60);
  fill(100,50);
  rect(0,0,300,height);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}
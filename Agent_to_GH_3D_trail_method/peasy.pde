import peasy.*;
import processing.opengl.*;

PeasyCam cam;

void setupPeasy() {
  cam = new PeasyCam(this, 1200);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(2000); //step distance 250
  cam.rotateY(QUARTER_PI);
  cam.rotateX(QUARTER_PI);
}

void animate(){
  cam.rotateZ(0.01*sin(frameRate*0.01));
  cam.rotateY(0.01*cos(frameRate*0.01));
  cam.rotateX(0.005*cos(frameRate*0.01)+0.005*sin(frameRate*0.01));
}
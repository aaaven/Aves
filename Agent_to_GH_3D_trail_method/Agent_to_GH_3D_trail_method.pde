ArrayList balls;   
PShape logo;
//-------------------------box size, 3D zone,cp5 slider bar------------------------------------
int size = 900; //900 - 1200

void setup() {
  size(1280, 960, OPENGL);
  smooth(); 
  sphereDetail(3);
  setupOsc();
  setupPeasy();
  setupP5();
  balls = new ArrayList();  
  for (int i = 0; i < 10; i++) {
    Vec3D startPoint = new Vec3D (random(-size/2, size/2), 
      random(-size/2, size/2), random(-size/2, size/2));
    balls.add(new Ball(startPoint));
  }
  logo = loadShape("logo.svg");
}

void draw() {
  background(0);
  initData();
  //-----show bbox yes/no,cp5 toggle---------
  drawBbox(size);
  //-------show coordinate yes/no,cp5 toggle------------
  drawCoordinate(150);

  for (int i = 0; i < balls.size (); i++) {//loop through every single ball
    Ball theBall = (Ball) balls.get(i);
    ArrayList otherBalls = get_otherBalls(balls, theBall);//get new arraylist without theball  
    theBall.update();
    theBall.bounce();
    theBall.flock(otherBalls); //update the pos vector
    //-------------------update data yes/no, run/pause, cp5 toggle -----------------------------------
    updateData(theBall, i, balls.size ()); //collect position data of every ball
    theBall.display();
    if ((int)random(5)==1) {
      theBall.saveHistory(theBall.pos.x, theBall.pos.y, theBall.pos.z);
    }
    theBall.displayHistory();
    //println(theBall.history);
  }

  sendData();

  //----------draw UI yes/no, show/hide cp5 toggle---------------------------------------------------
  drawGUI();
  //----------show balls number and frameRate yes/no, textbox and toggle 
  //statistics();
  animate();
}

void keyPressed() {
  //------------------add  balls, cp5 toggle---------------------------------------
  if (key == 'a'||key =='A') {
    for (int i = 0; i < 100; i++) {
      Vec3D startPoint = new Vec3D (random(-size/2, size/2), 
        random(-size/2, size/2), random(-size/2, size/2));
      balls.add(new Ball(startPoint));
    }
  }
  //-------------------remove balls, cp5 toggle----------------------------------------
  if (key == 'm'||key =='M') {
    if (balls.size()>100) {
      for (int i = 0; i < 100; i++) {
        balls.remove(i);
      }
    }
  }

  if (key =='s' ||key =='S') {
    captureImg();
  }


  if (key =='c' ||key =='C') {
    println(cam.getDistance());
  }
}

void drawCoordinate(int axis) {
  pushStyle();
  strokeWeight(3);
  colorMode(RGB, 255, 255, 255);
  stroke(255, 0, 0);
  line(0, 0, 0, axis, 0, 0);//x axis
  stroke(0, 255, 0);
  line(0, 0, 0, 0, axis, 0);  //y axis
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, axis);  //z axis
  popStyle();
}

void drawBbox(int _size) {
  pushStyle();
  noFill();
  stroke(51, 50);
  box(_size);//draw box
  popStyle();
}

void statistics() {
  //flocking numbers
  println(balls.size());
  println(frameRate);
  //all data
  //write in some file? like obj or stl?
}

void captureImg() {
  saveFrame(frameCount+"####.jpg");
}
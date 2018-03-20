ArrayList balls;   
//-------------------------box size, 3D zone,cp5 slider bar------------------------------------
int size = 720; 

void setup() {
  //size(1280,960, P3D); 
  fullScreen(P3D);
  smooth(); 
  balls = new ArrayList();   
  for (int i = 0; i < 100; i++) {
    Vec3D startPoint = new Vec3D (random(-bboxSize/2, bboxSize/2), 
      random(-bboxSize/2, bboxSize/2), random(-bboxSize/2, bboxSize/2));
    balls.add(new Ball(startPoint));
  }
  icon();
  setupOsc();
  setupPeasy();
  setupP5();
}

void draw() {
  //----------update data yes/no, run/pause, cp5 toggle----------------------------------------------
  initData();
  background(0);

  //-----show bbox yes/no,cp5 toggle---------
  if (showBbox)drawBbox(bboxSize);
  //-------show coordinate yes/no,cp5 toggle------------
  if (showCoo)drawCoordinate(cooSize);

  for (int i = 0; i < balls.size (); i++) {//loop through every single ball
    Ball theBall = (Ball) balls.get(i);
    ArrayList otherBalls = get_otherBalls(balls, theBall);//get new arraylist without theball  
    theBall.run();//update the pos vector
    theBall.flock(otherBalls); //update the pos vector
    //-------------------update data yes/no, run/pause, cp5 toggle -----------------------------------
    updateData(theBall, i, balls.size ()); //collect position data of every ball
    theBall.display();
  }
  //----------show balls number and frameRate yes/no, textbox and toggle 
  statistics();
  if (sendData)sendData();
  animate();
  //----------draw UI yes/no, show/hide cp5 toggle---------------------------------------------------
  drawGUI();
}

void keyPressed() {
  //------------------add  balls, cp5 toggle---------------------------------------
  if (key == 'a'||key =='A') {
    addBall(100);
  }
  //-------------------remove balls, cp5 toggle----------------------------------------
  if (key == 'm'||key =='M') {
   
   removeBall(100);
  }

  if (key =='s' ||key =='S') {
    captureImg();
  }
}

void addBall(int addNum) {
  for (int i = 0; i < addNum; i++) {
    Vec3D startPoint = new Vec3D (random(-bboxSize/2, bboxSize/2), 
      random(-bboxSize/2, bboxSize/2), random(-bboxSize/2, bboxSize/2));
    balls.add(new Ball(startPoint));
  }
}

void removeBall(int removeNum) {
  if (balls.size()>removeNum) {
    for (int i = 0; i < removeNum; i++) {
      balls.remove(i);
    }
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
  stroke(51, 150);
  box(_size);//draw box
  popStyle();
}

void statistics() {
  //flocking numbers
  println(balls.size());
  println(frameRate);
  
}

void captureImg() {
  saveFrame(path + "/" + name);
}
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
  for (int i = 0; i < 100; i++) {
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
    theBall.run();//update the pos vector
    theBall.flock(otherBalls); //update the pos vector
    //-------------------update data yes/no, run/pause, cp5 toggle -----------------------------------
    updateData(theBall, i, balls.size ()); //collect position data of every ball
    theBall.display();
  }  
  sendData();


  //convert history into Vect3D
  for (int i =0; i < history.size()-1; i++) {
    String list = (String) history.get(i);//{}|{}|{}  
    String[] items = split(list, "|");//items type: array; items content:{},{},{}
    for (int j = 0; j < items.length; j++) {
      String item = items[j];//{}
      Vec3D vecItem = strToVec(item);
      //print(vecItem);
      drawSphere(vecItem);
    }
    println();
    println("-------balls in Frame:  " + i);
  }


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

//funtion to get otherBalls
ArrayList get_otherBalls(ArrayList oldArray, Ball toRemove) {
  ArrayList otherBalls = new ArrayList();
  for (int i = 0; i < oldArray.size(); i++) {
    Ball other = (Ball) oldArray.get(i);
    if (other != toRemove) {
      otherBalls.add(balls.get(i));
    }
  }
  return otherBalls;
}

//function convert string to vector
Vec3D strToVec(String str) {
  String string = str.substring(1, str.length()-1);
  String[] items = split(string, ",");
  float vecX = Float.parseFloat(items[0]);
  float vecY = Float.parseFloat(items[1]);
  float vecZ = Float.parseFloat(items[2]);
  Vec3D vec = new Vec3D(vecX, vecY, vecZ); 
  return vec;
}

//draw vect sphere
void drawSphere(Vec3D _vector) {
  pushStyle();
  colorMode(RGB);
  noFill();
  stroke(180);
  strokeWeight(0.3);
  pushMatrix();
  translate(_vector.x, _vector.y, _vector.z);
  sphere(1.875);
  //println("sphere  "+ _vector+"  is drew");
  popMatrix();
  popStyle();
}
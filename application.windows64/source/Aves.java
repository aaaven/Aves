import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.geom.*; 
import controlP5.*; 
import oscP5.*; 
import netP5.*; 
import peasy.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Aves extends PApplet {

ArrayList balls;   
//-------------------------box size, 3D zone,cp5 slider bar------------------------------------
int size = 720; 

public void setup() {
  //size(1280,960, P3D); 
  
   
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

public void draw() {
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

public void keyPressed() {
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

public void mousePressed() {
  //--------------------direct to website--------------------------
  if (mouseX > width -63 && mouseX < width -19&&mouseY<height -10&&mouseY>height-45) {
    link("http://aven.cc");
  }
}

public void addBall(int addNum) {
  for (int i = 0; i < addNum; i++) {
    Vec3D startPoint = new Vec3D (random(-bboxSize/2, bboxSize/2), 
      random(-bboxSize/2, bboxSize/2), random(-bboxSize/2, bboxSize/2));
    balls.add(new Ball(startPoint));
  }
}

public void removeBall(int removeNum) {
  if (balls.size()>removeNum) {
    for (int i = 0; i < removeNum; i++) {
      balls.remove(i);
    }
  }
}

public void drawCoordinate(int axis) {
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

public void drawBbox(int _size) {
  pushStyle();
  noFill();
  stroke(51, 150);
  box(_size);//draw box
  popStyle();
}

public void statistics() {
  //flocking numbers
  println(balls.size());
  println(frameRate);
}

public void captureImg() {
  saveFrame(path + "/" + name);
}


class Ball {
  float radius = 15;
  Vec3D pos = new Vec3D(0, 0, 0); 
  Vec3D vel = new Vec3D(random(-2, 2), random(-2, 2), random(-2, 2));
  Vec3D accel = new Vec3D();
  PShape lines;
  Ball(Vec3D pos_) {
    pos = pos_;
  }
  public void run() {
    update();
    bounce();
    //gravity();
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    pushStyle();
    noStroke();
    colorMode(HSB);
    fill(scolor,100,100);
    //-------------------display yes/no and size, cp5 toggle and slider bar----------------------  
    sphereDetail(sphereDetail);
    if(showSphere)sphere(sphereSize); //size is 1.875
    popStyle();
    popMatrix();
    //--------------------
  }

  public void update() {
    vel.addSelf(accel); 
    vel.limit(2);
    pos.addSelf(vel);
  }

  public void bounce() {
    //x  
    if (pos.x < -bboxSize/2) {      
      pos.x = -bboxSize/2;
      vel.x *= -2;
    } else if ( pos.x > bboxSize/2) {
      pos.x = bboxSize/2;      
      vel.x *= -2;
    }
    //y
    if (pos.y < -bboxSize/2) {
      pos.y = -bboxSize/2;
      vel.y *= -2;
    } else if (pos.y > bboxSize/2) {
      pos.y = bboxSize/2;
      vel.y *= -2;
    }
    //z
    if (pos.z < -bboxSize/2) {
      pos.z = -bboxSize/2;
      vel.z *= -2;
    } else if (pos.z > bboxSize/2) {
      pos.z = bboxSize/2;
      vel.z *= -2;
    }
  }

  public void gravity() {
    vel.y += 0.2f;
  }

  public void lineBetween(ArrayList others) {

    for (int i = 0; i < others.size (); i ++) {
      Ball otherBall = (Ball) others.get(i); 
      float distance = pos.distanceTo(otherBall.pos);
      //float disCheck = 5*radius;
      if (distance >0 && distance < lineLen) { //dis range: 0 ~ 75
        pushStyle();
        colorMode(HSB, 360, 100, 100);
        //--------------------dispaly color, cp5 slider bar 0 to 360----------------------------
        int hue = 160;
        int sat = (int)map(distance, 0, 75, 100, 30);
        int bri = (int)map(distance, 0, 75, 97, 3);
        stroke(lcolor, sat, bri);
        strokeWeight(0.3f);
        line(pos.x, pos.y, pos.z, otherBall.pos.x, otherBall.pos.y, otherBall.pos.z);
        popStyle();
      }
    }
  }

  public void flock(ArrayList others) {
    separate(separateMagnitude, others);
    cohesion(cohesionMagnitude, others);
    align(alignMagnitude, others);
    //--------------show line between yes/no, cp5 toggle---------------------  
    if(showLine)lineBetween(others);
  }

  public void separate(float magnitude, ArrayList others) {
    Vec3D _accel = new Vec3D();
    int count = 0;
    for (int i = 0; i < others.size (); i ++) {
      Ball otherBall = (Ball) others.get(i); 
      float distance = pos.distanceTo(otherBall.pos);
      if (distance > 0 && distance < 2*radius) {
        Vec3D vecBetween = pos.sub(otherBall.pos); 
        vecBetween.normalizeTo(1.0f/distance);
        _accel.addSelf(vecBetween);
        count ++;
      }
    }
    if (count > 0) {
      _accel.scaleSelf(1.0f/count);//control
    }
    _accel.scaleSelf(magnitude);
    accel.addSelf(_accel);
  }

  public void cohesion(float magnitude, ArrayList others) {
    Vec3D sum = new Vec3D();
    int count = 0;
    for (int i = 0; i < others.size (); i ++) {
      Ball otherBall = (Ball) others.get(i); 
      float distance = pos.distanceTo(otherBall.pos);
      if (distance > 0 && distance < 8*radius) {
        sum.addSelf(otherBall.pos);
        count ++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1.0f/count);
    }
    Vec3D _accel = sum.sub(pos);
    _accel.scaleSelf(magnitude);
    accel.addSelf(_accel);
  }

  public void align(float magnitude, ArrayList others) {
    Vec3D _accel = new Vec3D();
    int count = 0;
    for (int i = 0; i < others.size (); i ++) {
      Ball otherBall = (Ball) others.get(i); 
      float distance = pos.distanceTo(otherBall.pos);
      if (distance > 0 && distance < 2*radius) {
        _accel.addSelf(otherBall.vel);
        count ++;
      }
    }
    if (count > 0) {
      _accel.scaleSelf(1.0f/count);
    }
    _accel.scaleSelf(magnitude);
    accel.addSelf(_accel);
  }
}

//funtion to get otherBalls
public ArrayList get_otherBalls(ArrayList oldArray, Ball toRemove) {
  ArrayList otherBalls = new ArrayList();
  for (int i = 0; i < oldArray.size(); i++) {
    Ball other = (Ball) oldArray.get(i);
    if (other != toRemove) {
      otherBalls.add(balls.get(i));
    }
  }
  return otherBalls;
}

ControlP5 myp5;


int panelX = 20, panelY = 20, panelWidth = 200, panelColor = color(255, 100), gapHeight = 15, groupColor = color(255, 0, 0, 50), 
  group1H = 40, group2H = 200, group2_1H = 55, group2_2H = 40, group2_3H = 55, group3H = 40, group4H = 65, group5H = 50
  ;

boolean showBbox = true, showCoo = false, showSphere = true, showLine = true, sendData = false
  ; 

float sphereSize = 1.8f, separateMagnitude =5, cohesionMagnitude =0.5f, alignMagnitude =2
  ;

int bboxSize = 1050, cooSize = 150, sphereDetail = 5, scolor = 160, lineLen = 75, lcolor = 180
  ;

int barbg = color(255), barHover = color(0xfffff100), barText = color(0); 

/*
info board:
 //show balls number
 //show frameRate yes/no, textbox and toggle (with color)
 */

/*
data communication:
 //update data yes/no, run/pause, cp5 toggle----------------------------------------------
 //OSC path/port name : pass it to osc part, an input box
 */

/*
save file
 
 //txt path input + save button, input box and button
 //.stl path input + save button, input box and button
 */


public void setupP5() {

  myp5 = new ControlP5(this);

  Group controlPanel = myp5.addGroup("controlPanel")
    .setPosition(10, 20)
    .setWidth(panelWidth)
    .setBackgroundHeight(height-20)
    .setBarHeight(10)
    .activateEvent(true)
    //.setColorValue(color(0,0,255))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(barbg)  //hover color
    .setColorBackground(color(0xfffff100))
    .setColorLabel(barText)   //font color
    .setBackgroundColor(color(255, 0))  //backgroud color
    .setLabel("controlPanel:")
    ;

  Group group1 = myp5.addGroup("group1")
    .setPosition(0, panelY)
    .setWidth(panelWidth)
    .setBackgroundHeight(group1H)
    .activateEvent(true)
    .setGroup(controlPanel)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("Boundary Box & Coordinate Control:")
    ;

  group1Design(group1);

  float group2Y = panelY+group1H+gapHeight+5; 
  Group group2 = myp5.addGroup("group2")
    .setPosition(0, group2Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2H)
    .activateEvent(true)
    .setBackgroundColor(color(255, 0))
    .setGroup(controlPanel)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setLabel("Agent feature control:")
    ;

  float group2_1Y = gapHeight; 
  Group group2_1 = myp5.addGroup("group2_1")
    .setPosition(0, group2_1Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_1H)
    .activateEvent(true)
    .setGroup(group2)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(color(255, 175))
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("display:")
    ;

  group2_1Design(group2_1);


  float group2_2Y = group2_1Y+group2_1H+gapHeight; 
  Group group2_2 = myp5.addGroup("group2_2")
    .setPosition(0, group2_2Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_2H)
    .activateEvent(true)
    .setGroup(group2)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(color(255, 175))
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("connection:")
    ;

  group2_2Design(group2_2);


  float group2_3Y = group2_2Y+group2_2H+gapHeight; 
  Group group2_3 = myp5.addGroup("group2_3")
    .setPosition(0, group2_3Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_3H)
    .activateEvent(true)
    .setGroup(group2)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(color(255, 175))
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("behavior:") 
    ;
  group2_3Design(group2_3);


  float group3Y = group2Y+group2H+gapHeight; 
  Group group3 = myp5.addGroup("group3")
    .setPosition(0, group3Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group3H)
    .activateEvent(true)
    .setGroup(controlPanel)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("Agent quantity control:")
    ;

  group3Design(group3);

  float group4Y = group3Y+group3H+gapHeight+5; 
  Group group4 = myp5.addGroup("group4")
    .setPosition(0, group4Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group4H)
    .activateEvent(true)
    .setGroup(controlPanel)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("Data communication control:")
    ;
  group4Design(group4);


  float group5Y = group4Y+group4H+gapHeight+5; 
  Group group5 = myp5.addGroup("group5")
    .setPosition(0, group5Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group5H)
    .activateEvent(true)
    .setGroup(controlPanel)
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(0xfffff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("Save file:")
    ;
  group5Design(group5);

  myp5.setAutoDraw(false);
}

//to test if it would work
public void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  myp5.draw();
  monitoring(10, height-45);
  image(logo, width -63, height - 45);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

public void group1Design(Group group1) {

  myp5.addButton("showBbox")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("bboxSize")
    .setRange(900, 1200)
    .setPosition(90, 5)                
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("box size")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("bboxSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("bboxSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);


  myp5.addButton("showCoo")
    .setPosition(5, 20)                     //5 gapheight
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("cooSize")
    .setRange(50, 250)
    .setPosition(90, 20)
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("axis length")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("cooSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("cooSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);
}


public void group2_1Design(Group group2_1) {

  myp5.addButton("showSphere")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_1)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("sphereSize")
    .setRange(1, 2.6f)
    .setPosition(95, 5)                
    .setSize(75, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("sphere Size")              
    .setGroup(group2_1)

    ;
  myp5.getController("sphereSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("sphereSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-55);

  myp5.addSlider("sphereDetail")
    .setRange(3, 7)
    .setPosition(95, 20)
    .setSize(75, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("detail")              //slider text content
    .setGroup(group2_1)
    ;
  myp5.getController("sphereDetail").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("sphereDetail").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-55);

  myp5.addSlider("scolor")
    .setRange(0, 360)
    .setPosition(95, 35)
    .setSize(75, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("color")              //slider text content
    .setGroup(group2_1)
    ;
  myp5.getController("scolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("scolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-55);
}


public void group2_2Design(Group group2_2) {
  myp5.addButton("showLine")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_2)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("show")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addSlider("lineLen")
    .setRange(50, 100)
    .setPosition(90, 5)                
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("line length")              
    .setGroup(group2_2)

    ;
  myp5.getController("lineLen").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("lineLen").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);

  myp5.addSlider("lcolor")
    .setRange(0, 360)
    .setPosition(90, 20)
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("Line color")              //slider text content
    .setGroup(group2_2)
    ;
  myp5.getController("lcolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("lcolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);
}

public void group2_3Design(Group group2_3) {
  myp5.addSlider("separateMagnitude")
    .setRange(1, 15)
    .setPosition(45, 5)
    .setSize(125, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("separate")              
    .setGroup(group2_3)
    ;
  myp5.getController("separateMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("separateMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("cohesionMagnitude")
    .setRange(0.01f, 2)
    .setPosition(45, 20)
    .setSize(125, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("cohesion")              
    .setGroup(group2_3)
    ;
  myp5.getController("cohesionMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("cohesionMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("alignMagnitude")
    .setRange(1, 15)
    .setPosition(45, 35)
    .setSize(125, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(0xfffff100))
    .setLabel("align")              
    .setGroup(group2_3)
    ;
  myp5.getController("alignMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("alignMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);
}

public void  group3Design(Group group3) {
  myp5.addButton("add200")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("++ 200")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add100")
    .setPosition(55, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)  
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg).setLabel("++ 100")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add010")
    .setPosition(105, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("++ 010")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add001")
    .setValue(0)
    .setPosition(155, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("++ 001")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove200")
    .setValue(0)
    .setPosition(5, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("-- 200")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove100")
    .setValue(0)
    .setPosition(55, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("-- 100")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove010")
    .setValue(0)
    .setPosition(105, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("-- 010")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove001")
    .setValue(0)
    .setPosition(155, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("-- 001")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;
}

public void  group4Design(Group group4) {

  myp5.addTextfield("ip")
    .setPosition(55, 5)
    .setSize(140, 10)
    .setGroup(group4)
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setLabel("IP Address")                       //button text content
    .setColorLabel(color(0))        //button font color
    .setValue("172.26.101.105") 
    .setColorValue(color(0))
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50)
    ;

  myp5.addTextfield("port")
    .setPosition(55, 20)
    .setSize(140, 10)
    .setGroup(group4)
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setLabel("Port Name")                       //button text content
    .setColorLabel(color(0))        //button font color
    .setValue("6881") 
    .setColorValue(color(0))
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50)
    ;

  myp5.addTextfield("message")
    .setPosition(55, 35)
    .setSize(140, 10)
    .setGroup(group4)
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setLabel("Message")                       //button text content
    .setColorLabel(color(0))        //button font color
    .setValue("/array") 
    .setColorValue(color(0))
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50)
    ;


  myp5.addButton("sendDataPause")
    .setPosition(5, 50)
    .setSize(panelWidth-10, 10)
    .setGroup(group4)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("send / Pause Data")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;
}

public void group5Design(Group group5) {
  myp5.addTextfield("fpath")
    .setPosition(55, 5)
    .setSize(140, 10)
    .setGroup(group5)
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setLabel("File Path")                       //button text content
    .setColorLabel(color(0))        //button font color
    .setValue(path) 
    .setColorValue(color(0))
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50)
    ;

  myp5.addTextfield("fname")
    .setPosition(55, 20)
    .setSize(140, 10)
    .setGroup(group5)
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setLabel("File Name")                       //button text content
    .setColorLabel(color(0))        //button font color
    .setValue(name) 
    .setColorValue(color(0))
    .getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50)
    ;

  myp5.addButton("saveimg")
    .setPosition(5, 35)
    .setSize(panelWidth-10, 10)
    .setGroup(group5)
    .setColorBackground(color(0xfffff100))
    .setColorForeground(barbg)
    .setLabel("Save Image")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;
}
public void controlEvent(ControlEvent theEvent) {
}
public void showBbox() {
  showBbox = !showBbox;
}
public void showCoo() {
  showCoo = !showCoo;
}
public void showSphere() {
  showSphere = !showSphere;
}
public void showLine() {
  showLine = !showLine;
}
public void add200() {
  addBall(200);
}
public void add100() {
  addBall(100);
}
public void add010() {
  addBall(10);
}
public void add001() {
  addBall(1);
}
public void remove200() {
  removeBall(200);
}
public void remove100() {
  removeBall(100);
}
public void remove010() {
  removeBall(10);
}
public void remove001() {
  removeBall(1);
}
public void ip(String theString) {
  ipAddress = theString;
}
public void port(String theString) {
  portName = theString;
}
public void message(String theString) {
  initMessage = theString;
}
public void sendDataPause() {
  sendData = !sendData;
  if (sendData)setupOsc();
}

public void fpath(String theString) {
  path = theString;
}
public void fname(String theString) {
  name = theString;
}
public void saveimg() {
  captureImg();
}

public void monitoring(float x, float y) {
  pushStyle();
  textAlign(LEFT);
  textSize(10);
  textMode(SHAPE);
  noStroke();
  pushMatrix();
  translate(x, y);
  fill(panelColor);
  rect(0, 0, 200, 35);
  fill(color(0xfffff100));
  rect(5, 5, 100, 10);
  rect(5, 20, 100, 10);
  fill(barbg);
  rect(110, 5, 85, 10);
  rect(110, 20, 85, 10);
  rect(0, -10, 200, 9);
  fill(barText);
  strokeWeight(0.1f);
  stroke(barText);
  text("Monitor:", 5, -5);
  text("Quantity:", 10, 10);
  text("frameRate:", 10, 25);
  text(balls.size(), 150, 10);
  if (frameRate<20) {
    fill(255, 0, 0);
    stroke(255, 0, 0);
  }
  text(round(frameRate), 150, 25);
  popMatrix();
  popStyle();
}


OscP5 oscP5; 
NetAddress myBroadcastLocation;
OscMessage arrayMsg; 
String toSend_;
String ipAddress = "10.209.12.21", portName = "6881", initMessage = "/array"
  ;
public void setupOsc() {
  oscP5 = new OscP5(this, 6881); 
  myBroadcastLocation = new NetAddress(ipAddress, PApplet.parseInt(portName));
  arrayMsg = new OscMessage(initMessage);
}


public void initData() {
  toSend_ ="";
  arrayMsg = new OscMessage(initMessage);
}

public void updateData(Ball theBall, int index, int len) {
  toSend_ += "{";
  toSend_ += theBall.pos.x;
  toSend_ += ",";
  toSend_ += theBall.pos.y;
  toSend_ += ",";
  toSend_ += theBall.pos.z;
  toSend_ += "}";
  if (index < len) {
    toSend_ += "|";
  }
}
public void sendData() {

  //println(toSend_);
  //println("----");
  arrayMsg.add(toSend_); 
  /*this loads the string to the message container prior to sending you can actually load(add) many strings/values before sending them. The OSC library separates these 
   values with commas. Thats why in this example we "devised" this trick with * and & to send the whole array as a single string, everytime the "void draw" runs,and separate the 
   arrayinto rows and columns in Grasshopper.The way we did this was to assemble "Grasshopper-ready" points: {x,y,z} in the case of a 3x3 array, the string will like:
   {0,0,0}*{1,0,0)*{2,0,0}&{0,1,0}*{1,1,0)*{2,1,0}&{0,2,0}*{1,2,0)*{2,2,0}
   which in grasshopper we will read more or less like this:
   {0,0,0},{1,0,0),{2,0,0}
   {0,1,0},{1,1,0),{2,1,0}
   {0,2,0},{1,2,0),{2,2,0}*/
  oscP5.send(arrayMsg, myBroadcastLocation); //this is the actual command that sends the message
}



PeasyCam cam;

public void setupPeasy() {
  cam = new PeasyCam(this, 1350);
  cam.setMinimumDistance(15);
  cam.setMaximumDistance(1500);
  cam.rotateY(QUARTER_PI);
  cam.rotateX(QUARTER_PI);
}


public void animate() {
  cam.rotateZ(0.01f*sin(frameRate*0.01f));
  cam.rotateY(0.01f*cos(frameRate*0.01f));
  cam.rotateX(0.005f*cos(frameRate*0.01f)+0.005f*sin(frameRate*0.01f));
}
PImage logo;
PGraphics pg;
String path;
String name = "aves-#####.jpg";

public void icon() {
  logo = loadImage("logo.png");
  path = sketchPath();
  surface.setIcon(logo);
  surface.setTitle("Aves");
}
  public void settings() {  fullScreen(P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Aves" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

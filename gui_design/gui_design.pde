import controlP5.*;
ControlP5 myp5;


int panelX = 20, panelY = 20, panelWidth = 200, panelColor = color(255, 0), gapHeight = 20, groupColor = color(255, 130), 
  group1H = 40, group2H = 220, group2_1H = 55, group2_2H = 40, group2_3H = 55, group3H = 40, group4H = 50, group5H = 50
  ;

boolean showBbox = true, showCoo = true, showSphere = true, showLine = true, sendDatatoGH = true
  ; 

float sphereSize = 1.8, separateMagnitude =5, cohesionMagnitude =0.5, alignMagnitude =2
  ;

int bboxSize = 1050, cooSize = 150, sphereDetail = 5, scolor = 160, lineLen = 75, lcolor = 180
  ;

/*
boundary box & coordinate
 (boundary box properties)
 //show bbox yes/no,cp5 toggle---------
 //box size, 3D zone, cp5 slider bar------------------------------------
 
 (coordinate properties)
 //show coordinate yes/no,cp5 toggle------------
 //coordinate axis length, cp5 slider
 */




/*
agent display:
 
 (sphere Properties)
 //display yes/no and size, cp5 toggle and slider bar----------------------
 //sphere details ?
 //sphere color
 
 (line in-between Properties)
 //show line between yes/no, cp5 toggle---------------------
 //display color, cp5 slider bar 0 to 360----------------------------
 
 agent behavior:
 //separateMagnitude
 //cohesionMagnitude
 //alignMagnitude
 
 */

/*
agent number:
 //add  balls, cp5 toggle---------------------------------------
 //remove balls, cp5 toggle----------------------------------------
 */

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

void setup() {
  size(720, 720); 
  background(0);
  myp5 = new ControlP5(this);

  Group controlPanel = myp5.addGroup("controlPanel")
    .setPosition(20, 30)
    .setWidth(panelWidth)
    .setBackgroundHeight(height-40)
    .setBarHeight(10)
    .activateEvent(true)
    //.setColorValue(color(0,0,255))
    .setColorActive(color(255, 0, 0))
    .setColorForeground(color(#fff100))  //hover color
    .setColorBackground(color(255))
    .setColorLabel(color(0))   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("controlPanel:")
    ;

  Group group1 = myp5.addGroup("group1")
    .setPosition(0, panelY)
    .setWidth(panelWidth)
    .setBackgroundHeight(group1H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(controlPanel)
    .setLabel("Boundary Box & Coordinate:")
    ;

  group1Design(group1);

  float group2Y = panelY+group1H+gapHeight; 
  Group group2 = myp5.addGroup("group2")
    .setPosition(0, group2Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(controlPanel)
    .setLabel("Agent Feature Control:")
    ;

  float group2_1Y = gapHeight; 
  Group group2_1 = myp5.addGroup("group2_1")
    .setPosition(0, group2_1Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_1H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(group2)
    .setLabel("display:")
    ;

  group2_1Design(group2_1);


  float group2_2Y = group2_1Y+group2_1H+gapHeight; 
  Group group2_2 = myp5.addGroup("group2_2")
    .setPosition(0, group2_2Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_2H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(group2)
    .setLabel("connection:")
    ;

  group2_2Design(group2_2);


  float group2_3Y = group2_2Y+group2_2H+gapHeight; 
  Group group2_3 = myp5.addGroup("group2_3")
    .setPosition(0, group2_3Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group2_3H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(group2)
    .setLabel("behavior:") 
    ;
  group2_3Design(group2_3);


  float group3Y = group2Y+group2H+gapHeight; 
  Group group3 = myp5.addGroup("group3")
    .setPosition(0, group3Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group3H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(controlPanel)
    .setLabel("Agent number control:")
    ;

  group3Design(group3);

  float group4Y = group3Y+group3H+gapHeight; 
  Group group4 = myp5.addGroup("group4")
    .setPosition(0, group4Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group4H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(controlPanel)
    .setLabel("Data communication control:")
    ;

  group4Design(group4);

  float group5Y = group4Y+group4H+gapHeight; 
  Group group5 = myp5.addGroup("group5")
    .setPosition(0, group5Y)
    .setWidth(panelWidth)
    .setBackgroundHeight(group5H)
    .activateEvent(true)
    .setBackgroundColor(groupColor)
    .setGroup(controlPanel)
    .setLabel("Save file:")
    ;


  //myp5.setAutoDraw(false);
}


void draw() {
  background(0);
  //println("bboxSize "+bboxSize);
  //println("cooSize "+cooSize);
}

//to test if it would work
void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  //cam.beginHUD();

  //myp5.draw();
  //shape(logo, width-60,height-60);

  //cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void group1Design(Group group1) {

  myp5.addButton("showBbox")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(0, 255, 0))
    .setLabel("show")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addSlider("bboxSize")
    .setRange(900, 1200)
    .setPosition(66, 5)                
    .setSize(100, 10)
    .setLabel("box size")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("bboxSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("bboxSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-27);


  myp5.addButton("showCoo")
    .setPosition(5, 20)                     //5 gapheight
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(0, 255, 0))
    .setLabel("show")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addSlider("cooSize")
    .setRange(50, 250)
    .setPosition(66, 20)
    .setSize(100, 10)
    .setLabel("axis length")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("cooSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("cooSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-27);
}


void group2_1Design(Group group2_1) {

  myp5.addButton("showSphere")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_1)
    .setColorBackground(color(#fff100))
    .setLabel("show")                       //button text content
    .setColorLabel(color(255))        //button font color
    ;

  myp5.addSlider("sphereSize")
    .setRange(1, 2.6)
    .setPosition(66, 5)                
    .setSize(100, 10)
    .setLabel("sphere Size")              
    .setGroup(group2_1)

    ;
  myp5.getController("sphereSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("sphereSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-27);

  myp5.addSlider("sphereDetail")
    .setRange(3, 7)
    .setPosition(66, 20)
    .setSize(100, 10)
    .setLabel("detail")              //slider text content
    .setGroup(group2_1)
    ;
  myp5.getController("sphereDetail").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("sphereDetail").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-27);

  myp5.addSlider("scolor")
    .setRange(0, 360)
    .setPosition(66, 35)
    .setSize(100, 10)
    .setLabel("color")              //slider text content
    .setGroup(group2_1)
    ;
  myp5.getController("scolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("scolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-27);
}


void group2_2Design(Group group2_2) {
  myp5.addButton("showLine")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_2)
    .setColorBackground(color(0, 255, 0))
    .setLabel("show")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addSlider("lineLen")
    .setRange(50, 100)
    .setPosition(66, 5)                
    .setSize(100, 10)
    .setLabel("line length")              
    .setGroup(group2_2)

    ;
  myp5.getController("lineLen").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("lineLen").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("lcolor")
    .setRange(0, 360)
    .setPosition(66, 20)
    .setSize(100, 10)
    .setLabel("Line color")              //slider text content
    .setGroup(group2_2)
    ;
  myp5.getController("lcolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("lcolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);
}

void group2_3Design(Group group2_3) {
  myp5.addSlider("separateMagnitude")
    .setRange(1, 15)
    .setPosition(45, 5)
    .setSize(120, 10)
    .setLabel("separate")              
    .setGroup(group2_3)
    ;
  myp5.getController("separateMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("separateMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("cohesionMagnitude")
    .setRange(0.01, 2)
    .setPosition(45, 20)
    .setSize(120, 10)
    .setLabel("cohesion")              
    .setGroup(group2_3)
    ;
  myp5.getController("cohesionMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("cohesionMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("alignMagnitude")
    .setRange(1, 15)
    .setPosition(45, 35)
    .setSize(120, 10)
    .setLabel("align")              
    .setGroup(group2_3)
    ;
  myp5.getController("alignMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("alignMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);
}

void  group3Design(Group group3) {
  myp5.addButton("add200")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("++ 200")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("add100")
    .setPosition(55, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("++ 100")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("add010")
    .setPosition(105, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("++ 010")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("add001")
    .setPosition(155, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("++ 001")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("remove200")
    .setPosition(5, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("-- 200")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("remove100")
    .setPosition(55, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("-- 100")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("remove010")
    .setPosition(105, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("-- 010")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;

  myp5.addButton("remove001")
    .setPosition(155, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(0, 255, 0))
    .setLabel("-- 001")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;
}

void group4Design(Group group4) {
  myp5.addButton("sendDatatoGH")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(140, 10)
    .setGroup(group4)
    .setColorBackground(color(0, 255, 0))
    .setLabel("Send data/ pause")                       //button text content
    .setColorLabel(color(255, 0, 0))        //button font color
    ;
}

void controlEvent(ControlEvent theEvent) {
}
void showBbox() {
  showBbox = !showBbox;
}
void showCoo() {
  showCoo = !showCoo;
}
void showSphere() {
  showSphere = !showSphere;
}
void showLine() {
  showLine = !showLine;
}
void sendDatatoGH() {
  sendDatatoGH = !sendDatatoGH;
}
//void add200() {
//  addBall(200);
//}
//void add100() {
//  addBall(100);
//}
//void add010() {
//  addBall(10);
//}
//void add001() {
//  addBall(1);
//}
//void remove200() {
//  removeBall(200);
//}
//void remove100() {
//  removeBall(100);
//}
//void remove010() {
//  removeBall(10);
//}
//void remove001() {
//  removeBall(1);
//}
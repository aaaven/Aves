import controlP5.*;
ControlP5 myp5;


int panelX = 20, panelY = 20, panelWidth = 200, panelColor = color(255, 100), gapHeight = 15, groupColor = color(255, 0, 0, 50), 
  group1H = 40, group2H = 200, group2_1H = 55, group2_2H = 40, group2_3H = 55, group3H = 40, group4H = 65, group5H = 50
  ;

boolean showBbox = true, showCoo = false, showSphere = true, showLine = true, sendData = false
  ; 

float sphereSize = 1.8, separateMagnitude =5, cohesionMagnitude =0.5, alignMagnitude =2
  ;

int bboxSize = 1050, cooSize = 150, sphereDetail = 5, scolor = 160, lineLen = 75, lcolor = 180
  ;

int barbg = color(255), barHover = color(#fff100), barText = color(0); 

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


void setupP5() {

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
    .setColorBackground(color(#fff100))
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
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
    .setColorForeground(color(#fff100))  //hover color
    .setColorBackground(barbg)
    .setColorLabel(barText)   //font color
    .setBackgroundColor(panelColor)  //backgroud color
    .setLabel("Save file:")
    ;
  group5Design(group5);

  myp5.setAutoDraw(false);
}




//to test if it would work
void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  myp5.draw();
  monitoring(10, height-45);
  image(logo, width -110, height - 70);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void group1Design(Group group1) {

  myp5.addButton("showBbox")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("bboxSize")
    .setRange(900, 1200)
    .setPosition(90, 5)                
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
    .setLabel("box size")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("bboxSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("bboxSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);


  myp5.addButton("showCoo")
    .setPosition(5, 20)                     //5 gapheight
    .setSize(30, 10)
    .setGroup(group1)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("cooSize")
    .setRange(50, 250)
    .setPosition(90, 20)
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
    .setLabel("axis length")              //slider text content
    .setGroup(group1)
    ;
  myp5.getController("cooSize").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("cooSize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);
}


void group2_1Design(Group group2_1) {

  myp5.addButton("showSphere")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_1)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg) 
    .setLabel("show")                       //button text content
    .setColorLabel(barText)        //button font color
    ;

  myp5.addSlider("sphereSize")
    .setRange(1, 2.6)
    .setPosition(95, 5)                
    .setSize(75, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
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
    .setColorForeground(color(#fff100))
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
    .setColorForeground(color(#fff100))
    .setLabel("color")              //slider text content
    .setGroup(group2_1)
    ;
  myp5.getController("scolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("scolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-55);
}


void group2_2Design(Group group2_2) {
  myp5.addButton("showLine")
    .setPosition(5, 5)   //(5,5) to top left conner
    .setSize(30, 10)
    .setGroup(group2_2)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("show")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addSlider("lineLen")
    .setRange(50, 100)
    .setPosition(90, 5)                
    .setSize(80, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
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
    .setColorForeground(color(#fff100))
    .setLabel("Line color")              //slider text content
    .setGroup(group2_2)
    ;
  myp5.getController("lcolor").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("lcolor").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-50);
}

void group2_3Design(Group group2_3) {
  myp5.addSlider("separateMagnitude")
    .setRange(1, 15)
    .setPosition(45, 5)
    .setSize(125, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
    .setLabel("separate")              
    .setGroup(group2_3)
    ;
  myp5.getController("separateMagnitude").getValueLabel().align(ControlP5.RIGHT, ControlP5.RIGHT_OUTSIDE).setPaddingX(-27);
  myp5.getController("separateMagnitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-42);

  myp5.addSlider("cohesionMagnitude")
    .setRange(0.01, 2)
    .setPosition(45, 20)
    .setSize(125, 10)
    .setColorBackground(barbg)
    .setColorForeground(color(#fff100))
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
    .setColorForeground(color(#fff100))
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
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("++ 200")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add100")
    .setPosition(55, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)  
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg).setLabel("++ 100")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add010")
    .setPosition(105, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("++ 010")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("add001")
    .setValue(0)
    .setPosition(155, 5)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("++ 001")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove200")
    .setValue(0)
    .setPosition(5, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("-- 200")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove100")
    .setValue(0)
    .setPosition(55, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("-- 100")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove010")
    .setValue(0)
    .setPosition(105, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("-- 010")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;

  myp5.addButton("remove001")
    .setValue(0)
    .setPosition(155, 20)   //(5,5) to top left conner
    .setSize(40, 10)
    .setGroup(group3)
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("-- 001")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;
}

void  group4Design(Group group4) {

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
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("send / Pause Data")                       //button text content
    .setColorLabel(color(0))        //button font color
    ;
}

void group5Design(Group group5) {
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
    .setColorBackground(color(#fff100))
    .setColorForeground(barbg)
    .setLabel("Save Image")                       //button text content
    .setColorLabel(color(0))        //button font color
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
void add200() {
  addBall(200);
}
void add100() {
  addBall(100);
}
void add010() {
  addBall(10);
}
void add001() {
  addBall(1);
}
void remove200() {
  removeBall(200);
}
void remove100() {
  removeBall(100);
}
void remove010() {
  removeBall(10);
}
void remove001() {
  removeBall(1);
}
void ip(String theString) {
  ipAddress = theString;
}
void port(String theString) {
  portName = theString;
}
void message(String theString) {
  initMessage = theString;
}
void sendDataPause() {
  sendData = !sendData;
  if (sendData)setupOsc();
}

void fpath(String theString) {
  path = theString;
}
void fname(String theString) {
  name = theString;
}
void saveimg() {
  captureImg();
}

void monitoring(float x, float y) {
  pushStyle();
  textAlign(LEFT);
  textSize(10);
  textMode(SHAPE);
  noStroke();
  pushMatrix();
  translate(x, y);
  fill(panelColor);
  rect(0, 0, 200, 35);
  fill(color(#fff100));
  rect(5, 5, 100, 10);
  rect(5, 20, 100, 10);
  fill(barbg);
  rect(110, 5, 85, 10);
  rect(110, 20, 85, 10);
  rect(0, -10, 200, 9);
  fill(barText);
  strokeWeight(0.1);
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
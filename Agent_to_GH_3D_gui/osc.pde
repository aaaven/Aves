import oscP5.*;
import netP5.*;
OscP5 oscP5; 
NetAddress myBroadcastLocation;
OscMessage arrayMsg; 
String toSend_;
String ipAddress = "10.209.12.21", portName = "6881", initMessage = "/array"
  ;
void setupOsc() {
  oscP5 = new OscP5(this, 6881); 
  myBroadcastLocation = new NetAddress(ipAddress, int(portName));
  arrayMsg = new OscMessage(initMessage);
}


void initData() {
  toSend_ ="";
  arrayMsg = new OscMessage(initMessage);
}

void updateData(Ball theBall, int index, int len) {
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
void sendData() {

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
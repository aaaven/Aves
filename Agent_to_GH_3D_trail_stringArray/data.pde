import oscP5.*;
import netP5.*;
OscP5 oscP5; 
NetAddress myBroadcastLocation;
OscMessage arrayMsg = new OscMessage("/array"); 
String toSend_;
ArrayList<String> history;
int historyLength = 200;
void setupOsc() {
  oscP5 = new OscP5(this, 6881); 
  myBroadcastLocation = new NetAddress("172.26.101.105", 6881);
  history = new ArrayList();
}

void initData() {
  toSend_ ="";
  arrayMsg=new OscMessage("/array");
}

void updateData(Ball theBall, int index, int len) {
  toSend_ += "{";
  toSend_ += theBall.pos.x;
  toSend_ += ",";
  toSend_ += theBall.pos.y;
  toSend_ += ",";
  toSend_ += theBall.pos.z;
  toSend_ += "}";
  if (index < len-1) {
    toSend_ += "|";
  }
}

void sendData() {
  //println(toSend_);
  //toSend_ format:{}|{}|{}|{}|{}|{}|{}
  //toSend_ content: balls arraylist pos vector
  arrayMsg.add(toSend_); 
  oscP5.send(arrayMsg, myBroadcastLocation); //this is the actual command that sends the message
  history.add(toSend_);
  if(history.size()>historyLength+1){
  history.remove(0);
  }
}
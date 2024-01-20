import processing.serial.*;
Serial serialPort;
import processing.video.*;
import processing.sound.*;

SoundFile sound;




int NUM_OF_VALUES_FROM_ARDUINO = 7;
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];
int prev_arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];
int x=600;
int y=300;
float size1 = 0;


float[] xs = new float[10000];
float[] ys = new float[10000];
float[] sizes = new float[10000];

int cidx = 0;

int currentScene = 0;

PImage[] images = new PImage[12];
int currentIndex = 0;
float imageSize = 0;
int bgidx = 1;
int p_S = 0;



void setup() {
  size(1366, 850);
  printArray(Serial.list());
  
  sound = new SoundFile(this, "song.mp3");
  sound.loop();


  images[0] = loadImage("mainpage.png");
  images[1] = loadImage("p1.jpeg");//zhuomian\
  
  images[2] = loadImage("p2.png");//lanmeizhuomian
  images[3] = loadImage("p3.png");//juzizhuomian
  images[4] = loadImage("p4.png");// caomeizhuomian
  
  images[5] = loadImage("p5.png");// lanmei bishua
  images[6] = loadImage("p6.png");//juzi bishua
  images[7] = loadImage("p7.png");// caomei bishua
  
  images[8] = loadImage("pa1.png"); //lanmei pattern
  images[9] = loadImage("pa2.png"); //juzi pattern
  images[10] = loadImage("pa3.png"); // caomei patterm
  
  images[11] = loadImage("last.png"); //jiewei
  for (int i = 0; i < 12; i++) {
    images[i].resize(1366, 850);
  }



  serialPort = new Serial(this, "/dev/cu.usbmodem11101", 9600);
}


void draw() {
  getSerialData();


  if (currentScene == 0) {
    scene0();
  } else if (currentScene == 1) {
    chooseBGS();
  } else if (currentScene == 2) {
    gameScene(bgidx);
  } else if (currentScene == 3) {
    closescene();
  }

  for (int i=0; i < NUM_OF_VALUES_FROM_ARDUINO; i++) {
    prev_arduino_values[i] = arduino_values[i];
  }
}

int lastTriggered = 0;
int p_b = 0;

void scene0() {
  getSerialData();
  int button = arduino_values[6];
  background(images[0]);
  //image(images[0], 0, 0, 1366, 1024);
  if (button != p_b && button ==1)  {
  currentScene = 1;
  delay(500);
  //lastTriggered = millis();
  }
    p_b = button;

  //if (lastTriggered != 0 && millis()-lastTriggered > 1000) {
  //  currentScene = 1;
  //}
}

int pleft6 = 0;
int pright7 = 0;

void chooseBGS() {
  getSerialData();
  int left6 = arduino_values[3];
  int right7 = arduino_values[4];
  int startv = arduino_values[6];
  background(images[1]);



  textSize(64);
  text(bgidx, 900, 330);
  fill(255, 0, 0);



  if (startv != 1) {
    if (arduino_values[3] == 1 && prev_arduino_values[3] == 0) {
    }
    if (left6 == 1 && pleft6 == 0) {
      bgidx  = bgidx - 1;
    }
    if (right7 == 1 && pright7 == 0) {
      bgidx = bgidx + 1;
    }
    if (bgidx >3) {
      bgidx = 1;
    }
    if (bgidx <1) {
      bgidx = 3;
    }
    pleft6 = left6;
    pright7 = right7;
  } else if (startv == 1 && p_b == 0) {
    currentScene = 2;
    delay(500);
  }
  p_b = startv;
}


void gameScene(int bgidx) {

  getSerialData();

  int color1 = arduino_values[0];
  int up4 = arduino_values[1];
  int down5 = arduino_values[2];
  int left6 = arduino_values[3];
  int right7 = arduino_values[4];
  int center8 = arduino_values[5];
  int startv = arduino_values[6];


  size1 = map(color1, 0, 1023, 50, 250);
  //color c1 = color(255, 0, 0); // 红色
  //color c2 = color(0, 0, 255); // 紫色



  background(images[bgidx+1]);
  penbrush(x, y, bgidx, size1+10);
  println(cidx);

  if (center8 == 1) {
    if (cidx < xs.length) {
      xs[cidx] = x;
      ys[cidx] = y;
      sizes[cidx] = size1;
      cidx++;
    }
  }


  for (int i = 0; i < cidx; i++) {
    pattern(xs[i], ys[i], sizes[i], bgidx);
  }

  if (x < 0){
    x = 0;
  }
  if (x > 1360){
    x = 1360;
  }
  if (y<0){
    y = 0;
  }
  if (y> 850){
    y= 850;
  }


  if (up4 == 1) {
    y -= 15;
  }
  if (down5 == 1) {
    y += 15;
  }
  if (left6 == 1) {
    x -= 15;
  }
  if (right7 == 1) {
    x += 15;
  }
  if (startv == 1 && p_b ==0) {
    currentScene = 3;
    /*
    for (int i = 0; i < cidx; i++) {
     
     sizes[cidx]=0;
     xs[i]=-100;
     ys[i]=-100;
     }
     */
    cidx = 0;
    delay(500);
  }
  p_b = startv;
}


void closescene() {
  getSerialData();
  int startv = arduino_values[6];

  //image(images[3], 0, 0, 1366, 1024);
  background(images[11]);
  if (startv == 1 && p_b == 0) {
  
    currentScene = 0;
    //p_b = 0;
    delay(300);
  }
  p_b = startv;
}




void penbrush(int cx, int cy, int idx, float size1) {
  imageMode(CENTER);
  image(images[idx+4], cx, cy, size1, size1);
}





void pattern(float cx, float cy, float size1, int idx) {
  imageMode(CENTER);
  image(images[idx+7], cx, cy, size1+30, size1+30);
}




void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
    if (in != null) {
      print("From Arduino: " + in);
      String[] serialInArray = split(trim(in), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          arduino_values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}

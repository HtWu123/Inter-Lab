int x = 0;
int y = 0;
int c = 0;
int button = 0;

const int Trig = 13;
const int Echo = 7;
int distance,time;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(Trig, OUTPUT);
  pinMode(Echo, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  int sensor0 = analogRead(A0);  //滑动变阻器
  int up = digitalRead(8);
  int down = digitalRead(9);
  int left = digitalRead(10);
  int right = digitalRead(11);
  int center = digitalRead(12);


  digitalWrite(Trig, LOW);
  delayMicroseconds(2);
  digitalWrite(Trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trig, LOW);
  time = pulseIn(Echo, HIGH);  
  distance = time / 58-2;

  if (distance > 15){
    button = 0;
    //Serial.print("11111");
    //Serial.print(distance);
    
  }
  else if (distance <= 15 && distance > 0){
    button = 1;
  }

//Serial.println(distance);
  Serial.print(sensor0);
  Serial.print(",");  // put comma between sensor values
  Serial.print(up);
  Serial.print(",");  // add linefeed after sending the last sensor value
  Serial.print(down);
  Serial.print(",");  // put comma between sensor values
  Serial.print(left);
  Serial.print(",");  // add linefeed after sending the last sensor value
  Serial.print(right);
  Serial.print(",");  // put comma between sensor values
  Serial.print(center);
  Serial.print(",");  // add linefeed after sending the last sensor value
  Serial.print(button);
  Serial.println();


  delay(30);
}

// import libraries needed for Arduino and OSC
import processing.serial.*;
import cc.arduino.*;
import oscP5.*;

Arduino arduino; // declare object
OscP5 oscP5; // declare object


//Emotional State
public float frustration = 0; // holds the value incoming from EPOC. Black.
public float excitement = 0; // holds the value incoming from EPOC. Yellow.

//Facial Recognition
public float smile = 0; // holds the value incoming from EPOC. Green.
public float clench = 0; // holds the value incoming from EPOC. Blue.

//Mental Commands
public float push = 0; // holds the value incoming from EPOC. Flower closes. Dim white.
public float pull = 0; // holds the value incoming from EPOC. Flower blooms. Red.

//Ambient Lighting
int redLED = 9; // LED connected to Arduino pin 13
int greenLED = 10; // LED connected to Arduino pin 10
int blueLED = 11; // LED connected to Arduino pin 9

int i = 0; //loop counter
int wait = 1000; // 1000ms delay for fade

int motor = 3; // motor connected to Arduino pin 3. Enable.
int motor_dir = 12; // motor connected to Arduino pin 12. Direction.

int electricimp_cat = 13; //elctric imp pin 1 is connected here.
int electricimp_dispense = 8;// pin 2 on electric imp

 //initialize colors
public int redVal = 0;
public int greenVal = 0;
public int blueVal = 0;

// actuator threshold
public float moveUp = 0.5;
public float moveDown = 0.5;

void setup() {
  println(Arduino.list()); // look for available Arduino boards
  // start Arduino communication at 57,600 baud
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  
  // set LED as output pin
  arduino.pinMode(redLED, arduino.OUTPUT);
  arduino.pinMode(blueLED, arduino.OUTPUT);
  arduino.pinMode(greenLED, arduino.OUTPUT);
  
  //set electric imp control pin as output
  arduino.pinMode(electricimp_cat, arduino.OUTPUT);
  arduino.pinMode(electricimp_dispense, arduino.OUTPUT);
   
  
  //set motors
  arduino.pinMode(motor, arduino.OUTPUT); arduino.digitalWrite(motor, arduino.LOW);
  arduino.pinMode(motor_dir, arduino.OUTPUT); arduino.digitalWrite(motor_dir, arduino.LOW);
  arduino.analogWrite(motor, 0); // motor 1 off
  
  
  
  // start oscP5, listening for incoming messages on port 7400
  // make sure this matches the port in Mind Your OSCs
  oscP5 = new OscP5(this, 7400);
  
  // plug the messages for the Cognitive values
  oscP5.plug(this,"getFrustration","/AFF/Frustration"); // Black
  oscP5.plug(this,"getExcitement","/AFF/Excitement"); // Yellow
  oscP5.plug(this,"getSmile","/EXP/SMILE"); // Black
  oscP5.plug(this,"getClench","/EXP/CLENCH"); // Yellow
  oscP5.plug(this,"getPush","/COG/PUSH"); // Up
  oscP5.plug(this,"getPull","/COG/PULL"); // Down
}
  
  

void draw() {
  /* the following block evaluates incoming EPOC values and if it is 
  greater than or equal to .5 */
  
  if(frustration >= 0.5) {
    fade("red");
    arduino.digitalWrite(electricimp_cat, arduino.HIGH); //drive electic imp pin 1 high
  } else if (frustration <= 0.3) {
    arduino.digitalWrite(electricimp_cat, arduino.LOW);
  } else if (excitement >=0.5) {
    fade("yellow");
  } else if (smile >=0.6) {
    fade("green");
    arduino.digitalWrite(electricimp_dispense, arduino.HIGH);
    } else if (smile <=0.3) {
    fade("red");
    arduino.digitalWrite(electricimp_dispense, arduino.LOW);
  } else if (push >=0.3|| pull>=0.3) {
    fade("blue");
  } else {
    fade("white");
  }
  
  // evaluate thresholds and enable or stop motors
  /*if(push >= moveUp) {
  flowerClose();
  } else if(pull >= moveDown) {
  flowerBloom();
  } else {
  stopAll();
  }
  
  if(smile >=0.5) {
    arduino.digitalWrite(redLED, arduino.LOW);
    } else if (clench >=0.5) {
    arduino.digitalWrite(redLED, arduino.HIGH);
    } else {
    
  }*/
  
}

/* the following function updates with any incoming OSC messages for /COG/DISAPPEAR/, plugged
in setup() */
void getFrustration (float theValue) {
  frustration = theValue;
  println("OSC message received; new frustration value: "+frustration);
}

void getExcitement (float theValue) {
  excitement = theValue;
  println("OSC message received; new excitement value: "+excitement);
}

void getSmile (float theValue) {
  smile = theValue;
  println("OSC message received; new smile value: "+smile);
}

void getClench (float theValue) {
  clench = theValue;
  println("OSC message received; new clench value: "+clench);
}

void getPush (float theValue) {
  push = theValue;
  println("OSC message received; new push value: "+push);
}

void getPull (float theValue) {
  pull = theValue;
  println("OSC message received; new pull value: "+pull);
}

// Methods for motor control
public void flowerClose() {
  arduino.digitalWrite(motor_dir, arduino.LOW);
  arduino.analogWrite(motor, 255);
}

public void flowerBloom() {
  arduino.digitalWrite(motor_dir, arduino.HIGH);
  arduino.analogWrite(motor, 255);
}


public void stopAll() {
  //arduino.digitalWrite(motor_dir, arduino.LOW);
  //arduino.digitalWrite(motor2_dir, arduino.LOW);
 // arduino.analogWrite(motor, 0);
 // arduino.analogWrite(motor2, 0);
}


//Mood lighting
void fade(String colorName){
  if (colorName.equals("red") == true){
    setColor(255,0,0);
  } else if(colorName.equals("yellow") == true){
    setColor(255,255,0);
  } else if(colorName.equals("green") == true){
    setColor(0,255,0);
  } else if(colorName.equals("blue") == true){
    setColor(0,0,255);
  } else if(colorName.equals("white") == true){
    setColor(0,255,255);
  } else{
}
}


void setColor(int redVal,int greenVal,int blueVal) {
  
    arduino.analogWrite(redLED, redVal);   // Write current values to LED pins
    arduino.analogWrite(greenLED, greenVal);      
    arduino.analogWrite(blueLED, blueVal); 

    delay(wait); // Pause for 'wait' milliseconds before resuming the loop\
  }

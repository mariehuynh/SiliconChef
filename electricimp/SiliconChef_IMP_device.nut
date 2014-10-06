button <- hardware.pin1;
candybutton <- hardware.pin2;

// These values may be different for your servo
const SERVO_MIN = 0.03;
const SERVO_MAX = 0.1;
 
// create global variable for servo and configure
servo <- hardware.pin7;
servo.configure(PWM_OUT, 0.02, SERVO_MIN);
 
// expects a value between 0.0 and 1.0
function setServo(value) {
  local scaledValue = value * (SERVO_MAX-SERVO_MIN) + SERVO_MIN;
  servo.write(scaledValue);
}
 
// expects a value between -80.0 and 80.0
function SetServoDegrees(value) {
  local scaledValue = (value + 81) / 161.0 * (SERVO_MAX-SERVO_MIN) + SERVO_MIN;
  servo.write(scaledValue);
}
 
// current position (we'll flip between 0 and 1)
position <- 0;
 
function buttonPress() 
{
    local state = button.read();
    if (state == 1) 
    {
                server.log("Stressed detected from Arduino");
        agent.send("stressed", 0);
        
    } else 
    {
        
        
    }
}

function candy(){
    
        local state = button.read();
            server.log("Candy dispensing");
    if (state == 1) 
    {
    setServo(1.0);
    imp.sleep(0.7);
    setServo(0.0);
    }
}
 
// Configure the button to call buttonPress() when the pin's state changes
 
button.configure(DIGITAL_IN_PULLUP, buttonPress);
candybutton.configure(DIGITAL_IN_PULLUP, candy);
candy();

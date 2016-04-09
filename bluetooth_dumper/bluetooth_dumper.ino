#include <IRremote.h>
#include <Arduino.h>

/* 
*  Default is Arduino pin D11. 
*  You can change this to another available Arduino Pin.
*  Your IR receiver should be connected to the pin defined here
*/

#include <SoftwareSerial.h>

SoftwareSerial mySerial(8, 7); // RX, TX

int RECV_PIN = A0; 
 
IRrecv irrecv(RECV_PIN);

decode_results results;

void setup()
{
  //Serial.begin(9600);
  mySerial.begin(9600);
  delay(500);
  mySerial.println("AT+NAME=infra-strike");
  delay(100);
  mySerial.println("AT+PSWD=1234567890");
  irrecv.enableIRIn(); // Start the receiver
}

void loop() {
  if (irrecv.decode(&results)) {
    mySerial.println(results.value, HEX);
    irrecv.resume(); // Receive the next value
  }
}
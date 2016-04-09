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
  Serial.begin(9600);
  mySerial.begin(9600);
  irrecv.enableIRIn(); // Start the receiver
}


void dump(decode_results *results) {
  // Dumps out the decode_results structure.
  // Call this after IRrecv::decode()
  int count = results->rawlen;
  if (results->decode_type == UNKNOWN) {
    mySerial.print("Unknown encoding: ");
  }
  else if (results->decode_type == NEC) {
    mySerial.print("Decoded NEC: ");

  }
  else if (results->decode_type == SONY) {
    mySerial.print("Decoded SONY: ");
  }
  else if (results->decode_type == RC5) {
    mySerial.print("Decoded RC5: ");
  }
  else if (results->decode_type == RC6) {
    mySerial.print("Decoded RC6: ");
  }
  else if (results->decode_type == PANASONIC) {
    mySerial.print("Decoded PANASONIC - Address: ");
    mySerial.print(results->address, HEX);
    mySerial.print(" Value: ");
  }
  else if (results->decode_type == LG) {
    mySerial.print("Decoded LG: ");
  }
  else if (results->decode_type == JVC) {
    mySerial.print("Decoded JVC: ");
  }
  else if (results->decode_type == AIWA_RC_T501) {
    mySerial.print("Decoded AIWA RC T501: ");
  }
  else if (results->decode_type == WHYNTER) {
    mySerial.print("Decoded Whynter: ");
  }
  mySerial.print(results->value, HEX);
  mySerial.print(" (");
  mySerial.print(results->bits, DEC);
  mySerial.println(" bits)");
  mySerial.print("Raw (");
  mySerial.print(count, DEC);
  mySerial.print("): ");

  for (int i = 1; i < count; i++) {
    if (i & 1) {
      mySerial.print(results->rawbuf[i]*USECPERTICK, DEC);
    }
    else {
      Serial.write('-');
      mySerial.print((unsigned long) results->rawbuf[i]*USECPERTICK, DEC);
    }
    mySerial.print(" ");
  }
  mySerial.println();
}

void loop() {
  if (irrecv.decode(&results)) {
    mySerial.println(results.value, HEX);
    dump(&results);
    irrecv.resume(); // Receive the next value
  }
}

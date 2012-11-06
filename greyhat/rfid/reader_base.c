#include <Keypad.h>
#include <stdio.h>
#include <EEPROM.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/sleep.h>

// uncomment the following line to get debug information dumped
//#define SERIALDEBUG


/***************************************************************************
 *                                                                         *
 *  A Universal RFID Key - Instructables Version                           *
 *                                                                         *
 *   Copyright (C) 2010  Doug Jackson (doug@doughq.com)                    *
 *   Modified by John Menerick (www.securesql.info)                                                                      *
 ***************************************************************************
 *                                                                         * 
 * This program is free software; you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation; either version 2 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program; if not, write to the Free Software             *
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,                   *
 * MA  02111-1307  USA                                                     *
 *                                                                         *
 ***************************************************************************
 *                                                                         *
 *    * * * * * * * *      W A R N I N G     * * * * * * * * * *           *
 * This project implements what is effectively a universal skeleton key    *
 * for use on a range of RFID access systems.  It is presented for         *
 * educational and demonstration purposes only to enable others to learn   *
 * about the design and limitations of RFID technologies.                  *
 *                                                                         *
 * The Author is not responsible for misuse of the technological system    *
 * implemented by this software - USE AT YOUR OWN RISK!!                   *
 *                                                                         *
 ***************************************************************************
 *
 * 
 * Revision History
 * 
 * Date  	By	What
 * 20101002	DRJ	Initial Creation of Arduino Version 
 * 20101024     DRJ     Added facility to arbitrarily enter a facility and 
 *                      UserID number
 * 20101025     DRJ     Added ability to enter decimal UserID
 * 20101124     DRJ     Removed my Work specific functions for public release
 ***************************************************************************
 * 
 *  COMMAND STRUCTURE
 *
 * Mode key is pressed until appropriate mode is displayed on 4 upper leds
 * Enter key triggers action
 *
 * Mode 1 - Sleep (power down till next reset)
 * Mode 2 - Allow HEX facility code to be entered 
 *          2 decimal characters are then read into facility[] array;
 * Mode 3 - Allow Decimal userID to be entered
 *          8 decimal characters are then read into user[] array;
 * Mode 4 - Dump data - Facility code and User code are output on 4 LEDs one byte at a time
 * Mode 5 - Emulate Card
 *
 *
 *************************************************************************************/

#define DATALED1 3
#define DATALED2 2
#define DATALED3 1
#define DATALED4 0
#define STATUSLED1 13
#define STATUSLED2 9

// the Coil is connected to Analog 5 = Digital 19
#define COIL 19


const byte ROWS = 5; //five rows
const byte COLS = 4; //four columns
char keys[ROWS][COLS] = {
  {
    '1','2','3','A'                  }
  ,
  {
    '4','5','6','B'                  }
  ,
  {
    '7','8','9','C'                  }
  ,
  {
    '*','0','#','D'                  }
  ,
  {
    'N','M','F','E'                  }
  ,

};
byte rowPins[ROWS] = {
  10, 11, 8, 17, 15}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {
  12, 7, 16, 18}; //connect to the column pinouts of the keypad

byte facility[2]={ 0x02, 0x0C };
byte cardID[8]={ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
int colsum[4]={ 0,0,0,0}; // storage for the column checksums

// delay between symbols when we are transmitting
int bittime=256;

byte RFIDdata[128];


Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

int clock=0;  // storage for the current state of our clock signal.

byte datapointer=0;
byte state;
byte mode=1;


void setup()
{

  pinMode(DATALED1, OUTPUT); 
  pinMode(DATALED2, OUTPUT); 
  pinMode(DATALED3, OUTPUT);  
  pinMode(DATALED4, OUTPUT); 
  pinMode(STATUSLED1, OUTPUT); 
  pinMode(STATUSLED2, OUTPUT); 


  pinMode(COIL, OUTPUT);
  //Start with it LOW  
  digitalWrite(COIL, LOW);

  if (EEPROM.read(0)==0xa5)
  {
      facility[0]=EEPROM.read(1);
      facility[1]=EEPROM.read(2);
      
      cardID[0]=EEPROM.read(3);
      cardID[1]=EEPROM.read(4);
      cardID[2]=EEPROM.read(5);
      cardID[3]=EEPROM.read(6);
      cardID[4]=EEPROM.read(7);
      cardID[5]=EEPROM.read(8);
      cardID[6]=EEPROM.read(9);
      cardID[7]=EEPROM.read(10);
  }
  else
 {
    EEPROM.write(0,0xa5);
    facility[0]=0x02; EEPROM.write(1,facility[0]);  
    facility[1]=0x0c; EEPROM.write(2,facility[1]);
      for (int i=0; i<8; i++) 
    {
      cardID[i]=0; EEPROM.write(i+2,cardID[i]);
    }
  }
    

    #ifdef SERIALDEBUG 
    Serial.begin(9600);  
    delay(200);
    Serial.println("  ");
    Serial.println("RFID Spoofer (c) 2010 D Jackson"); 
    #endif
}

void WriteHeader(void)
{
  // a header consists of 9 one bits
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1;  
  RFIDdata[datapointer++]=1;  
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1; 
  RFIDdata[datapointer++]=1; 
}


void WriteData(byte nibble)
{
  byte data;
  byte rowsum=0;
  for (int i=4; i>0; i--)
  {
    if ((nibble& 1<<i-1) ==0)  
    {
      data=0; 
    }
    else 
    {
      data=1;
      rowsum++;  // increment the checksum value
      colsum[i-1]++; // increment the column checksum
    }


    RFIDdata[datapointer++]= data;
    #ifdef SERIALDEBUG 
      Serial.print((int) data); 
    #endif
     
  }
  // write the row checksum out
  if ((rowsum%2)==0)  
  {
    RFIDdata[datapointer++]=0; 
    #ifdef SERIALDEBUG 
      Serial.print((int)0); 
    #endif
    
  }
  else
  {  
    RFIDdata[datapointer++]=1; 
    #ifdef SERIALDEBUG 
      Serial.print((int)1); 
    #endif
  }

    #ifdef SERIALDEBUG 
      Serial.println(); 
    #endif

}


void WriteChecksum(void)
{
  byte data;
  byte rowsum=0;
  for (int i=4; i>0; i--)
  {
    if ((colsum[i-1]%2) ==0)  
    {
      RFIDdata[datapointer++]=0; 
     #ifdef SERIALDEBUG 
      Serial.print((int)0); 
     #endif
    }
    else
    {
      RFIDdata[datapointer++]=1; 
      #ifdef SERIALDEBUG 
      Serial.print((int) 1); 
      #endif
    }  
  }

  // write the stop bit
  RFIDdata[datapointer++]=0; 

      #ifdef SERIALDEBUG 
      Serial.print((int)0); 
      #endif

}





void BuildCard(void)
{
  // load up the RFID array with card data
  // intitalise the write pointer
  datapointer=0;

  WriteHeader();
  // Write facility
  WriteData(facility[0]);
  WriteData(facility[1]);
 
  // Write cardID
  WriteData(cardID[0]);
  WriteData(cardID[1]);
  WriteData(cardID[2]);
  WriteData(cardID[3]);
  WriteData(cardID[4]);  
  WriteData(cardID[5]);
  WriteData(cardID[6]);  
  WriteData(cardID[7]);

  WriteChecksum();
}


void TransmitManchester(int cycle, int data)
{

  if(cycle ^ data == 1)
  {
    digitalWrite(COIL, HIGH);
  }
  else
  {
    digitalWrite(COIL, LOW);  
  }
}




void writedataLEDS(int temp)
{
  if (temp & 1<<0) digitalWrite(DATALED1,HIGH); 
  else digitalWrite(DATALED1,LOW);
  if (temp & 1<<1) digitalWrite(DATALED2,HIGH); 
  else digitalWrite(DATALED2,LOW);
  if (temp & 1<<2) digitalWrite(DATALED3,HIGH); 
  else digitalWrite(DATALED3,LOW);
  if (temp & 1<<3) digitalWrite(DATALED4,HIGH); 
  else digitalWrite(DATALED4,LOW);   

}



void EmulateCard(void)
{
  #ifdef SERIALDEBUG 
  Serial.println("Emulate Card Entered"); 
  #endif  // enter a low power modewritedataLEDS(0);  // turn off the LEDs
  
  BuildCard();
  
  #ifdef SERIALDEBUG 
  Serial.println(); 
  for(int i = 0; i < 64; i++)
  {
    if (RFIDdata[i]==1) Serial.print("1"); 
    else if (RFIDdata[i]==0) Serial.print("0"); 
    else Serial.print((int)RFIDdata[i]); 
  } 
  Serial.println(); 
  #endif  
  

  while (1==1)
  {
    for(int i = 0; i < 64; i++)
    {
      TransmitManchester(0, RFIDdata[i]);
      delayMicroseconds(bittime);
      TransmitManchester(1, RFIDdata[i]);
      delayMicroseconds(bittime); 
    } 
  }
}

void PowerDown(void)
{
  #ifdef SERIALDEBUG 
  Serial.println("Sleep Mode Entered"); 
  #endif  // enter a low power mode
 
  writedataLEDS(0);  // turn off the LEDs

  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_enable();
  sleep_mode();
}





void DumpData(void)
{
  #ifdef SERIALDEBUG 
  Serial.println("Dump Data Entered"); 
  #endif  
  
  // dump the facility and card codes.
  writedataLEDS(0);  // turn off the data LEDs
  for (int i=0; i<2; i++)
  {  
    digitalWrite(STATUSLED1,HIGH);   
    writedataLEDS(facility[i]);
    delay(2000);   
    digitalWrite(STATUSLED1,LOW);
    delay(500); 
  }
  writedataLEDS(0);  // turn off the data LEDs
  digitalWrite(STATUSLED1,LOW);

  for (int i=0; i<8; i++)
  {  
    digitalWrite(STATUSLED2,HIGH);
    writedataLEDS(cardID[i]);
    delay(2000);   
    digitalWrite(STATUSLED2,LOW);
    delay(500); 
  }
  digitalWrite(STATUSLED2,LOW);
  writedataLEDS(mode);
}



void LoadFacility(void)
{
  char key;
  byte temp;

  #ifdef SERIALDEBUG 
  Serial.println("LoadFacility Entered"); 
  #endif  
  
  writedataLEDS(0);  // turn off the data LEDs
  for (int i=0; i<2; i++)
  {  
    writedataLEDS(facility[i]);
    // wait for a keypress
    key = NO_KEY;
    while (key == NO_KEY){
      delay(50);
      key = keypad.getKey();
    }
    switch (key){
      case '0': temp=0; break;
      case '1':  temp=1; break;
      case '2':  temp=2; break;
      case '3':  temp=3; break;
      case '4':  temp=4; break;
      case '5':  temp=5; break;
      case '6':  temp=6; break;
      case '7':  temp=7; break;
      case '8':  temp=8; break;
      case '9':  temp=9; break;
      case 'A':  temp=0x0a; break;
      case 'B':  temp=0x0b; break;
      case 'C':  temp=0x0c; break;
      case 'D':  temp=0x0d; break;
      case 'E':  temp=0x0e; break;
      case 'F':  temp=0x0f; break;
    }   

    digitalWrite(STATUSLED1,HIGH);   
    facility[i]=temp;

    writedataLEDS(facility[i]);
    delay(200);   
    writedataLEDS(0);
    delay(200);   
    writedataLEDS(facility[i]);
    delay(200);
  } 

  writedataLEDS(mode);
  digitalWrite(STATUSLED1,LOW);
  delay(100);
  digitalWrite(STATUSLED1,HIGH);
  for (int i=0; i<2; i++) EEPROM.write(i+1,facility[i]);
  delay(200);
  digitalWrite(STATUSLED1,LOW);
}



void LoadCardID(void){
  char tempchar[9];  // temporary storage for decimal to int conversion
  char key;
  byte temp;
  long decimalval;
 
  #ifdef SERIALDEBUG 
  Serial.println("LoadDecimalCardID Entered");
  #endif
  
  writedataLEDS(0);  // turn off the data LEDs
  for (int i=0; i<8; i++)
  {  
    // wait for a keypress
    key = NO_KEY;
    while (key == NO_KEY){
      delay(50);
      key = keypad.getKey();
    }
    
    tempchar[i]=key;
    
    digitalWrite(STATUSLED2,HIGH);   

    writedataLEDS(tempchar[i]);
    delay(200);   
  } 

  tempchar[8]='\n';
  #ifdef SERIALDEBUG 
    Serial.print("datastring="); Serial.println(tempchar);
  #endif
  decimalval=atol(tempchar);
  #ifdef SERIALDEBUG 
   Serial.print("datalong="); Serial.println((unsigned long)decimalval);
  #endif
   
  sprintf(tempchar,"%4.4X",(decimalval & 0xffff));
  #ifdef SERIALDEBUG 
   Serial.print("dataHEXLO="); 
   Serial.println(tempchar);
  #endif
  for (int i=4; i<8; i++) cardID[i]=asciitohex(tempchar[i-4]);
  
  decimalval = ((decimalval & 0xffff0000) >> 16);
  sprintf(tempchar,"%4.4X",decimalval);
  #ifdef SERIALDEBUG 
   Serial.print("dataHEXHi="); 
   Serial.print(tempchar);
  #endif
  for (int i=0; i<4; i++) cardID[i]=asciitohex(tempchar[i]);
 
  writedataLEDS(mode);
  digitalWrite(STATUSLED2,LOW);
  delay(100);
  digitalWrite(STATUSLED2,HIGH);
  for (int i=0; i<8; i++) EEPROM.write(i+3,cardID[i]);
  delay(200);
  digitalWrite(STATUSLED2,LOW);
}


char asciitohex(char value)  {
    char temp;
    switch (value){
      case '0':  temp=0; break;
      case '1':  temp=1; break;
      case '2':  temp=2; break;
      case '3':  temp=3; break;
      case '4':  temp=4; break;
      case '5':  temp=5; break;
      case '6':  temp=6; break;
      case '7':  temp=7; break;
      case '8':  temp=8; break;
      case '9':  temp=9; break;
      case 'A':  temp=0x0a; break;
      case 'B':  temp=0x0b; break;
      case 'C':  temp=0x0c; break;
      case 'D':  temp=0x0d; break;
      case 'E':  temp=0x0e; break;
      case 'F':  temp=0x0f; break;
    }   
   return temp;
}

   






void loop(void)
{
  char key = keypad.getKey();

  if (key != NO_KEY){

    if (key=='M') {  
      mode++;
      if (mode>5) mode=1;
      writedataLEDS(mode);
      delay(100);
      Serial.print("Mode="); 
      Serial.println((int)mode);
    }

    if (key=='N')  {   // enter key pressed - dofunction
      switch (mode){
      case 1:
        PowerDown();    // power down mode 
        break;
      case 2:
        LoadFacility(); // allow user to enter facility data
        break;
      case 3:
        LoadCardID();   // allow user to enter the card id
        break;
      case 4:
        DumpData();     // display the card data
        break;
      case 5: 
        EmulateCard();  // start card emulation
        break;
      } 
      #ifdef SERIALDEBUG 
       Serial.println(key); 
      #endif  
    }
  }
}

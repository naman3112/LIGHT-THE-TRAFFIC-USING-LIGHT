
//********************************* HEADER FILES **************************************************************************

#include <ESP8266WiFi.h>                                                    // esp8266 library
#include <FirebaseArduino.h>                                                // firebase library
#define FIREBASE_HOST "counter-jnc.firebaseio.com"                          // the project name address from firebase id
#define FIREBASE_AUTH "z8GVajaYti6vQIgrnn7a99lWL2perqxkDFzblql0"            // the secret key generated from firebase
#define WIFI_SSID "BOUNCE-GUEST"                                             // input your home or public wifi name 
#define WIFI_PASSWORD "Wel@Bounce"                                    //password of wifi ssid              
#include <DNSServer.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h>    


//***************************************************************************************************************************

#define trigger_pin1  D1
#define echo_pin1  D2 
int time1;
int  distance1; 
int counter1=0 ;
int gate1=0;
int shut1=0;
//*---------------------------------------------- ultrSONIC 1 pins ********************************************************

#define trigger_pin2 D3  
#define echo_pin2  D4
int time2;
int  distance2; 
int counter2=0 ;
int gate2=0;
int shut2=0;
// ------------------------------------------------ultrSONIC 2 pins ********************************************************


#define trigger_pin3  D5
#define echo_pin3  D6 
int time3;
int  distance3; 
int counter3=0 ;
int gate3=0;
int shut3=0;
//------------------------------------------------ ultrSONIC 3 pins ********************************************************



#define trigger_pin4  D7
#define echo_pin4  D8 
int time4;
int  distance4; 
int counter4=0 ;
int gate4=0;
int shut4=0;
//------------------------------------------------- ultrSONIC 4 pins ********************************************************


//********* counting function for ultrasonic 1******************************************************************************
void uscount1(){
  int check1=0;
    digitalWrite (trigger_pin1, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin1, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin1, LOW);
    time1 = pulseIn (echo_pin1, HIGH);
    distance1 = (time1 * 0.034) / 2;
    
       if(distance1<gate1)
           { int temp;
               temp=distance1;
               while(1)
                 {  
                    digitalWrite (trigger_pin1, HIGH);
                      delayMicroseconds (10);
                       digitalWrite (trigger_pin1, LOW);
                       time1 = pulseIn (echo_pin1, HIGH);
                        temp = (time1 * 0.034) / 2;
                        
                    if(temp!=distance1)
                      {
                         if(temp==gate1) 
                          
                           {
                            Serial.println("gate 1 is//////////////////////////////////// ");
 
                            Serial.println(gate1);
                            Serial.println("temp is ***********************************");
                            Serial.println(temp);
                            counter1++;
                        Serial.println("counter  1 is ----------------------------------------");
                        Serial.println(counter1);
                        break;
                           }
                                                 
                        
                          
                          else{
                            Serial.println("chech and shut respectively");
                            shut1=2;
                            return;
                      }
                 }
               delay(100);
               }
           }
}// END
//****************************** end of ultrasonic sensor 1 counting function ********************************************


//************************ start of ultrasonic sensor 2 counting function ********************************************
void uscount2(){
  int check2=0;
    digitalWrite (trigger_pin2, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin2, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin2, LOW);
    time2 = pulseIn (echo_pin2, HIGH);
    distance2 = (time2 * 0.034) / 2;
    
       if(distance2<gate2)
           { int temp;
               temp=distance2;
               while(1)
                 {  Firebase.setFloat("gate2", gate2);
                    digitalWrite (trigger_pin2, HIGH);
                      delayMicroseconds (10);
                       digitalWrite (trigger_pin2, LOW);
                       time2 = pulseIn (echo_pin2, HIGH);
                        temp = (time2 * 0.034) / 2;
                        
                    if(temp!=distance2)
                      {
                         if(temp==gate2) 
                          
                           {
                            Serial.println("gate 2 is//////////////////////////////////// ");
 
                            Serial.println(gate2);
                            Serial.println("temp is ***********************************");
                            Serial.println(temp);
                            counter2++;
                        Serial.println("counter  2 is ----------------------------------------");
                        Serial.println(counter2);
                        break;
                           }
                                                 
                        
                          
                          else{
                            Serial.println("chech and shut respectively");
                            shut2=2;
                            return;
                      }
                 }
               delay(100);
               }
           }
}// END




//****************************** end of ultrasonic sensor 2 counting function ********************************************




//************************ start of ultrasonic sensor 3 counting function ********************************************
void uscount3(){
  int check3=0;
    digitalWrite (trigger_pin3, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin3, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin3, LOW);
    time3 = pulseIn (echo_pin3, HIGH);
    distance1 = (time1 * 0.034) / 2;
    
       if(distance3<gate3)
           { int temp;
               temp=distance3;
               while(1)
                 {  
                    digitalWrite (trigger_pin3, HIGH);
                      delayMicroseconds (10);
                       digitalWrite (trigger_pin3, LOW);
                       time1 = pulseIn (echo_pin3, HIGH);
                        temp = (time1 * 0.034) / 2;
                        
                    if(temp!=distance3)
                      {
                         if(temp==gate3) 
                          
                           {
                            Serial.println("gate 3 is//////////////////////////////////// ");
 
                            Serial.println(gate3);
                            Serial.println("temp is ***********************************");
                            Serial.println(temp);
                            counter1++;
                        Serial.println("counter  3 is ----------------------------------------");
                        Serial.println(counter3);
                        break;
                           }
                                                 
                        
                          
                          else{
                            Serial.println("chech and shut respectively");
                            shut3=2;
                            return;
                      }
                 }
               delay(100);
               }
           }
}// END




//****************************** end of ultrasonic sensor 3 counting function ********************************************





//************************ start of ultrasonic sensor 4 counting function ********************************************
void uscount4(){
  int check4=0;
    digitalWrite (trigger_pin4, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin4, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin4, LOW);
    time1 = pulseIn (echo_pin4, HIGH);
    distance1 = (time1 * 0.034) / 2;
    
       if(distance1<gate4)
           { int temp;
               temp=distance4;
               while(1)
                 {  
                    digitalWrite (trigger_pin4, HIGH);
                      delayMicroseconds (10);
                       digitalWrite (trigger_pin4, LOW);
                       time1 = pulseIn (echo_pin4, HIGH);
                        temp = (time1 * 0.034) / 2;
                        
                    if(temp!=distance4)
                      {
                         if(temp==gate4) 
                          
                           {
                            Serial.println("gate 4 is//////////////////////////////////// ");
 
                            Serial.println(gate4);
                            Serial.println("temp is ***********************************");
                            Serial.println(temp);
                            counter1++;
                        Serial.println("counter  4 is ----------------------------------------");
                        Serial.println(counter4);
                        break;
                           }
                                                 
                        
                          
                          else{
                            Serial.println("chech and shut respectively");
                            shut4=2;
                            return;
                      }
                 }
               delay(100);
               }
           }
}// END

//****************************** end of ultrasonic sensor 4 counting function ********************************************


void setup() {
  
  // put your setup code here, to run once:

//******************** SERIAL MONITOR *************************************************************************
Serial.begin(9600);

    
 //*********************** wifi connection ************************************************************************
      // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
    
//*************************************fire base ***************************************************************
    Serial.println("fire base started");
     Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);                              // connect to firebase
     if (Firebase.failed()) {
      Serial.print("setting /number failed:");
      Serial.println(Firebase.error());  
      return;
  }

//**************************************************************************************************************


//*********************************************************************************************************************
   //*******************************************ULTRASONIC SETUP PINS*****************************************************

   
   counter1 = 0; 
   pinMode (trigger_pin1, OUTPUT); 
   pinMode (echo_pin1, INPUT);     

   //************************************************************************************************************************

//************************************* Setting up the counter *************************************************************
for(int i=0;i<5;i++)
{
digitalWrite (trigger_pin1, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin1, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin1, LOW);
    time1 = pulseIn (echo_pin1, HIGH);
    gate1 = (time1 * 0.034) / 2;
    Serial.println("gate1 ");
    Serial.println(gate1);
delay(1000);
}
//**************************************************************************************************************************

//*********************************************************************************************************************
   //*******************************************ULTRASONIC 2 SETUP PINS*****************************************************
   counter2 = 0; 
   pinMode (trigger_pin2, FUNCTION_1); 
   pinMode (echo_pin2, FUNCTION_1);     
   pinMode (trigger_pin2, OUTPUT); 
   pinMode (echo_pin2, INPUT);     
   
   
   //************************************************************************************************************************

//************************************* Setting up the counter *************************************************************
for(int i=0;i<5;i++)
{
  
digitalWrite (trigger_pin2, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin2, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin2, LOW);
    time2 = pulseIn (echo_pin2, HIGH);
    gate2 = (time2 * 0.034) / 2;
    Serial.println("gate - 2  ");
    Serial.println(gate2);
Firebase.setFloat("gate2", gate2);

delay(1000);

}
//**************************************************************************************************************************
//*********************************************************************************************************************
   
   
   //*******************************************ULTRASONIC SETUP 3 PINS*****************************************************
   counter3 = 0; 
   pinMode (trigger_pin3, OUTPUT); 
   pinMode (echo_pin3, INPUT);     

   //************************************************************************************************************************

//************************************* Setting up the counter *************************************************************
for(int i=0;i<5;i++)
{
digitalWrite (trigger_pin3, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin3, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin3, LOW);
    time3 = pulseIn (echo_pin3, HIGH);
    gate3 = (time3 * 0.034) / 2;
    Serial.println("gate  3 ");
    Serial.println(gate3);
delay(1000);
}
//**************************************************************************************************************************

//*********************************************************************************************************************
   //*******************************************ULTRASONIC SETUP 4 PINS*****************************************************
   delay(2000);
   counter4 = 0; 
   pinMode (trigger_pin4, OUTPUT); 
   pinMode (echo_pin4, INPUT);     

   //************************************************************************************************************************

//************************************* Setting up the counter *************************************************************
for(int i=0;i<5;i++)
{
digitalWrite (trigger_pin4, LOW);
    delayMicroseconds (10);  
    digitalWrite (trigger_pin4, HIGH);
    delayMicroseconds (10);
    digitalWrite (trigger_pin4, LOW);
    time4 = pulseIn (echo_pin4, HIGH);
    gate4 = (time4 * 0.034) / 2;
    Serial.println("gate 4 ");
    Serial.println(gate4);
delay(1000);
}
//**************************************************************************************************************************
}


int res;


void loop() {

   // Firebase.setString("light","any");

  res=-1;  
  
  shut1=0;
  shut2=0;
  shut3=0;
  shut4=0;
  
  
  // put your main code here, to run repeatedly:

  //*********************** CALLING COUNTING FUNCTION FOR DATA COLLECTION BY THE SENSORS*****************************
                
                 uscount3();
                 uscount2();        
                  uscount4();
                  uscount1();
                 
                 
//**********************************DEcision making *************************************************************
    
    
   //------------------------ FIRST  SENSOR IS SHUT DOWN -------------------------------------------------------- 
    if(shut1>=2&&shut2<=2&&shut3<=2&&shut4<=2){
       res=1;
    }
  //----------------------------------------------------------------------------------------------------------------


  //-------------------------------- FIRST AND SECOND SENSOR SHUT DOWN --------------------------------------------
    if(shut1>=2&&shut4>=2)
           {
            res=2;
           }
   //-------------------------------------------------------------------------------------------------------------------
    
//-------------------------------- FIRST, SECOND,AND THIRD  SENSOR SHUT DOWN --------------------------------------------

    if(shut4>=2&&shut1>=2&&shut3>=2)
    {
      res=3;
    }
   
   //------------------------------------------------------------------------------------------------------------------- 
  
  //-------------------------------- FIRST,SECOND,THIRD AND FOURTH SENSOR SHUT DOWN --------------------------------------------

  if(shut4>=2&&shut1>=2&&shut3>=2){
                    res=4;     
  }

   //-------------------------------------------------------------------------------------------------------------------
  
  
  
  //****************** initialising the variAlbe for anothier fuunction call***************************************
counter1=0;
counter2=0;
counter3=0;
counter4=0;
//*****************************************************************************************************************
  
 //****************************** better decision ****************************************************************
  
      
       
       Serial.println("priority of the traffic is ");
       Serial.println(res);


 Firebase.setFloat("prior",res);
       
  //***************************************************************************************************************
  if(res==0)
  {
    res=0;
      Firebase.setFloat("timer", res);
  }
  
  if(res==1)
  {
    res=10;
      Firebase.setFloat("timer", res);
  }
   if(res==2)
   {
    res=15;
      Firebase.setFloat("timer", res);
   }
   if(res==3)
   {
    res=20;
      Firebase.setFloat("timer", res);
   }
   if(res==4)
   {    res=25;
      Firebase.setFloat("timer", res);
   }
   if(res==5)
  {
    res=30;
  Firebase.setFloat("timer", res);


  }
   

  //******************* SENDING DECISION TO FIREBASE***************************************************************
 
//******************************************************************************************************************  


}

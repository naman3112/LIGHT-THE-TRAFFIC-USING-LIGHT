 

#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN         D1          // Configurable, see typical pin layout above
#define SS_PIN          D2         // Configurable, see typical pin layout above

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance

// Set these to run example.
#define FIREBASE_HOST "counter-jnc.firebaseio.com"
#define FIREBASE_AUTH "z8GVajaYti6vQIgrnn7a99lWL2perqxkDFzblql0"
#define WIFI_SSID "hji"                                             // input your home or public wifi name 
#define WIFI_PASSWORD "HARICHAND"      
void setup() {
  Serial.begin(115200);

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
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  SPI.begin();      // Init SPI bus
  mfrc522.PCD_Init();   // Init MFRC522
  mfrc522.PCD_DumpVersionToSerial();
}

int n = 0;

void loop() {
  // set bool value
  Firebase.setBool("truth", false);
  // handle error
  
  if (Firebase.failed()) {
    Serial.print("setting /truth failed:");
    Serial.println(Firebase.error());
    return;
  }
yo :
  if ( ! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }

  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  bool k=true;
  Firebase.setBool("truth", k);
  // handle error
  if (Firebase.failed()) {
    Serial.print("setting /truth failed:");
    Serial.println(Firebase.error());
    return;
  }
  delay(1000);
  if(k==true){
  goto yo; 
  
  }
  
  mfrc522.PICC_DumpToSerial(&(mfrc522.uid));
// mfrc522.PICC_HaltA();
}

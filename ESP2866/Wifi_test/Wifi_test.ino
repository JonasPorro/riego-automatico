#include <FS.h>
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ArduinoJson.h>          //https://github.com/bblanchon/ArduinoJson

//needed for library
#include <ESP8266WebServer.h>
#include <DNSServer.h>
#include <WiFiManager.h>          // by  https://github.com/kentaylor/WiFiManager
#include "DHT.h"
#include <Ticker.h>
#include <AsyncMqttClient.h>

// Constants

#define Config_Network 5 //     /// BUTTON Config Wifi
#define Led_No_Config_Network 14 // GPIO D5   /// LED No Config Wifi  ///  RED Rojo
#define DHTPIN D2
#define DHTTYPE DHT11 // DHT 11
#define MQTT_HOST IPAddress(192, 168, 10, 111)
#define MQTT_PORT 1883
#define MQTT_PUB_HUM "lecturas"

// Variables

// Indicates whether ESP has WiFi credentials saved from previous session
bool initialConfig = false;
float Humidity;
uint8_t DHTPin = 2;
DHT dht(DHTPin, DHTTYPE);
AsyncMqttClient mqttClient;
Ticker mqttReconnectTimer;

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

// Setup function
void setup() {
  // Put your setup code here, to run once
  Serial.begin(115200);
  Serial.println("\n Starting");


  pinMode(Config_Network, INPUT_PULLUP); 
  pinMode(Led_No_Config_Network, OUTPUT);
  
  mqttClient.setServer(MQTT_HOST, MQTT_PORT);
  
  WiFi.printDiag(Serial); //Remove this line if you do not want to see WiFi password printed

  if (WiFi.SSID() == "") {
    Serial.println("We haven't got any access point credentials, so get them now");
    initialConfig = true;
    digitalWrite(Led_No_Config_Network, HIGH);
 
  } else {
        
 
    WiFi.mode(WIFI_STA); 
    unsigned long startedAt = millis();
    Serial.print("After waiting ");
    int connRes = WiFi.waitForConnectResult();
    float waited = (millis()- startedAt);
    Serial.print(waited/1000);
    Serial.print(" secs in setup() connection result is ");
    Serial.println(connRes);
  }

    if (WiFi.status()!=WL_CONNECTED){
    Serial.println("Failed to connect, finishing setup anyway");
  } else{
    Serial.print("Local ip: ");
    Serial.println(WiFi.localIP());
  }
  
  dht.begin();


}

// Loop function

void loop() {


  
  // is configuration portal requested? /// button 
  if ( (digitalRead(Config_Network) == HIGH) || (initialConfig)) {  
      
    digitalWrite(Led_No_Config_Network, HIGH); // Turn LED off as we are not in configuration mode.        
    Serial.println("Configuration portal requested");    


        
    WiFiManager wifiManager;           
    wifiManager.setConfigPortalTimeout(180);  ///// reset esp8266 180 seg
    

    WiFiManagerParameter custom_text("<p>Test for PDAControl Excellent </p>");
    wifiManager.addParameter(&custom_text);

     ////Nota: Requiere mas .. funciones para capturar parametros!!!!! .............. Note: Requires more .. functions to capture parameters!!!!
      //  char mqtt_server[40]="PDAControl apikey example";
      //  WiFiManagerParameter custom_mqtt_server("server", "my parameters", mqtt_server, 40); 
      //  wifiManager.addParameter(&custom_mqtt_server);

     /////////////////////////////////////////////////////////////////////////////
     ///  wifiManager.setCustomHeadElement("<style>html{filter: invert(100%); -webkit-filter: invert(100%);}</style>");
     /////////////////
   
    wifiManager.startConfigPortal("EcoRiego Station", "ecoriego");    

    ESP.reset(); // This is a bit crude. For some unknown reason webserver can only be started once per boot up 
    // so resetting the device allows to go back into config mode again when it reboots.
    delay(2500);
  } 
  digitalWrite(Led_No_Config_Network, LOW);

  // Configuration portal not requested, so run normal loop
  // Put your main code here, to run repeatedly...
  /////////////////////////////////BEGIN  loop  -  INICIA  loop ////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //mqttClient.connect();
  Humidity = dht.readHumidity();
  Serial.print(F("Humidity: "));
  Serial.print(Humidity);
  //uint16_t packetIdPub2 = mqttClient.publish(MQTT_PUB_HUM, 1, true, String(Humidity).c_str());

  delay(5000);

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// End loop   --       fin de codigo////////////////////////////////////////////////////////////////////////////

}





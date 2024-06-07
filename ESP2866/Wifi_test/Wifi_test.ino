#include <FS.h>
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ArduinoJson.h>          //https://github.com/bblanchon/ArduinoJson

//needed for library
#include <ESP8266WebServer.h>
#include <DNSServer.h>
#include <WiFiManager.h>          // by  https://github.com/kentaylor/WiFiManager
#include <DHT11.h>
#include <MQTT.h>

// Constants

#define Config_Network 5 //     /// BUTTON Config Wifi
#define Led_No_Config_Network 14 // GPIO D5   /// LED No Config Wifi  ///  RED Rojo
#define DHTPIN 2

// Variables

// Indicates whether ESP has WiFi credentials saved from previous session
bool initialConfig = false;
float humidity;
DHT11 dht11(2);
MQTTClient client;
WiFiClient net;

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

void connect_mqtt() {
  Serial.print("\nconnecting...");
  while (!client.connect("ESP8266", true)) {
    Serial.print(".");
    delay(1000);
  }

  Serial.println("\nconnected!");

  client.subscribe("/lecturas");
}

// Setup function
void setup() {
  // Put your setup code here, to run once
  Serial.begin(115200);
  Serial.println("\n Starting");


  pinMode(Config_Network, INPUT_PULLUP); 
  pinMode(Led_No_Config_Network, OUTPUT);
  
  client.begin(IPAddress(192,168,10,111), net);

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
    connect_mqtt();
  }

    if (WiFi.status()!=WL_CONNECTED){
    Serial.println("Failed to connect, finishing setup anyway");
  } else {
    Serial.print("Local ip: ");
    Serial.println(WiFi.localIP());
  }
}

// Loop function

void loop() {
  // is configuration portal requested? /// button 
  if ( (digitalRead(Config_Network) == HIGH) || (initialConfig)) {  
    
    digitalWrite(Led_No_Config_Network, HIGH); // Turn LED off as we are not in configuration mode.        
    Serial.println("Configuration portal requested");    

    WiFiManager wifiManager;           
    wifiManager.setConfigPortalTimeout(180);  ///// reset esp8266 180 seg

    WiFiManagerParameter custom_text("<p>Configuración EcoRiego</p>");
    wifiManager.addParameter(&custom_text);
    wifiManager.startConfigPortal("EcoRiego Station", "ecoriego");

    ESP.reset(); // This is a bit crude. For some unknown reason webserver can only be started once per boot up 
    // so resetting the device allows to go back into config mode again when it reboots.
    delay(2500);
    connect_mqtt();
  }

  digitalWrite(Led_No_Config_Network, LOW);

  // Configuration portal not requested, so run normal loop
  
  /////////////////////////////////BEGIN  loop  -  INICIA  loop ////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (WiFi.SSID() != ""){
    if (!client.connected()) {
      connect_mqtt();
    }

    humidity = dht11.readHumidity();
    if (humidity != DHT11::ERROR_CHECKSUM && humidity != DHT11::ERROR_TIMEOUT) {
      Serial.print("Humidity: ");
      Serial.print(humidity);
      client.publish("/lecturas", String(humidity));
    } else {
      // Print error message based on the error code.
      Serial.println(DHT11::getErrorString(humidity));
    }

    delay(5000);
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// End loop   --       fin de codigo////////////////////////////////////////////////////////////////////////////
}





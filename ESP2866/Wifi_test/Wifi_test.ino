#include <FS.h>
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <ArduinoJson.h>          //https://github.com/bblanchon/ArduinoJson

//needed for library
#include <ESP8266WebServer.h>
#include <DNSServer.h>
#include <WiFiManager.h>          // by  https://github.com/kentaylor/WiFiManager
#include <DHT11.h>
#include <PubSubClient.h>

// Constants

#define Config_Network 5 //     /// BUTTON Config Wifi
#define Led_No_Config_Network 14 // GPIO D5   /// LED No Config Wifi  ///  RED Rojo
#define DHTPIN 2

// Variables

// Indicates whether ESP has WiFi credentials saved from previous session
const char* mqtt_server = "192.168.10.111";
bool initialConfig = false;
int humidity;
DHT11 dht11(2);
WiFiClient espClient;
PubSubClient client(espClient);
char cstr[16];
WiFiManager wifiManager; 
int contador = 0;

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

void connect_mqtt() {
  Serial.print("\nconnecting...");
  client.connect("ESP8266");
  delay(1000);
  Serial.print(client.state());
  if (client.connected()) {
    Serial.println("\nconnected!");
    client.subscribe("lecturas");
  } else {
    Serial.println(WiFi.localIP());
  }
}

void config_panel() {
  digitalWrite(Led_No_Config_Network, HIGH); // Turn LED off as we are not in configuration mode.        
  Serial.println("Configuration portal requested");    
  
  wifiManager.setConfigPortalTimeout(180);  // reset esp8266 180 seg

  WiFiManagerParameter custom_text("<p>Configuración EcoRiego</p>");
  wifiManager.addParameter(&custom_text);
  wifiManager.startConfigPortal("EcoRiego Station");
  
  delay(2500);
  digitalWrite(Led_No_Config_Network, LOW);
  initialConfig = false;
}

void ICACHE_RAM_ATTR isr() {
  initialConfig = true;
}

// Setup function
void setup() {
  Serial.begin(115200);
  Serial.println("\n Starting");


  pinMode(Config_Network, INPUT_PULLUP); 
  attachInterrupt(Config_Network, isr, FALLING);

  pinMode(Led_No_Config_Network, OUTPUT);
  client.setServer(mqtt_server, 1883);

  if (wifiManager.getWiFiIsSaved()){
    if(!wifiManager.autoConnect("EcoRiego Station")){
      digitalWrite(Led_No_Config_Network, HIGH);
    }
  } else {
    initialConfig = true;
  }
}

// Loop function
void loop() {
  // is configuration portal requested? /// button 
  if (initialConfig) {  
    config_panel();
  }

  // Configuration portal not requested, so run normal loop
  
  /////////////////////////////////BEGIN  loop  -  INICIA  loop ////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (WiFi.status() == WL_CONNECTED){
    if (!client.connected()) {
      connect_mqtt();
    }

    humidity = dht11.readHumidity();
    if (humidity != DHT11::ERROR_CHECKSUM && humidity != DHT11::ERROR_TIMEOUT) {
      Serial.print("Humidity: ");
      Serial.print(humidity);
      client.publish("lecturas", itoa(humidity, cstr, 10));
    } else {
      // Print error message based on the error code.
      Serial.println(DHT11::getErrorString(humidity));
    }

    while (!initialConfig && (contador < 300000)){
      delay(1);
      contador = contador + 1;
    }
    contador = 0;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// End loop   --       fin de codigo////////////////////////////////////////////////////////////////////////////
}





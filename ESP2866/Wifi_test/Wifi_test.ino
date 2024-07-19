#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#include <WiFiUdp.h>              //https://github.com/esp8266/Arduino
#include <FS.h>                   //https://github.com/esp8266/Arduino
#include <DNSServer.h>            //https://github.com/esp8266/Arduino
#include <ESP8266WebServer.h>     //https://github.com/esp8266/Arduino
#include <ArduinoJson.h>          //https://github.com/bblanchon/ArduinoJson
#include <WiFiManager.h>          //https://github.com/kentaylor/WiFiManager
#include <DHT11.h>                //https://github.com/dhrubasaha08/DHT11
#include <PubSubClient.h>         //https://pubsubclient.knolleary.net/

// Constants

#define Config_Network 5 //     /// BUTTON Config Wifi
#define Led_No_Config_Network 14 // GPIO D5   /// LED No Config Wifi  ///  Rojo
#define Led_Connected_Network 12 // GPIO D6   /// LED conectado Wifi  ///  Amarillo
#define sensor_pin A0

// Variables varias
const char* PARAM_FILE = "/param.txt"; // File path in SPIFFS

// Variables mqtt
char mqtt_server[40] = "";
char client_id_mqtt[40] = "";
WiFiClient espClient;
PubSubClient client(espClient);
char message[40];

// Variables sensor
int humidity;
char cstr[16];

// Variables wifimanager
WiFiManager wifiManager; 
bool initialConfig = false;
WiFiManagerParameter client_id("client_id", "Nombre estacion (OBGLIGATORIO): ", "", 40);

// Variables UDP
WiFiUDP udp;
unsigned int localPort = 5005;

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

void buscarMqttServer(){
  udp.begin(localPort);
  char incomingPacket[255]; // Buffer for incoming packets
  Serial.println("Looking for a mqtt server");
  while (!initialConfig && strlen(mqtt_server) == 0){
    Serial.print(".");
    int packetSize = udp.parsePacket();
    
    if (packetSize) {
      // We've received a packet, read the data
      int len = udp.read(incomingPacket, 255);
      if (len > 0) {
        incomingPacket[len] = 0; // Null-terminate the string
      }

      // Check if the packet contains the specific keyword
      if (strstr(incomingPacket, "EcoriegoBase") != NULL) {
        strcpy(mqtt_server, &incomingPacket[13]);
        digitalWrite(Led_No_Config_Network, LOW); 
        return;
      }
    }

    int contador = 0;

    while (!initialConfig && (contador < 2500)){
      delay(1);
      if (contador == 0 || contador == 1250){
        digitalWrite(Led_No_Config_Network, HIGH);
      } else if (contador == 625 || contador == 1875){
        digitalWrite(Led_No_Config_Network, LOW); 
      }
      contador = contador + 1;
    }
    contador = 0;
  }
}

void saveParamToSPIFFS(const char* param) {
  File f = SPIFFS.open(PARAM_FILE, "w");
  if (!f) {
    Serial.println("Failed to open file for writing");
    return;
  }
  f.print(param);
  f.close();
}

int loadParamFromSPIFFS() {
  if (!SPIFFS.exists(PARAM_FILE)) {
    Serial.println("No parameter file found");
    return 1;
  }
  File f = SPIFFS.open(PARAM_FILE, "r");
  if (!f) {
    Serial.println("Failed to open file for reading");
    return 2;
  }
  size_t size = f.size();
  if (size > sizeof(client_id_mqtt)) {
    Serial.println("Parameter file size is too large");
    f.close();
    return 3;
  }
  f.readBytes(client_id_mqtt, size);
  client_id_mqtt[size] = '\0'; // Ensure null-termination
  f.close();
  return 0;
}

void connect_mqtt() {
  if (strlen(mqtt_server) == 0){
    buscarMqttServer();
    Serial.println("Server encontrado: ");
    Serial.print(mqtt_server);
  }
  client.setServer(mqtt_server, 1883);
  Serial.print("\nconnecting...");
  client.connect(client_id_mqtt);
  delay(1000);
  Serial.print(client.state());
  if (client.connected()) {
    Serial.println("\nconnected!");
    client.subscribe("lecturas");
  }
}

void config_panel() {
  digitalWrite(Led_No_Config_Network, HIGH); // Turn LED on as we are in configuration mode.        
  Serial.println("Configuration portal requested");    
  
  wifiManager.startConfigPortal("EcoRiego Station");
  
  delay(2500);
  
  digitalWrite(Led_No_Config_Network, LOW);
  initialConfig = false;
  if (strlen(client_id.getValue()) != 0){
    saveParamToSPIFFS(client_id.getValue());
  }
  loadParamFromSPIFFS();
}

void ICACHE_RAM_ATTR isr() {
  initialConfig = true;
}

// Setup function
void setup() {
  Serial.begin(115200);
  Serial.println("\n Starting");

  pinMode(Config_Network, INPUT); 
  attachInterrupt(Config_Network, isr, FALLING);

  pinMode(Led_No_Config_Network, OUTPUT);
  pinMode(Led_Connected_Network, OUTPUT);
  
  // Initialize SPIFFS
  if (!SPIFFS.begin()) {
    Serial.println("Failed to mount file system");
    return;
  }

  wifiManager.setConfigPortalTimeout(180);  // reset esp8266 180 seg
  wifiManager.addParameter(&client_id);

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
    
    digitalWrite(Led_Connected_Network, HIGH);

    // Print the custom parameter to the Serial
    if (strlen(client_id_mqtt) == 0){
      if (loadParamFromSPIFFS() != 0){
        config_panel();
      }
    }

    if (!client.connected()) {
      connect_mqtt();
    }

    humidity = analogRead(sensor_pin);
    humidity = map(humidity,736,490,0,100); 
    if (humidity != DHT11::ERROR_CHECKSUM && humidity != DHT11::ERROR_TIMEOUT && strlen(client_id_mqtt) != 0) {
      Serial.println("Humidity: ");
      strcpy(message, client_id_mqtt);
      strcat(message, "|");
      strcat(message, itoa(humidity, cstr, 10));
      Serial.print(message);
      //
      client.publish("lecturas",message);
    } else if (strlen(client_id_mqtt) == 0) {
      Serial.println("No hay client ID configurado.");
      config_panel();
    } else {
      // Print error message based on the error code.
      Serial.println(DHT11::getErrorString(humidity));
    }
    int contador = 0;

    while (!initialConfig && (contador < 10000)){
      delay(1);
      contador = contador + 1;
    }
    contador = 0;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////// End loop   --       fin de codigo////////////////////////////////////////////////////////////////////////////
}





import sqlite3
import paho.mqtt.client as mqtt
from datetime import datetime
import time

# Coonfiguración inicial
conn = sqlite3.connect('Riego_automatico.db')
cursor = conn.cursor()
nombreConfig = "config.txt"

# Función para manejar los mensajes MQTT recibidos
def on_message(client, userdata, msg):
    message = msg.payload.decode("utf-8") # MSJ De ejemplo: MED1|132
    datos = message.split("|")
    archivoConfig = open(nombreConfig, "r")
    umbral = int(archivoConfig.readline())
    tiempoActivo = int(archivoConfig.readline())
    archivoConfig.close()

    # Guardar medición en la base de datos
    cursor.execute("INSERT INTO MEDICION (FECHA_MEDICION, DISPOSITIVO, VALOR) VALUES (?, ?, ?)", (datetime.now(), datos[0], datos[1]))
    conn.commit()
    print("\nSe insertó " + message)

    
    if int(datos[1]) > umbral:
        print("Se prendió la bomba")
        time.sleep(tiempoActivo)
        print("Se apagó la bomba")
        

# Configuración del cliente MQTT
mqtt_topic = "lecturas"

client = mqtt.Client()
client.on_message = on_message

# Conexión al broker MQTT y suscripción al topic
client.connect("127.0.0.1", 1883, 60)
client.subscribe(mqtt_topic)

# Bucle de espera para recibir mensajes MQTT
client.loop_forever()

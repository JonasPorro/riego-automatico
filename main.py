from gpiozero import LED, OutputDevice
import paho.mqtt.client as mqtt
from datetime import datetime
import time
import socket
import threading

# Coonfiguración inicial
nombreConfig = "/var/www/html/web/config.txt"
nombreMedicion = "/var/www/html/web/mediciones.txt"
ledmsg = LED(18)
ledconn = LED(17)
relay_pin = 4
relay = OutputDevice(relay_pin, active_high=True, initial_value=False)

def get_local_ip():
    # Function to get the local IP address
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Doesn't need to be reachable
        s.connect(('10.254.254.254', 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip

def check_connection():
    while True:
        ip = get_local_ip()
        if ip != '127.0.0.1':
            ledconn.on()
        else:
            ledconn.off()
        time.sleep(10)  # Verificar cada 10 segundos

def broadcast_ip(ip, port=5005):
    broadcast_address = '<broadcast>'  # Broadcast to all addresses in the local network
    message = f"EcoriegoBase|{ip}"
    
    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    try:
        while True:
            # Send the message
            sock.sendto(message.encode('utf-8'), (broadcast_address, port))
            print(f"Broadcast message sent: {message}")
            time.sleep(30)  # Wait for 30 seconds before sending the next message
    except KeyboardInterrupt:
        print("Broadcast stopped")
    finally:
        sock.close()

def start_broadcast_thread():
    local_ip = get_local_ip()
    broadcast_thread = threading.Thread(target=broadcast_ip, args=(local_ip,))
    broadcast_thread.daemon = True  # This makes sure the thread will close when the main program exits
    broadcast_thread.start()

def start_ledconn_thread():
    ledconn_thread = threading.Thread(target=check_connection)
    ledconn_thread.daemon = True  # This makes sure the thread will close when the main program exits
    ledconn_thread.start()

# Función para manejar los mensajes MQTT recibidos
def on_message(client, userdata, msg):
    message = msg.payload.decode("utf-8") # MSJ De ejemplo: MED1|132
    datos = message.split("|")
    archivoConfig = open(nombreConfig, "r")
    archivoMedicion = open(nombreMedicion, "a")
    umbral = int(archivoConfig.readline())
    tiempoActivo = int(archivoConfig.readline())
    archivoConfig.close()

    # Guardar medición en la base de datos
    try:
        archivoMedicion.write(datetime.now().strftime("%m/%d/%Y, %H:%M:%S") + "|" + message + '\n')
        print("\nSe insertó " + message)
        archivoMedicion.close()
    except:
        print("\nNo se pudo insertar " + message)
    else:
        ledmsg.on()
        time.sleep(1)
        ledmsg.off()
    
    if int(datos[1]) < umbral:
        print("Se prendió la bomba")
        relay.on()
        time.sleep(tiempoActivo)
        print("Se apagó la bomba")
        relay.off()
        

# Configuración del cliente MQTT
mqtt_topic = "lecturas"

client = mqtt.Client()
client.on_message = on_message

# Conexión al broker MQTT y suscripción al topic
client.connect("127.0.0.1", 1883, 60)
client.subscribe(mqtt_topic)

# Empezar a hacer broadcast de la ip
start_broadcast_thread()
start_ledconn_thread()

# Bucle de espera para recibir mensajes MQTT
client.loop_forever()

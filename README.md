# 🌱 Eco Riego

**Eco Riego** es un sistema de riego automatizado alimentado con energía solar fotovoltaica, diseñado para optimizar el uso de agua en el cuidado de plantas. El sistema utiliza un **sensor de humedad** que, junto a una **Raspberry Pi 3**, permite medir el nivel de humedad de la tierra y activar automáticamente una bomba de agua cuando los niveles estén por debajo de los parámetros configurados por el usuario.

---

## 🚀 Características

- **Medición automática** del nivel de humedad cada hora.  
- **Activación inteligente** de la bomba de agua mediante un relé.  
- **Interfaz web** para monitorear datos y visualizar reportes gráficos.
- **Autonomía** de la estación de medición gracias a sus paneles solares.
- **Fácil configuración** ya que la base detecta automáticamente a la estación cuando están en la misma red wifi.
- **Configuración flexible** de:
  - Límite de humedad mínima.
  - Tiempo de riego de la bomba.  

---

## 🛠️ Tecnologías utilizadas

- **Raspberry Pi 3** para control y procesamiento.  
- **Sensor de humedad**.
- **ESP8266** para conectividad y transmisión de datos.
- **Base de datos** local para almacenamiento histórico de mediciones.  
- **Página web interna** para visualización gráfica.  
- **Protocolo MQTT** para comunicación de datos.

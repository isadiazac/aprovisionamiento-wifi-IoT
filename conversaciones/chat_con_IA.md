## Prompt Del Grupo

Eres un experto en IoT y en el desarrollo con ESP32. Quiero comprender cómo implementar un sistema en el que el ESP32 inicie como Access Point (AP) si no tiene credenciales guardadas, y luego se conecte automáticamente a una red Wi-Fi utilizando SSID y contraseña proporcionados por el usuario.

Por favor, explícame:

1. El funcionamiento general del sistema, incluyendo el flujo de estados desde AP hasta conexión a Internet.
2. Las librerías necesarias para implementar esta lógica en el entorno de Arduino.
3. Los pasos técnicos que debo seguir para desarrollar esta funcionalidad correctamente.

## Respuesta de Copilot M365

¡Claro, Mao! Aquí tienes una explicación completa y clara sobre cómo implementar un sistema en ESP32 que inicia como Access Point (AP) y luego se conecta a una red Wi-Fi usando credenciales proporcionadas por el usuario:

---

## 1. 🧠 Funcionamiento General del Sistema

El flujo de estados del ESP32 se puede describir así:

1. **Inicio del dispositivo**:
   - El ESP32 verifica si hay credenciales Wi-Fi guardadas en memoria no volátil (por ejemplo, usando `Preferences`).
   
2. **Modo Access Point (AP)**:
   - Si no hay credenciales, el ESP32 inicia en modo AP con un SSID fijo (ej. `ConfiguraESP32`).
   - Se levanta un servidor web que muestra un formulario para ingresar SSID y contraseña.

3. **Recepción de credenciales**:
   - El usuario envía el formulario.
   - Las credenciales se guardan en memoria no volátil.
   - El ESP32 se reinicia automáticamente.

4. **Conexión a red Wi-Fi**:
   - En el siguiente arranque, el ESP32 intenta conectarse a la red con las credenciales guardadas.
   - Si la conexión es exitosa, se levanta el servidor web con los endpoints disponibles.
   - Si falla, se borran las credenciales y se reinicia en modo AP nuevamente.

5. **Cambio de red Wi-Fi**:
   - Desde el endpoint `/change_wifi`, el usuario puede enviar nuevas credenciales.
   - El ESP32 guarda los nuevos datos y se reinicia para conectarse a la nueva red.

---

## 2. 📚 Librerías necesarias

Para implementar esta lógica en el entorno de Arduino, necesitas:

```cpp
#include <WiFi.h>              // Para manejar conexiones Wi-Fi
#include <WebServer.h>         // Para levantar el servidor web
#include <Preferences.h>       // Para guardar datos en memoria no volátil
#include <HTTPClient.h>        // Para hacer peticiones HTTP (como obtener chistes)
```

---

## 3. 🛠️ Pasos técnicos para desarrollar la funcionalidad

### 🔧 Preparación del entorno
- Instala el paquete de ESP32 en el IDE de Arduino.
- Crea un nuevo proyecto y configura el puerto y placa.

### 🧩 Implementación paso a paso

1. **Inicializar `Preferences`** para leer credenciales guardadas.
2. **Verificar si hay SSID y contraseña**:
   - Si existen, intentar conectar a la red.
   - Si no existen o la conexión falla, iniciar modo AP.
3. **Modo AP**:
   - Usar `WiFi.softAP(ssid, password)` para crear la red.
   - Levantar un `WebServer` en el puerto 80.
   - Mostrar formulario HTML para ingresar SSID y contraseña.
4. **Guardar credenciales**:
   - Usar `preferences.putString("ssid", ssid)` y `preferences.putString("password", password)`.
   - Reiniciar el ESP32 con `ESP.restart()`.
5. **Conexión a Wi-Fi**:
   - Usar `WiFi.begin(ssid, password)` y verificar estado con `WiFi.status()`.
   - Si se conecta, levantar el servidor con los endpoints `/`, `/change_wifi`, `/chiste`, etc.
6. **Cambio de red**:
   - Endpoint que recibe nuevas credenciales y repite el proceso de guardado y reinicio.

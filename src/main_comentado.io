#include <WiFi.h>          // Librería para manejar la conexión WiFi
#include <WebServer.h>     // Para montar un servidor web en el ESP32
#include <Preferences.h>   // Para guardar las credenciales en memoria no volátil (NVS)
#include <HTTPClient.h>    // Para hacer peticiones HTTP (lo uso en el chiste)

WebServer server(80);      // Creo el servidor en el puerto 80
Preferences preferences;   // Para manejar la memoria donde guardo SSID y password

// Datos de la red en modo AP (cuando el ESP no tiene credenciales guardadas)
const char* ap_ssid = "ConfiguraESP32";
const char* ap_password = "12345678";

// Página principal en modo AP (formulario para meter SSID y password)
void handleRoot() {
  String html = R"rawliteral(
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Configuración Wi-Fi</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #f2f2f2;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .container {
          background-color: white;
          padding: 30px;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0,0,0,0.1);
          width: 300px;
        }
        h2 {
          text-align: center;
          color: #333;
        }
        input[type="text"], input[type="password"] {
          width: 100%;
          padding: 10px;
          margin: 10px 0;
          border: 1px solid #ccc;
          border-radius: 5px;
        }
        input[type="submit"] {
          width: 100%;
          padding: 10px;
          background-color: #4CAF50;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
        }
        input[type="submit"]:hover {
          background-color: #45a049;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h2>¡Hola! Configura tu red Wi-Fi</h2>
        <form action='/save' method='POST'>
          <label for="ssid">SSID:</label>
          <input type="text" id="ssid" name="ssid" required>
          <label for="password">Contraseña:</label>
          <input type="password" id="password" name="password" required>
          <input type="submit" value="Enviar">
        </form>
      </div>
    </body>
    </html>
  )rawliteral";

  server.send(200, "text/html", html);
}

// Guardar los datos que recibo del formulario en memoria persistente
void handleSave() {
  String ssid = server.arg("ssid");
  String password = server.arg("password");

  preferences.begin("wifi", false);   // Abro espacio de memoria
  preferences.putString("ssid", ssid);
  preferences.putString("password", password);
  preferences.end();

  // Página de confirmación
  String html = R"rawliteral(
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Configuración Guardada</title>
      <style>
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background-color: #e0f7fa;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .message-box {
          background-color: #ffffff;
          padding: 30px;
          border-radius: 10px;
          box-shadow: 0 0 15px rgba(0,0,0,0.2);
          text-align: center;
        }
        h2 {
          color: #00796b;
        }
        p {
          color: #555;
        }
      </style>
    </head>
    <body>
      <div class="message-box">
        <h2> Datos guardados correctamente</h2>
        <p>El dispositivo se reiniciará en unos segundos para aplicar la configuración.</p>
      </div>
    </body>
    </html>
  )rawliteral";

  server.send(200, "text/html", html);
  delay(3000);
  ESP.restart();   // Reinicio el ESP para que arranque intentando conectarse a la red
}

// Página que se muestra cuando el ESP ya está conectado a WiFi
void handleHome() {
  String html = R"rawliteral(
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Bienvenido</title>
      <style>
        body {
          font-family: 'Segoe UI', sans-serif;
          background: linear-gradient(to right, #00c6ff, #0072ff);
          color: white;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
          margin: 0;
        }
        .welcome-box {
          text-align: center;
          background-color: rgba(0, 0, 0, 0.3);
          padding: 40px;
          border-radius: 15px;
        }
        h1 {
          font-size: 2.5em;
        }
        p {
          font-size: 1.2em;
        }
      </style>
    </head>
    <body>
      <div class="welcome-box">
        <h1>¡Bienvenido a tu dispositivo IoT!</h1>
        <p>Usa los endpoints para configurar tu red o divertirte con un chiste.</p>
      </div>
    </body>
    </html>
  )rawliteral";

  server.send(200, "text/html", html);
}

// Página para cambiar la red WiFi desde un formulario
void handleWiFiForm() {
  String html = R"rawliteral(
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Configurar Wi-Fi</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #f0f8ff;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .box {
          background-color: #ffffff;
          padding: 30px;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0,0,0,0.2);
          text-align: center;
        }
        input {
          padding: 10px;
          margin: 10px;
          width: 80%;
          border: 1px solid #ccc;
          border-radius: 5px;
        }
        button {
          background-color: #2e7d32;
          color: white;
          border: none;
          padding: 10px 20px;
          border-radius: 5px;
          cursor: pointer;
        }
        button:hover {
          background-color: #1b5e20;
        }
      </style>
    </head>
    <body>
      <div class="box">
        <h2>Configurar Wi-Fi</h2>
        <form action="/wifi-post" method="POST">
          <input type="text" name="ssid" placeholder="SSID" required><br>
          <input type="password" name="password" placeholder="Password" required><br>
          <button type="submit">Guardar</button>
        </form>
      </div>
    </body>
    </html>
  )rawliteral";

  server.send(200, "text/html", html);
}

// Recibe nuevas credenciales y reinicia el ESP
void handleChangeWiFi() {
  String ssid = server.arg("ssid");
  String password = server.arg("password");

  preferences.begin("wifi", false);
  preferences.putString("ssid", ssid);
  preferences.putString("password", password);
  preferences.end();

  String html = R"rawliteral(
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>Wi-Fi Actualizado</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          background-color: #f0fff0;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .box {
          background-color: #ffffff;
          padding: 30px;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0,0,0,0.2);
          text-align: center;
        }
        h2 {
          color: #2e7d32;
        }
      </style>
    </head>
    <body>
      <div class="box">
        <h2>Red Wi-Fi actualizada</h2>
        <p>Reiniciando para aplicar los cambios...</p>
      </div>
    </body>
    </html>
  )rawliteral";

  server.send(200, "text/html", html);
  delay(3000);
  ESP.restart();
}

// Endpoint para pedir un chiste (lo saco de una API externa)
void handleChiste() {
  HTTPClient http;
  http.begin("http://v2.jokeapi.dev/joke/Any?type=single"); // API de chistes
  int httpCode = http.GET();

  String joke = "No se pudo obtener el chiste ";

  if (httpCode == 200) {
    String payload = http.getString();
    int start = payload.indexOf("\"joke\":\"") + 8;
    int end = payload.indexOf("\"", start);
    joke = payload.substring(start, end);
  }

  http.end();

  String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Chiste</title><style>";
  html += "body{font-family:sans-serif;background:#fffbe6;display:flex;justify-content:center;align-items:center;height:100vh;}";
  html += ".box{background:#fff;padding:30px;border-radius:10px;box-shadow:0 0 10px rgba(0,0,0,0.1);text-align:center;}";
  html += "h2{color:#ff9800;}</style></head><body><div class='box'><h2>Chiste del día</h2><p>" + joke + "</p></div></body></html>";

  server.send(200, "text/html", html);
}

void setup() {
  Serial.begin(115200);

  // Leo credenciales guardadas
  preferences.begin("wifi", true);
  String ssid = preferences.getString("ssid", "");
  String password = preferences.getString("password", "");
  preferences.end();

  // Si ya tengo credenciales, intento conectarme
  if (ssid != "") {
    WiFi.begin(ssid.c_str(), password.c_str());
    Serial.print("Conectando a ");
    Serial.println("|" + ssid + "|");
    Serial.print("|" + password + "|");

    int timeout = 0;
    while (WiFi.status() != WL_CONNECTED && timeout < 20) {
      delay(500);
      Serial.print(".");
      timeout++;
    }

    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("\nConectado!");
      Serial.println(WiFi.localIP());

      // Registro los endpoints
      server.on("/", HTTP_GET, handleHome);
      server.on("/wifi", HTTP_GET, handleWiFiForm);
      server.on("/wifi-post", HTTP_POST, handleChangeWiFi);
      server.on("/chiste", HTTP_GET, handleChiste);
      server.begin();
    } else {
      // Si no conecta, borro credenciales y reinicio en modo AP
      Serial.println("\nNo se pudo conectar. Reiniciando en modo AP...");
      delay(2000);
      preferences.begin("wifi", false);
      preferences.clear();
      preferences.end();
      ESP.restart();
    }
  } else {
    // Si no hay credenciales guardadas → abro modo AP
    WiFi.softAP(ap_ssid, ap_password);
    Serial.println("Modo AP iniciado");
    Serial.print("IP del AP: ");
    Serial.println(WiFi.softAPIP());

    // Endpoints disponibles en modo AP
    server.on("/", handleRoot);
    server.on("/save", HTTP_POST, handleSave);
    server.begin();
  }
}

void loop() {
  server.handleClient();  // Atiende las peticiones al servidor
}

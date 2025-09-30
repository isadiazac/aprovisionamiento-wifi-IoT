# 📡 Proyecto IoT con ESP32: Configuración Wi-Fi Dinámica

## Descripción General

Este proyecto implementa un sistema en ESP32 que permite:

- Iniciar en modo **Access Point (AP)** si no hay credenciales guardadas.
- Ofrecer una interfaz web para ingresar SSID y contraseña.
- Guardar credenciales en memoria no volátil (Preferences).
- Reconectarse automáticamente a la red configurada.
- Proporcionar endpoints REST para cambiar red Wi-Fi y obtener chistes.
- Permitir reinicio de configuración.
- Documentar el diseño técnico, código, endpoints y pruebas.

---

## 🛠️ Tecnologías Utilizadas

- **ESP32**
- **Arduino Framework**
- **WebServer**
- **Preferences (memoria no volátil)**
- **HTTPClient**
- **Postman (para pruebas de API)**

---

## 📁 Estructura del Proyecto

```
├── src/
│   └── main.cpp
├── README.md
├── wiki/
│   ├── diseño_tecnico.md
│   ├── diagramas/
│   │   ├── uml_secuencia.png
│   │   └── arquitectura.png
├── postman/
│   └── coleccion.postman_collection.json
└── conversaciones/
    └── chat_con_IA.md
```

---

## 🌐 Endpoints Implementados

| Método | URL              | Headers       | Query Params | Payload (JSON)             | Respuesta |
|--------|------------------|---------------|--------------|----------------------------|-----------|
| GET    | `/`              | -             | -            | -                          | Página de bienvenida |
| POST   | `/save`          | -             | -            | `ssid`, `password`         | HTML confirmación |
| POST   | `/change_wifi`   | -             | -            | `ssid`, `password`         | HTML confirmación |
| GET    | `/chiste`        | -             | -            | -                          | Chiste en HTML |

---

## 🔁 Lógica de Conexión Wi-Fi

- Si hay credenciales guardadas:
  - Intenta conectar a la red.
  - Si falla, borra credenciales y reinicia en modo AP.
- Si no hay credenciales:
  - Inicia en modo AP con SSID `ConfiguraESP32`.
  - Ofrece formulario web para ingresar datos.
  - El Access Point esta en `192.168.4.1`

---

## 🔧 Mecanismo de Reinicio

- Si la conexión falla, se borran las credenciales y se reinicia en modo AP.
- También se puede cambiar la red desde el endpoint `/change_wifi`.

---

## 📊 Diagramas

- **UML de Secuencia**: Flujo de conexión y configuración.
- **Arquitectura del Sistema**: Componentes y comunicación.

<img width="1536" height="1024" alt="imagen" src="https://github.com/user-attachments/assets/3980f828-94b7-4c8d-aa3d-e4592b55818e" />


---

## 🧪 Pruebas con Postman

- Colección disponible en `postman/coleccion.postman_collection.json`.
- Incluye pruebas para todos los endpoints.

---

## 📚 Documentación Técnica

- Ver `wiki/diseño_tecnico.md` para detalles de implementación.
- Incluye esquemáticos, diagramas y explicación del código.

---

## 💬 Conversaciones con IA

- Archivo `conversaciones/chat_con_IA.md` contiene el historial de asistencia con inteligencia artificial.

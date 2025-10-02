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

## Tecnologías Utilizadas

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
│   └── main.ino
├── README.md
├── wiki/
│   ├── interfaces.md
│   ├── imagenes/
│   │   ├── ...Imagenes pagina web
│   │   ├── uml_secuencia.png
│   │   └── arquitectura.png
├── postman/
│   └── coleccion.postman_collection.json
└── conversaciones/
    └── chat_con_IA.md
```

---

## Endpoints Implementados

| Método | URL              | Headers       | Query Params | Payload (JSON)             | Respuesta |
|--------|------------------|---------------|--------------|----------------------------|-----------|
| GET    | `/`              | -             | -            | -                          | Página de bienvenida |
| POST   | `/save`          | -             | -            | `ssid`, `password`         | HTML confirmación |
| POST   | `/change_wifi`   | -             | -            | `ssid`, `password`         | HTML confirmación |
| GET    | `/chiste`        | -             | -            | -                          | Chiste en HTML |

---

## Lógica de Conexión Wi-Fi

- Si hay credenciales guardadas:
  - Intenta conectar a la red.
  - Si falla, borra credenciales y reinicia en modo AP.
- Si no hay credenciales:
  - Inicia en modo AP con SSID `ConfiguraESP32`.
  - Clave por defecto `12345678`
  - Ofrece formulario web para ingresar datos.
  - El Access Point esta en `192.168.4.1`

---

## Mecanismo de Reinicio

- Si la conexión falla, se borran las credenciales y se reinicia en modo AP.
- También se puede cambiar la red desde el endpoint `/change_wifi`.

---

## Diagramas

- **UML de Secuencia**: Flujo de conexión y configuración.
- **Arquitectura del Sistema**: Componentes y comunicación.

<img width="1536" height="1024" alt="imagen" src="https://github.com/user-attachments/assets/3980f828-94b7-4c8d-aa3d-e4592b55818e" />


---

## Pruebas con Postman

- Colección disponible en `postman/coleccion.postman_collection.json`. y en [Colección Postman](https://isadiac06-8447466.postman.co/workspace/Isabela-D%C3%ADaz-Acosta's-Workspace~9e2b66f0-0753-4365-8205-f3c81aec62b1/collection/48860550-9d965c59-ab2c-4bd3-a27d-2fb88f51e910?action=share&creator=48860550)
- Incluye pruebas para todos los endpoints.

---

## Documentación Técnica

- Ver `wiki/diseño_tecnico.md` para detalles de implementación.
- Incluye esquemáticos, diagramas y explicación del código.

- [Ver la Descripción de las Vistas, incluyendo una explicación detallada de cada una de las páginas web del sistema.](wiki/interfaces)
- 🌐 Incluye la visualización y comportamiento de cada uno de los endpoints disponibles en el dispositivo.


---

## 💬 Conversaciones con IA

- Archivo [Conversaciones con IA](conversaciones/chat_con_IA.md) contiene el historial de asistencia con inteligencia artificial.

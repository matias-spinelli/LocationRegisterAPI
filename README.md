# LocationRegisterAPI 📍

![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![Vapor](https://img.shields.io/badge/Vapor-0D0D0D?style=for-the-badge&logo=vapor&logoColor=blue)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

LocationRegisterAPI es el backend desarrollado en **Swift** utilizando **Vapor**, diseñado para almacenar **sucursales** y **registros de entrada/salida** provenientes del módulo **LocationRegisterKit**.

Utiliza **MongoDB** como base de datos, corre en **Docker**, y expone endpoints simples y eficientes para operar con datos de geolocalización.

---

## 🚀 Tecnologías utilizadas

- Swift 6+
- Vapor 4
- MongoKitten para acceso a MongoDB
- Docker Compose para entorno local
- CORS Middleware (si más adelante se integra con frontend)
- Desplegable fácilmente en Render, Railway, Fly.io, etc.

---

## ✨ Funcionalidades principales

### 🏢 Sucursales
- Registrar nuevas sucursales con coordenadas
- Listar todas las sucursales

### 🧍 Registros
- Guardar eventos de entrada y salida detectados por geofencing
- Consultar todos los registros almacenados

### 🛢️ Persistencia en MongoDB
- Colecciones: **sucursales** y **registros**
- IDs generados automáticamente con `ObjectId`

### 🔗 Integración directa con LocationRegisterKit
- Formato compatible para `sucursalID` y `userID`
- API liviana pensada especialmente para apps iOS

---

## 📂 Estructura del proyecto
```
Sources/
├── LocationRegisterAPI/
│   ├── Controllers/
│   │   ├── SucursalController.swift
│   │   └── RegistroController.swift
│   ├── Models/
│   │   ├── Sucursal.swift
│   │   └── Registro.swift
│   ├── configure.swift       
│   └── routes.swift         
└── Run/
    └── main.swift           

```

---

## 🔧 Instalación y ejecución local

### 🐳 Vía Docker (recomendado)

```bash
# Iniciar Mongo + API
docker compose up --build
```

- La API corre en:
👉 http://localhost:8080

- El dashboard de Mongo Express corre en:
👉 http://localhost:8081


### 🟧 Vía SwiftPM (sin Docker)
```
# Clonar el repo
git clone https://github.com/matias-spinelli/LocationRegisterAPI.git
cd LocationRegisterAPI

# Build
swift build

# Run
swift run
```

---

## 🌍 Variables de entorno requeridas

Cuando no usás Docker:
```
MONGO_URL=mongodb://localhost:27017/location-register
PORT=8080     # opcional
```

---

## 📡 Endpoints disponibles

### 🏢 Sucursales (/api/sucursales)
| Método | Endpoint | Descripción |
|:-------|:----------|:-------------|
| ![GET](https://img.shields.io/badge/GET-4CAF50?style=for-the-badge) | `/api/sucursales` | Listar todas las sucursales |
| ![POST](https://img.shields.io/badge/POST-2196F3?style=for-the-badge) | `/api/sucursales` | Crear una nueva sucursal |

#### Modelo esperado (POST)

```json
{
  "nombre": "Sucursal Centro",
  "lat": -34.6037,
  "lng": -58.3816
}
```

### 🧍 Registros (/api/registros)
| Método | Endpoint | Descripción |
|:-------|:----------|:-------------|
| ![GET](https://img.shields.io/badge/GET-4CAF50?style=for-the-badge) | `/api/registros` | Obtener todos los registros |
| ![POST](https://img.shields.io/badge/POST-2196F3?style=for-the-badge) | `/api/registros` | Crear un nuevo registro |

### Modelo esperado (POST)
```json
{
  "timestamp": "2025-12-10T12:00:00Z",
  "tipo": "entrada",
  "sucursalID": "uuid-o-string",
  "userID": "uuid-o-string"
}
```

---

## ☁️ Deploy

La API está deployada en Render.com y disponible públicamente:

👉 https://locationregisterapi.onrender.com

--- 

## 🌟 Créditos

Proyecto creado por **Matías Spinelli** (@matias-spinelli)
Backend desarrollado en **Swift** + **Vapor**, como parte de la app de geofencing **LocationRegisterKit**.

--

## 📜 Licencia

MIT License © 2025

📍 “La ubicación no es un lugar — es un contexto.”

# 🎙️ MailFlow

### ¿Y si pudieras escuchar tus emails en lugar de leerlos?

**MailFlow** es un asistente de correo electrónico web que transforma los emails en audio mediante **Text-to-Speech** y
busca incorporar **resúmenes generados con inteligencia artificial** para facilitar el consumo de información cuando
leer no resulta práctico.

> 🚧 **Proyecto personal en desarrollo**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter\&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart\&logoColor=white)](https://dart.dev/)
[![Gmail API](https://img.shields.io/badge/Gmail%20API-EA4335?logo=gmail\&logoColor=white)](https://developers.google.com/gmail/api)
[![OAuth 2.0](https://img.shields.io/badge/OAuth-2.0-blue)](https://oauth.net/2/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?logo=springboot\&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql\&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker\&logoColor=white)](https://www.docker.com/)

---

## 💡 El problema

MailFlow nació a partir de una situación real.

Una persona cercana a mí recibe una gran cantidad de correos electrónicos durante su jornada laboral y no siempre
dispone del tiempo necesario para leerlos todos.

Una de sus necesidades era poder **escuchar los emails mientras se trasladaba**, sin depender de Siri.

Esto llevó a una pregunta:

> **¿Por qué un email tiene que ser necesariamente algo que leemos?**

A partir de esa idea comenzó MailFlow.

---

## 🎯 Objetivo

El objetivo de MailFlow es explorar una experiencia de correo electrónico más flexible, donde el usuario pueda:

* 📧 consultar sus emails;
* 🔊 escucharlos mediante Text-to-Speech;
* 🤖 obtener resúmenes de mensajes extensos;
* ⭐ identificar mensajes relevantes;
* 🎙️ interactuar con el correo mediante voz.

La aplicación está pensada especialmente para situaciones donde mantener la atención sobre una pantalla no resulta
práctico.

---

## ✨ Funcionalidades

### Actualmente implementado

* 🔐 Autenticación mediante Google OAuth 2.0
* 📧 Integración con Gmail API
* 📬 Recuperación de correos electrónicos
* 📨 Visualización de mensajes
* 🔊 Conversión de texto a voz
* 🌐 Interfaz web desarrollada con Flutter

### En desarrollo

* 🤖 Resúmenes de emails mediante IA
* ⭐ Priorización inteligente
* 🏷️ Categorización automática
* 🎙️ Interacción mediante comandos de voz
* 💬 Respuestas mediante voz
* 📮 Soporte para otros proveedores de correo

---

## 🖥️ Flujo actual

```text
┌──────────────────┐
│    Usuario       │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Google OAuth   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│    Gmail API     │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Procesamiento    │
│     Email        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Text-to-Speech  │
└──────────────────┘
         │
         ▼
       🔊 Audio
```

---

## 🏗️ Arquitectura

### Arquitectura actual

La versión actual está centrada en Flutter y la integración directa con los servicios necesarios para obtener y
reproducir los correos.

```text
Flutter Web
    │
    ├── Google OAuth 2.0
    │
    ├── Gmail API
    │
    ├── Email Processing
    │
    └── Text-to-Speech
```

### Arquitectura planificada

A medida que el proyecto evolucione, la arquitectura contempla incorporar un backend para separar responsabilidades y
centralizar la lógica de negocio.

```text
                  ┌───────────────┐
                  │ Flutter Web   │
                  └───────┬───────┘
                          │
                          ▼
                  ┌───────────────┐
                  │ Spring Boot   │
                  │     API       │
                  └───────┬───────┘
                          │
                ┌─────────┴─────────┐
                ▼                   ▼
        ┌──────────────┐    ┌──────────────┐
        │ PostgreSQL   │    │ AI Services  │
        └──────────────┘    └──────────────┘
                │
                ▼
          ┌──────────────┐
          │  Gmail API   │
          └──────────────┘
```

---

## 🛠️ Tecnologías

| Área           | Tecnologías          |
|----------------|----------------------|
| Frontend       | Flutter · Dart       |
| Backend        | Java · Spring Boot   |
| Email          | Gmail API            |
| Authentication | Google OAuth 2.0     |
| Voice          | Text-to-Speech       |
| AI             | AI-powered summaries |
| Database       | PostgreSQL           |
| DevOps         | Docker               |
| Documentation  | Markdown · ADRs      |

---

## 🧠 Decisiones técnicas

MailFlow también funciona como un espacio de aprendizaje y experimentación sobre desarrollo de software.

Algunas decisiones se documentan mediante **Architecture Decision Records (ADR)** para registrar:

* alternativas consideradas;
* decisiones tomadas;
* motivos técnicos;
* consecuencias;
* posibles cambios futuros.

📚 La documentación técnica se encuentra en [`docs/`](docs/).

---

## 🗺️ Roadmap

### 🔊 Fase 1 — Voz

* [x] Integración Text-to-Speech
* [x] Reproducción de contenido
* [ ] Mejoras de experiencia de reproducción

### 📧 Fase 2 — Gmail

* [x] Google OAuth
* [x] Integración Gmail API
* [x] Recuperación de emails
* [x] Visualización de mensajes

### ⚙️ Fase 3 — Backend

* [ ] API con Spring Boot
* [ ] Gestión de usuarios
* [ ] Preferencias
* [ ] Persistencia
* [ ] Historial

### 🤖 Fase 4 — Inteligencia Artificial

* [ ] Resúmenes de emails
* [ ] Priorización
* [ ] Categorización
* [ ] Procesamiento inteligente

### 🚀 Fase 5 — Evolución

* [ ] Respuestas mediante voz
* [ ] Soporte para múltiples proveedores
* [ ] Deploy
* [ ] Mejoras de accesibilidad

---

## 🔐 Seguridad

MailFlow trabaja con información potencialmente sensible, por lo que la autenticación y el acceso a los datos de correo
forman parte importante del diseño.

El proyecto utiliza OAuth 2.0 para la autenticación con Google y busca aplicar el principio de mínimo privilegio
respecto de los permisos solicitados.

 <!--📚 Más información en [`docs/security.md`](docs/).-->

---

## 📂 Estructura

```text
mailflow/
│
├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── widgets/
│   │   ├── constants/
│   │   └── theme/
│   │
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── windows/
│   ├── linux/
│   └── macos/
│
├── backend/
│
├── docs/
│   ├── decisions/
│   ├── architecture.md
│   ├── roadmap.md
│   └── ...
│
├── README.md
└── LICENSE
```

---

## 🚧 Estado del proyecto

**MailFlow se encuentra actualmente en desarrollo.**

La aplicación está evolucionando desde un prototipo inicial hacia una arquitectura más completa, incorporando
progresivamente autenticación, integración con Gmail, procesamiento de emails, Text-to-Speech, backend e inteligencia
artificial.

---

## 👩🏽‍💻 Autora

**Brisa Anahi Escobar**

Estudiante de Ingeniería en Sistemas de Información · Desarrolladora de Software en formación.

MailFlow es un proyecto personal creado para explorar la integración entre **desarrollo de aplicaciones, APIs,
autenticación, voz e inteligencia artificial**, partiendo de un problema real.

* 💼 [LinkedIn](https://www.linkedin.com/in/escobarbrisa/)
* 🌐 [Portfolio](https://brisaanahiescobar.github.io/Portafolio/)
* 💻 [GitHub](https://github.com/BrisaAnahiEscobar)

---

## 📌 ¿Querés conocer más?

Podés explorar el código, la documentación y las decisiones técnicas del proyecto:

👉 **[Ver MailFlow en GitHub](https://github.com/BrisaAnahiEscobar/mailflow)**

# MailFlow 📨 
MailFlow es un asistente de voz multiplataforma para correo electrónico que permite a los usuarios leer sus mensajes sin usar las manos.

La aplicación se conecta a proveedores de correo electrónico como Gmail, recupera los mensajes entrantes y los convierte a voz natural mediante tecnologías de conversión de texto a voz. Las futuras versiones incorporarán resúmenes con IA, priorización de correos electrónicos y respuestas por voz.

## 🧩 Problema

Leer correos electrónicos puede ser tedioso, especialmente durante los desplazamientos, al realizar varias tareas a la vez o para usuarios con necesidades de accesibilidad.

MailFlow busca transformar la experiencia del correo electrónico permitiendo a los usuarios escuchar sus mensajes en lugar de leerlos.

## Estado

🚧 En desarrollo

## 🛠️ Tecnologías Utilizadas

| **FRONTEND** | **BACKEND** | **SERVICIOS** | **BASE DE DATOS** | **DEVOPS** |
|:---:|:---:|:---:|:---:|:---:|
| Flutter | Java | API de Gmail | PostgreSQL | Docker |
| Dart | Spring Boot | Autenticación OAuth2 | | |
| | | Conversión TTS | | |


## 🗺️ Hoja de Ruta

<details>
<summary>📋 Ver tareas detalladas por fase</summary>

**🔊 Fase 1 — Fundamentos de Voz**
- [ ] Integración de conversión de texto a voz
- [ ] Lectura en voz alta de un correo de ejemplo

**📧 Fase 2 — Integración Gmail**
- [ ] Gmail OAuth
- [ ] Recuperación de metadatos
- [ ] Lectura de correos reales

**⚙️ Fase 3 — Backend & Usuario**
- [ ] Spring Boot
- [ ] Preferencias del usuario
- [ ] Historial de correo

**🤖 Fase 4 — Inteligencia Artificial**
- [ ] Resúmenes con IA
- [ ] Priorización inteligente
- [ ] Categorización

**🚀 Fase 5 — Producción**
- [ ] Respuestas de voz
- [ ] Multi-proveedor
- [ ] Deploy en producción

</details>

| | Fase | Descripción | Estado |
|:---:|:---|:---|:---:|
| 🔊 | **Fase 1** · Fundamentos de Voz | Integración TTS · Lectura de correo de ejemplo | ![](https://img.shields.io/badge/Completado-brightgreen?style=flat-square) |
| 📧 | **Fase 2** · Integración Gmail | OAuth · Metadatos · Lectura de correos reales |![](https://img.shields.io/badge/En_progreso-blue?style=flat-square)|
| ⚙️ | **Fase 3** · Backend & Usuario | Spring Boot · Preferencias · Historial | ![](https://img.shields.io/badge/Pendiente-FFD700?style=flat-square)|
| 🤖 | **Fase 4** · Inteligencia Artificial | Resúmenes IA · Priorización · Categorización |![](https://img.shields.io/badge/Pendiente-FFD700?style=flat-square) |
| 🚀 | **Fase 5** · Producción | Respuestas de voz · Multi-proveedor · Deploy | ![](https://img.shields.io/badge/Pendiente-FFD700?style=flat-square) |

### 🗂️ Estructura inicial 

````
mailflow/
│
├── frontend/
│
├── backend/
│
├── docs/
    ├── architecture.md
    ├── roadmap.md
    └── ideas.md
│
├── .gitignore
│
└── README.md
````
## Autor 👩🏽‍💻
Brisa Escobar
<!-- y corchi <3-->


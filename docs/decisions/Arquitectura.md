# 🏗️ MailFlow — Arquitectura

> [MailFlow — Documento de Arquitectura](https://docs.google.com/document/d/1LCGyoSWmcGrbtWah-U_Bjyy1KmuRAVfX1r8WUIju6jQ/edit?tab=t.0)
>
>  Importante - Este archivo es un resumen de referencia rápida. La fuente completa es el documento de Google.

---

## Índice

1. [Descripción del sistema](#1-descripción-del-sistema)
2. [Stack tecnológico](#2-stack-tecnológico)
3. [Fases del proyecto](#3-fases-del-proyecto)
4. [Arquitectura lógica](#4-arquitectura-lógica)
5. [Decisiones de arquitectura (ADR)](#5-decisiones-de-arquitectura-adr)
6. [Patrones de diseño](#6-patrones-de-diseño)
7. [Requerimientos](#7-requerimientos)

---

## 1. Descripción del sistema

MailFlow es una aplicación multiplataforma de asistente de voz para correo electrónico.  
Convierte correos de Gmail en audio mediante TTS, orientada a accesibilidad y productividad.

**Fuera del alcance:** cliente de correo completo, calendario, contactos, envío masivo.

---

## 2. Stack tecnológico

| Área              | Tecnología                 | Fase    |
|-------------------|----------------------------|---------|
| Frontend          | Flutter / Dart             | Fase 1+ |
| Síntesis de voz   | flutter_tts                | Fase 1  |
| Autenticación     | OAuth 2.0 / google_sign_in | Fase 2  |
| API de correo     | Gmail API                  | Fase 2  |
| Gestión de estado | Provider / ChangeNotifier  | Fase 2  |
| Backend           | Java / Spring Boot         | Fase 3  |
| Base de datos     | PostgreSQL                 | Fase 3  |
| Contenedores      | Docker                     | Fase 3  |

---

## 3. Fases del proyecto

| # | Fase                       | Contenido                                      | Estado        |
|---|----------------------------|------------------------------------------------|---------------|
| 1 | 🔊 Fundamentos de Voz      | Integración TTS · Lectura de correo de ejemplo | ✅ Completo    |
| 2 | 📧 Integración Gmail       | OAuth · Metadatos · Lectura de correos reales  | ✅ Completo    |
| 3 | ⚙️ Backend & Usuario       | Spring Boot · Preferencias · Historial         | 🟠 En proceso |
| 4 | 🤖 Inteligencia Artificial | Resúmenes IA · Priorización · Categorización   | 🟡 Pendiente  |
| 5 | 🚀 Producción              | Respuestas por voz · Multi-proveedor · Deploy  | 🟡 Pendiente  |

---

## 4. Arquitectura lógica

### Fase 2 (actual)

```
Flutter UI → Provider → Service → Gmail API
                                      ↓
                                    TTS
```

### Fase 3+ (objetivo)

```
Flutter UI → Provider → Service → Repository
                                      ↓
                               Spring Boot API
                              ↙            ↘
                        PostgreSQL     Servicios externos
                                       (Gmail API · IA)
```

**Capas:**

| Capa                  | Responsabilidad                      |
|-----------------------|--------------------------------------|
| UI                    | Presentación únicamente              |
| Provider              | Estado de la aplicación              |
| Service               | Lógica de negocio                    |
| Repository *(Fase 3)* | Acceso a datos                       |
| Backend *(Fase 3)*    | Intermediario con servicios externos |

---

## 5. Decisiones de arquitectura (ADR)

| ADR     | Decisión                                              | Estado                |
|---------|-------------------------------------------------------|-----------------------|
| ADR-001 | Flutter como framework multiplataforma                | ✅ Aceptado            |
| ADR-002 | Arquitectura Cliente-Servidor distribuida             | ✅ Aceptado (Fase 3)   |
| ADR-003 | Provider para gestión de estado                       | ✅ Aceptado (temporal) |
| ADR-004 | Separación en capas                                   | ✅ Aceptado            |
| ADR-005 | OAuth2 para autenticación                             | ✅ Aceptado            |
| ADR-006 | Plataformas soportadas en Fase 2 (sin desktop nativo) | ✅ Aceptado            |

> ⚠️ **ADR-001 update:** `google_sign_in` v7 limita el soporte funcional actual a Android, iOS y Web. Desktop nativo
> pospuesto a Fase 3 (ver ADR-006).
>
> ⚠️ **ADR-003 update:** `ChangeNotifierProxyProvider` diferido. Comunicación entre `AuthProvider` y `GmailProvider`
> resuelta mediante wiring manual hasta que ambos estén estables.

---

## 6. Patrones de diseño

| Patrón               | Uso en MailFlow                                                                 | Estado                  |
|----------------------|---------------------------------------------------------------------------------|-------------------------|
| Observer             | `ChangeNotifier` + `Provider` → actualización reactiva de la UI                 | ✅ Implementado          |
| Facade               | `TtsService` encapsula la complejidad de `flutter_tts`                          | ✅ Implementado          |
| Repository           | `EmailRepository` → interfaz común para múltiples proveedores                   | 🟡 Planificado (Fase 3) |
| Dependency Injection | Dependencias inyectadas vía Providers, nunca instanciadas directamente en la UI | ✅ Implementado          |

---

## 7. Requerimientos

### Funcionales

| ID    | Requerimiento                  | Estado       |
|-------|--------------------------------|--------------|
| RF-01 | Convertir correos a voz        | ✅ Realizado  |
| RF-02 | Autenticar usuarios con Gmail  | ✅ Realizado  |
| RF-03 | Recuperar correos reales       | ✅ Realizado  |
| RF-04 | Persistir preferencias         | 🟡 Pendiente |
| RF-05 | Generar resúmenes mediante IA  | 🟡 Pendiente |
| RF-06 | Priorizar correos              | 🟡 Pendiente |
| RF-07 | Responder correos por voz      | 🟡 Pendiente |
| RF-08 | Soportar múltiples proveedores | 🟡 Pendiente |

### No funcionales clave

| ID     | Requerimiento                             |
|--------|-------------------------------------------|
| RNF-01 | Arquitectura multiplataforma              |
| RNF-02 | Latencia < 2 segundos                     |
| RNF-03 | Backend disponible > 99%                  |
| RNF-04 | Tokens almacenados de forma segura        |
| RNF-05 | Accesibilidad                             |
| RNF-06 | Escalabilidad hacia múltiples proveedores |

---

*15/09/26 - Última actualización: Fase 2 — Integración Gmail (Completada)*

### Autora 👩🏽‍💻

#### Brisa Escobar - Estudiante de Ingeniería en Sistemas · Desarrolladora de Software.

Proyecto personal orientado a accesibilidad, productividad y desarrollo multiplataforma.


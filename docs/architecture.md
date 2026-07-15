# MailFlow — Documento de Arquitectura

> Este documento describe la arquitectura de MailFlow, las decisiones técnicas tomadas durante su desarrollo, las
> alternativas consideradas y la evolución prevista del sistema. Su objetivo es servir como documentación viva del
> proyecto, permitiendo comprender no solamente **qué** se implementó, sino también **por qué** se eligió cada solución.

---

# Información del documento

| Campo                | Valor                      |
|----------------------|----------------------------|
| Proyecto             | MailFlow                   |
| Autora               | Brisa Escobar              |
| Estado               | En desarrollo              |
| Versión              | 1.0                        |
| Última actualización | Fase 2 – Integración Gmail |

---

# Índice

1. Introducción
2. Alcance
3. Público objetivo
4. Problema
5. Objetivos
6. Requerimientos
7. Restricciones
8. Atributos de calidad
9. Principios de diseño
10. Arquitectura general
11. Decisiones de arquitectura (ADR)
12. Diagramas
13. Patrones de diseño
14. Trade-offs
15. Riesgos arquitectónicos
16. Escenarios de calidad
17. Preguntas de discusión
18. Roadmap
19. Referencias

---

# 1. Introducción

## 1.1 Propósito

Este documento registra las decisiones arquitectónicas adoptadas durante el desarrollo de MailFlow.

Su objetivo es:

- documentar la arquitectura del sistema;
- justificar las decisiones de diseño;
- registrar alternativas descartadas;
- facilitar el mantenimiento futuro;
- servir como documentación técnica para el portfolio profesional del proyecto.

A diferencia de un README, este documento se centra exclusivamente en aspectos de arquitectura y diseño de software.

---

## 1.2 Alcance del documento

Este documento describe:

- la arquitectura lógica del sistema;
- la arquitectura física prevista;
- los componentes principales;
- las responsabilidades de cada módulo;
- los patrones utilizados;
- las decisiones de diseño (ADR);
- la evolución arquitectónica prevista.

No pretende documentar detalles de implementación específicos del código fuente, algoritmos internos ni manuales de
usuario.

---

# 2. Alcance del proyecto

MailFlow es una aplicación multiplataforma cuyo objetivo es facilitar el consumo de correos electrónicos mediante
síntesis de voz.

El sistema está diseñado principalmente para usuarios que desean escuchar sus correos sin necesidad de mantener atención
visual constante.

## Funcionalidades incluidas

- autenticación mediante Gmail
- lectura por voz de correos
- administración de preferencias
- recuperación de correos
- integración futura con IA
- soporte futuro para múltiples proveedores

## Funcionalidades fuera del alcance

Las siguientes funcionalidades no forman parte del objetivo del proyecto:

- cliente de correo completo
- edición avanzada de correos
- calendario
- administración de contactos
- envío masivo de emails
- reemplazar completamente aplicaciones como Gmail o Outlook

---

# 3. Público objetivo

Este documento está dirigido a:

- desarrolladores que colaboren en el proyecto;
- docentes o evaluadores;
- entrevistadores técnicos;
- futuros mantenedores del sistema;
- la propia autora como documentación de evolución.

---

# 4. Problema

## 4.1 Problema que resuelve MailFlow

La lectura de correos electrónicos requiere atención visual constante.

En numerosos escenarios cotidianos esto representa una limitación:

- conducción
- transporte público
- actividades domésticas
- personas con disminución visual
- usuarios que realizan múltiples tareas simultáneamente

Si bien existen asistentes virtuales capaces de leer correos, dicha funcionalidad constituye una característica
secundaria dentro de productos mucho más amplios.

MailFlow propone una solución especializada, liviana y enfocada específicamente en transformar el correo electrónico en
una experiencia de audio.

---

## 4.2 Objetivos generales

El proyecto busca construir una arquitectura que sea:

- mantenible;
- escalable;
- extensible;
- desacoplada;
- fácilmente testeable.

Además posee un objetivo educativo:

- aprender Flutter;
- aprender arquitectura distribuida;
- aplicar patrones de diseño;
- practicar documentación técnica;
- construir un proyecto de portfolio defendible técnicamente.

---

# 5. Objetivos específicos

Los objetivos técnicos del sistema son:

- integrar Gmail mediante OAuth2;
- convertir texto a voz utilizando TTS nativo;
- desacoplar la lógica de negocio de la interfaz;
- soportar múltiples proveedores de correo;
- incorporar inteligencia artificial para resumir correos;
- mantener una arquitectura preparada para crecer sin grandes refactorizaciones.

---

# 6. Requerimientos

## 6.1 Requerimientos funcionales

| ID    | Requerimiento                  | Estado |
|-------|--------------------------------|--------|
| RF-01 | Convertir correos a voz        | ✅      |
| RF-02 | Autenticar usuarios con Gmail  | 🔄     |
| RF-03 | Recuperar correos reales       | 🔄     |
| RF-04 | Persistir preferencias         | ⏳      |
| RF-05 | Generar resúmenes mediante IA  | ⏳      |
| RF-06 | Priorizar correos              | ⏳      |
| RF-07 | Responder correos mediante voz | ⏳      |
| RF-08 | Soportar múltiples proveedores | ⏳      |

---

## 6.2 Requerimientos no funcionales

| ID     | Requerimiento                             |
|--------|-------------------------------------------|
| RNF-01 | Arquitectura multiplataforma              |
| RNF-02 | Latencia inferior a 2 segundos            |
| RNF-03 | Backend disponible más del 99%            |
| RNF-04 | Tokens almacenados de forma segura        |
| RNF-05 | Accesibilidad                             |
| RNF-06 | Escalabilidad hacia múltiples proveedores |
| RNF-07 | Código mantenible                         |
| RNF-08 | Arquitectura preparada para crecimiento   |
| RNF-09 | Separación clara de responsabilidades     |
| RNF-10 | Alta cohesión y bajo acoplamiento         |

---

## 6.3 Trazabilidad

Cada decisión arquitectónica documentada mediante un ADR deberá satisfacer uno o más requerimientos funcionales o no
funcionales.

Esta trazabilidad permite justificar técnicamente cada decisión y evaluar posteriormente su impacto sobre la
arquitectura.

Ejemplo:

| ADR     | Requerimientos relacionados |
|---------|-----------------------------|
| ADR-001 | RNF-01                      |
| ADR-002 | RNF-03, RNF-06              |
| ADR-003 | RNF-07, RNF-09              |
| ADR-004 | RNF-07, RNF-10              |
| ADR-005 | RNF-04                      |

- cache local;
- sincronización diferida;
- funcionamiento parcial sin conexión.

---

## 8.6 Rendimiento

El tiempo de respuesta influye directamente en la experiencia del usuario.

Los principales objetivos son:

- lectura iniciada en menos de dos segundos;
- carga rápida de la bandeja;
- minimizar llamadas innecesarias a Gmail;
- reutilizar recursos locales cuando sea posible.

---

## 8.7 Testabilidad

La arquitectura debe permitir probar componentes de manera aislada.

Esto motiva decisiones como:

- Services independientes.
- Providers desacoplados.
- Repository.
- Interfaces.
- Inyección de dependencias.

---

# 9. Principios de diseño

Las decisiones arquitectónicas del proyecto se apoyan sobre principios ampliamente utilizados en ingeniería de software.

---

## 9.1 Separation of Concerns

Cada componente posee una única responsabilidad claramente definida.

Ejemplo:

- UI presenta información.
- Provider administra estado.
- Service implementa lógica técnica.
- Repository accede a datos.

---

## 9.2 Single Responsibility Principle

Cada clase debe tener un único motivo para cambiar.

Ejemplos:

- TtsService únicamente administra la síntesis de voz.
- Email representa únicamente el modelo de datos.
- HomePage únicamente construye la interfaz.

---

## 9.3 Dependency Inversion

Los módulos de alto nivel no dependen directamente de implementaciones concretas.

Este principio será especialmente importante cuando exista más de un proveedor de correo.

---

## 9.4 Open / Closed Principle

La arquitectura intenta permanecer abierta a extensiones pero cerrada a modificaciones.

Ejemplo:

Agregar Outlook implicará crear una nueva implementación de EmailRepository sin modificar el resto del sistema.

---

## 9.5 Composition over Inheritance

Siempre que sea posible se favorece la composición.

Ejemplo:

TtsProvider utiliza TtsService en lugar de extenderlo.

---

## 9.6 Bajo acoplamiento

Los componentes deben conocerse lo menos posible entre sí.

Ejemplo:

La UI nunca interactúa directamente con flutter_tts.

---

## 9.7 Alta cohesión

Cada módulo concentra responsabilidades relacionadas.

Esto facilita:

- mantenimiento;
- reutilización;
- testing;
- evolución del sistema.

---

# 10. Arquitectura general

## 10.1 Estilo arquitectónico

MailFlow adopta una arquitectura Cliente–Servidor organizada mediante capas.

La aplicación se divide conceptualmente en:

- Presentación
- Gestión de estado
- Servicios
- Persistencia
- Servicios externos

Cada capa depende únicamente de la inmediatamente inferior.

---

## 10.2 Arquitectura distribuida

A partir de la Fase 3 el sistema pasa a ser una arquitectura distribuida.

Los principales nodos serán:

- Cliente Flutter
- Backend Spring Boot
- Base de datos PostgreSQL
- Gmail API
- Proveedor de IA

Cada uno podrá ejecutarse de manera independiente y comunicarse mediante protocolos de red.

Esta separación permite:

- escalar componentes individualmente;
- desacoplar responsabilidades;
- mejorar la seguridad;
- facilitar el mantenimiento.

---

## 10.3 Justificación

La arquitectura distribuida fue elegida porque permite centralizar la lógica de negocio, mantener una única fuente de
verdad para los datos del usuario y desacoplar el cliente de los servicios externos.

Además prepara el sistema para futuras funcionalidades como:

- múltiples dispositivos;
- múltiples proveedores de correo;
- inteligencia artificial;
- sincronización;
- preferencias compartidas.

---

## 10.4 Vista lógica

La arquitectura lógica puede resumirse en las siguientes capas:

```

Usuario

↓

Flutter UI

↓

Providers

↓

Services

↓

Repositories

↓

Backend REST

↓

Base de Datos

↓

Servicios Externos

```

Cada capa posee responsabilidades claramente definidas y sólo interactúa con las capas adyacentes.

---

## 10.5 Justificación del sistema distribuido

MailFlow puede considerarse un sistema distribuido porque sus componentes principales se ejecutan como procesos
independientes comunicados mediante protocolos estándar (HTTP, REST y SQL).

Esto permite desplegar, mantener y escalar cada componente de forma independiente.

En la Fase 2 la distribución es parcial, ya que el cliente aún interactúa directamente con Gmail. A partir de la Fase 3
toda comunicación con servicios externos será intermediada por el backend, consolidando la arquitectura distribuida
prevista.

# 11. Decisiones de Arquitectura (ADR)

Las decisiones arquitectónicas (Architecture Decision Records - ADR) documentan las elecciones técnicas relevantes
realizadas durante el desarrollo del proyecto.

Cada ADR registra:

- El problema que motivó la decisión.
- Las alternativas consideradas.
- La decisión adoptada.
- Las consecuencias esperadas.
- Los riesgos asociados.
- Los atributos de calidad que busca satisfacer.

Las decisiones aquí documentadas forman parte de la evolución del proyecto y podrán ser reemplazadas por nuevos ADR
cuando cambien las condiciones del sistema.

---

# ADR-001 — Flutter como framework multiplataforma

**Estado:** Aceptado

## Contexto

MailFlow busca ejecutarse en múltiples plataformas utilizando una única base de código.

El proyecto además posee una fuerte orientación educativa, por lo que resulta importante reducir el tiempo dedicado al
mantenimiento de múltiples implementaciones.

---

## Problema

¿Cómo desarrollar una aplicación disponible para Android, iOS, Windows, Linux, macOS y Web sin mantener varios proyectos
independientes?

---

## Alternativas consideradas

### Desarrollo nativo

**Ventajas**

- Máximo rendimiento.
- Integración completa con APIs del sistema.

**Desventajas**

- Múltiples bases de código.
- Mayor costo de mantenimiento.
- Poco viable para una sola desarrolladora.

---

### React Native

**Ventajas**

- Gran comunidad.
- Amplio ecosistema.

**Desventajas**

- Mayor dependencia de bridges nativos.
- Integración TTS menos directa.

---

### Flutter

**Ventajas**

- Código único.
- Excelente soporte multiplataforma.
- Hot Reload.
- Muy buena integración con componentes nativos.

---

## Decisión

Se adopta Flutter como framework principal del cliente.

---

## Consecuencias

### Positivas

- Código reutilizable.
- Menor costo de mantenimiento.
- Desarrollo más rápido.

### Negativas

- Dependencia del ecosistema Flutter.
- Dependencia de plugins externos.

---

## Riesgos

- Plugins abandonados.
- Cambios incompatibles en Flutter.

Mitigación:

- Encapsular dependencias mediante Services.

---

## Atributos de calidad relacionados

- Escalabilidad
- Mantenibilidad
- Portabilidad

---

# ADR-002 — Arquitectura Cliente–Servidor Distribuida

**Estado:** Aceptado

## Contexto

Las primeras versiones funcionan completamente del lado del cliente.

Sin embargo, futuras funcionalidades requieren:

- autenticación;
- almacenamiento persistente;
- inteligencia artificial;
- sincronización entre dispositivos.

---

## Problema

¿Cómo permitir que el sistema evolucione sin convertir la aplicación móvil en un cliente excesivamente complejo?

---

## Alternativas consideradas

### Cliente completamente autónomo

Ventajas

- Arquitectura simple.
- Sin costos de servidor.

Desventajas

- Sin sincronización.
- Difícil integración con IA.
- Mayor exposición de credenciales.

---

### Arquitectura Cliente–Servidor

Ventajas

- Centralización de lógica.
- Mejor seguridad.
- Escalabilidad.

Desventajas

- Mayor complejidad.
- Necesidad de infraestructura.

---

## Decisión

Adoptar una arquitectura distribuida basada en:

Cliente Flutter

↓

Backend Spring Boot

↓

PostgreSQL

↓

Servicios externos

---

## Consecuencias

### Positivas

- Escalabilidad horizontal.
- Mejor separación de responsabilidades.
- Backend reutilizable.

### Negativas

- Latencia adicional.
- Mayor complejidad operativa.

---

## Riesgos

- Punto único de fallo.

Mitigación:

Backend desacoplado y preparado para futuras réplicas.

---

## Atributos de calidad

- Escalabilidad
- Seguridad
- Disponibilidad

---

# ADR-003 — Provider para gestión de estado

**Estado:** Aceptado

## Problema

La aplicación necesita compartir estado entre múltiples pantallas sin depender de setState.

---

## Alternativas

- setState
- BLoC
- Riverpod
- Provider

---

## Decisión

Utilizar Provider mediante ChangeNotifier.

---

## Justificación

Provider presenta un equilibrio adecuado entre simplicidad y escalabilidad para el tamaño actual del proyecto.

---

## Consecuencias

Positivas

- Estado centralizado.
- Integración sencilla.
- Amplia documentación.

Negativas

- Dependencia de BuildContext.

---

## Riesgos

Si el proyecto crece considerablemente puede resultar conveniente migrar a Riverpod.

---

## Atributos

- Mantenibilidad
- Bajo acoplamiento

---

# ADR-004 — Separación en capas

**Estado:** Aceptado

## Problema

La primera versión mezclaba lógica de negocio, acceso a datos y presentación.

---

## Decisión

Separar la aplicación en las siguientes capas:

UI

↓

Provider

↓

Service

↓

Repository

↓

Servicios externos

---

## Beneficios

- Alta cohesión.
- Bajo acoplamiento.
- Testing independiente.

---

## Riesgos

Mayor cantidad de clases.

Se acepta debido a la mejora en mantenibilidad.

---

## Atributos

- Mantenibilidad
- Testabilidad
- Escalabilidad

---

# ADR-005 — OAuth2 para autenticación

**Estado:** Propuesto

## Problema

El sistema necesita acceder a Gmail sin almacenar contraseñas.

---

## Alternativas

IMAP

OAuth2

---

## Decisión

Utilizar OAuth2 con principio de mínimo privilegio.

---

## Consecuencias

Positivas

- Mayor seguridad.
- Cumplimiento de políticas de Google.

Negativas

- Mayor complejidad de implementación.

---

## Riesgos

Administración segura de Refresh Tokens.

Mitigación:

Centralizar el manejo de credenciales en el backend.

---

## Atributos

- Seguridad
- Escalabilidad

---

# Matriz de trazabilidad

| ADR     | RF    | RNF           | Atributos      |
|---------|-------|---------------|----------------|
| ADR-001 | RF-01 | RNF-01        | Portabilidad   |
| ADR-002 | RF-02 | RNF-03 RNF-06 | Escalabilidad  |
| ADR-003 | —     | RNF-07 RNF-09 | Mantenibilidad |
| ADR-004 | RF-01 | RNF-07 RNF-10 | Cohesión       |
| ADR-005 | RF-02 | RNF-04        | Seguridad      |

# 12. Patrones de diseño utilizados

Los patrones de diseño utilizados en MailFlow responden a problemas concretos detectados durante el desarrollo del
proyecto. No se incorporan patrones por completitud, sino únicamente cuando aportan una mejora en mantenibilidad,
extensibilidad o desacoplamiento.

---

## Resumen

| Patrón               | Estado       | Objetivo                                   |
|----------------------|--------------|--------------------------------------------|
| Observer             | Implementado | Notificar cambios de estado a la interfaz  |
| Facade               | Implementado | Simplificar el acceso al motor TTS         |
| Repository           | Planificado  | Abstraer el acceso a proveedores de correo |
| Dependency Injection | Implementado | Reducir el acoplamiento entre componentes  |

---

# 12.1 Observer

## Problema

La interfaz debe actualizarse automáticamente cuando cambia el estado del sistema sin consultar continuamente si hubo
modificaciones.

## Solución

Se utiliza `ChangeNotifier` junto con `Provider`.

Cuando cambia el estado del `TtsProvider`, éste ejecuta:

```dart
notifyListeners();
```

Todos los widgets que observan dicho Provider son reconstruidos automáticamente.

## Beneficios

- Bajo acoplamiento.
- Actualización reactiva.
- Mejor separación entre lógica y presentación.

## Componentes involucrados

```
TtsProvider

↓

notifyListeners()

↓

HomePage

↓

Widgets
```

---

# 12.2 Facade

## Problema

El paquete `flutter_tts` expone numerosos métodos de configuración que la interfaz no necesita conocer.

## Solución

Crear un `TtsService` que encapsule toda la complejidad del paquete.

La interfaz solamente interactúa con operaciones simples:

- inicializar()
- hablar()
- pausar()
- detener()

## Beneficios

- API simplificada.
- Menor acoplamiento.
- Fácil reemplazo por otro motor TTS.

---

# 12.3 Repository

**Estado:** Planificado

## Problema

Actualmente el sistema utiliza Gmail.

En futuras versiones deberá soportar:

- Outlook
- Exchange
- IMAP
- otros proveedores

Si toda la lógica depende directamente de Gmail API, el cambio afectaría a gran parte del sistema.

## Solución

Definir una interfaz común.

```text
EmailRepository

↓

GmailRepository

↓

OutlookRepository

↓

FutureProviderRepository
```

La aplicación únicamente conoce la interfaz.

## Beneficios

- Escalabilidad.
- Sustitución transparente.
- Mayor testabilidad.

---

# 12.4 Dependency Injection

## Problema

Cuando una clase crea directamente sus dependencias aumenta el acoplamiento.

## Solución

Las dependencias se inyectan mediante Providers.

Ejemplo

```
HomePage

↓

TtsProvider

↓

TtsService
```

Ninguna pantalla instancia directamente un `TtsService`.

## Beneficios

- Mayor testabilidad.
- Sustitución sencilla de implementaciones.
- Bajo acoplamiento.

---

# Relación entre patrones

| Patrón               | Problema que resuelve        |
|----------------------|------------------------------|
| Observer             | Comunicación UI ↔ Estado     |
| Facade               | Simplificación del motor TTS |
| Repository           | Acceso a datos               |
| Dependency Injection | Gestión de dependencias      |

---

# 13. Trade-offs y justificación de decisiones

Toda decisión arquitectónica implica aceptar determinadas ventajas y desventajas.

En esta sección se documentan aquellas situaciones donde no existe una solución absolutamente correcta, sino distintas
alternativas con compromisos diferentes.

---

# Trade-off 1 — Flutter vs Desarrollo Nativo

## Alternativas

### Flutter

**Ventajas**

- Código único.
- Desarrollo más rápido.
- Multiplataforma.

**Desventajas**

- Dependencia de plugins.
- Menor integración nativa.

---

### Desarrollo nativo

**Ventajas**

- Máximo rendimiento.
- Acceso completo al sistema operativo.

**Desventajas**

- Doble mantenimiento.
- Mayor tiempo de desarrollo.

---

## Decisión

Se prioriza productividad sobre rendimiento extremo.

---

# Trade-off 2 — Cliente autónomo vs Backend

## Cliente autónomo

Ventajas

- Simplicidad.
- Sin servidor.

Desventajas

- Sin sincronización.
- IA limitada.

---

## Backend

Ventajas

- Escalable.
- Centraliza lógica.
- Mejor seguridad.

Desventajas

- Mayor complejidad.

---

## Decisión

Arquitectura Cliente–Servidor.

---

# Trade-off 3 — Provider vs Riverpod

## Provider

Ventajas

- Fácil aprendizaje.
- Excelente documentación.

Desventajas

- Dependencia de BuildContext.

---

## Riverpod

Ventajas

- Mayor robustez.
- Mejor testabilidad.

Desventajas

- Mayor curva de aprendizaje.

---

## Decisión

Provider resulta suficiente para el estado actual del proyecto.

Se evaluará migración cuando el crecimiento del sistema lo justifique.

---

# Trade-off 4 — IA bajo demanda vs IA automática

## IA automática

Ventajas

- Experiencia inmediata.

Desventajas

- Alto costo.
- Procesamiento innecesario.

---

## IA bajo demanda

Ventajas

- Menor costo.
- Mejor escalabilidad.

Desventajas

- Mayor tiempo de espera para el usuario.

---

## Decisión

Generar resúmenes únicamente cuando el usuario los solicite.

---

# Trade-off 5 — Cache local vs Consistencia

## Cache local

Ventajas

- Funciona parcialmente offline.
- Mejor experiencia.

Desventajas

- Información potencialmente desactualizada.

---

## Sin cache

Ventajas

- Datos siempre actuales.

Desventajas

- Dependencia total de Internet.

---

## Decisión

Incorporar cache local a partir de la Fase 3.

---

# 14. Riesgos arquitectónicos

La arquitectura propuesta presenta riesgos conocidos que deberán gestionarse durante la evolución del sistema.

| Riesgo                           | Impacto | Probabilidad | Mitigación               |
|----------------------------------|---------|--------------|--------------------------|
| Cambios en Gmail API             | Alto    | Medio        | Repository               |
| Plugin flutter_tts discontinuado | Medio   | Medio        | Facade                   |
| Costos elevados de IA            | Alto    | Medio        | IA bajo demanda          |
| Latencia elevada                 | Medio   | Bajo         | Cache y optimización     |
| Crecimiento del backend          | Alto    | Bajo         | Arquitectura distribuida |
| Cambios en OAuth                 | Alto    | Bajo         | Actualización periódica  |

---

## Riesgo: Dependencia de terceros

MailFlow depende de diversos servicios externos.

- Gmail API
- flutter_tts
- OAuth2
- futuro proveedor IA

Estos componentes no están bajo control del proyecto.

La arquitectura intenta minimizar este riesgo encapsulando dichas dependencias detrás de Services y Repositories.

---

## Riesgo: Escalabilidad futura

Aunque actualmente el sistema será utilizado por pocos usuarios, la arquitectura fue diseñada para soportar un
crecimiento gradual.

Las decisiones tomadas permiten incorporar:

- múltiples instancias del backend;
- balanceadores de carga;
- nuevos proveedores;
- nuevos módulos de IA.

---

## Riesgo: Evolución tecnológica

Las tecnologías utilizadas pueden cambiar con el tiempo.

Para reducir el impacto:

- las dependencias externas permanecen encapsuladas;
- las decisiones quedan documentadas mediante ADR;
- los diagramas deberán mantenerse sincronizados con la implementación.

---
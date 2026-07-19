# Gmail

## Índice

- Subject vacío

---

## Subject vacío

Fecha: 2026-07

Estado: Aceptada

### Decisión

Los correos sin asunto se normalizan como "Sin asunto" dentro de gmail_service.

### Motivo

Evita propagar valores null al resto del sistema.

### Alternativas

Utilizar String?.

### Resultado

Descartado.

# Seguridad

## Índice

- Credenciales

---

## Manejo de credenciales

Fecha

2026-07

Estado

Aceptada

### Decisión

Client ID mediante .env.

Access Token mediante flutter_secure_storage.

### Motivo

Separar configuración del código y almacenar información sensible utilizando almacenamiento cifrado.

### Alternativas

Hardcodear el Client ID.

Guardar el token en SharedPreferences.

### Resultado

Descartadas.
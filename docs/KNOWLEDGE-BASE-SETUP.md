# Configuración de la Knowledge Base

> La Knowledge Base vive en este repo como `docs/knowledge-base.md`.
> Los tres prompts (A, B, C) la leen antes de ejecutar y la actualizan después.
> Accesible para todo el equipo via GitHub, con historial de versiones via git.

---

## Ubicación

```
docs/knowledge-base.md
```

Este archivo es el cerebro del sistema. Contiene datos vivos que se actualizan
con cada ejecución de los prompts.

---

## Flujo de datos

```
Prompt A (Radar diario)
  → Lee la KB antes de investigar
  → Escribe: nuevas amenazas, IOCs, actualizaciones de estado
  → Hace commit con los cambios

Prompt B (Auditor semanal)
  → Lee la KB para saber qué verificar
  → Escribe: resultados de auditoría, scorecard, issues creados

Prompt C (Vetting on-demand)
  → Lee la KB para ver si el paquete ya fue evaluado
  → Escribe: resultado de la evaluación del paquete
```

---

## Estructura de la KB

El archivo `knowledge-base.md` tiene estas secciones:

### Registro de Amenazas
Cada amenaza tiene un ID único (`THREAT-2026-XXXX`) para deduplicación.
Formato por entrada:
- Fecha detectada, estado, categoría
- Si afecta a Arkytech
- Resumen, versiones afectadas, versión segura
- IOCs, acción tomada, fuentes

### IOCs Acumulados
Tabla con: Fecha, Threat ID, Tipo (Domain/IP/Hash), Indicador, Contexto.

### Dependencias Bajo Vigilancia
Paquetes que usamos o podríamos usar que han tenido problemas.
Tabla con: Paquete, Registry, Razón, Desde, Estado.

### Decisiones de Seguridad
Registro de qué decidimos y por qué.
Tabla con: Fecha, Decisión, Contexto, Decidido por.

### Historial de Auditorías
Resultados del Prompt B.
Tabla con: Fecha, Proyecto, Scorecard, Hallazgos críticos, Issues creados.

---

## Mantenimiento

- **Diario:** El Prompt A (Radar) actualiza automáticamente con nuevas amenazas
- **Semanal (viernes):** Guillermo hace limpieza — marcar amenazas resueltas, eliminar IOCs obsoletos
- **Después de auditoría:** El Prompt B registra resultados en la sección de Historial

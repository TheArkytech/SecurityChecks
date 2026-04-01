# Auto-Mejora del Sistema de Seguridad

> Este archivo es un registro vivo de sugerencias para mejorar el propio
> sistema de seguridad (prompts, KB, checks, cobertura). Los Prompts A y B
> escriben sugerencias aquí. Guillermo las revisa y aprueba los viernes.

---

## Cómo funciona

1. **Prompt A (Radar)** — Después de cada escaneo diario, evalúa si el sistema
   de seguridad tiene gaps y registra sugerencias aquí
2. **Prompt B (Auditor)** — Después de cada auditoría, evalúa si los checklists
   de auditoría necesitan mejoras y registra sugerencias aquí
3. **Viernes** — Guillermo revisa las sugerencias, aprueba las que tengan sentido,
   y las implementa (o pide a Claude que las implemente)

---

## Categorías de mejora

- **PROMPT** — Mejoras a los prompts (nuevas áreas de investigación, mejor formato, etc.)
- **KB** — Nuevas secciones o campos para la Knowledge Base
- **CHECK** — Nuevos checks para añadir al Prompt B (auditor)
- **COVERAGE** — Áreas de seguridad no cubiertas actualmente
- **PROCESS** — Mejoras al proceso o cadencia
- **TOOLING** — Herramientas o integraciones a considerar

---

## Sugerencias pendientes

<!-- Formato:
### [YYYY-MM-DD] [CATEGORÍA] Título corto
- **Origen:** Prompt A / Prompt B / Manual
- **Descripción:** Qué mejorar y por qué
- **Impacto:** Alto / Medio / Bajo
- **Esfuerzo:** Alto / Medio / Bajo
-->

_Sin sugerencias pendientes aún. Se irán añadiendo con cada ejecución de los prompts._

---

## Sugerencias implementadas

<!-- Mover aquí las sugerencias que se aprueben e implementen -->

| Fecha implementada | Categoría | Descripción | Origen |
|---|---|---|---|
| | | | |

---

## Instrucciones para los prompts

### Para Prompt A (añadir al final de cada ejecución):
Después de completar el reporte diario, reflexiona brevemente:
- ¿Hubo algún área de seguridad que no pudiste cubrir bien? ¿Por qué?
- ¿El formato del reporte fue adecuado o algo podría mejorar?
- ¿Hay fuentes de información que deberías consultar pero no están en tus instrucciones?
- ¿La Knowledge Base tiene la estructura adecuada para lo que encontraste hoy?

Si identificas algo, añade una entrada en la sección "Sugerencias pendientes"
de `docs/SELF-IMPROVEMENT.md`.

### Para Prompt B (añadir al final de cada ejecución):
Después de completar la auditoría, reflexiona brevemente:
- ¿Hubo vulnerabilidades que buscaste pero tu checklist no cubría?
- ¿Alguna categoría del checklist está obsoleta o incompleta?
- ¿El scorecard refleja bien la postura de seguridad del proyecto?
- ¿Necesitas acceso a herramientas o datos que no tienes?

Si identificas algo, añade una entrada en la sección "Sugerencias pendientes"
de `docs/SELF-IMPROVEMENT.md`.

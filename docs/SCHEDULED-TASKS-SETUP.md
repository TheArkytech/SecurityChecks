# Configuración de Tareas Programadas en Claude Code

> Las tareas programadas se configuran en la **interfaz web de Claude Code**,
> no en estos archivos .md. Los archivos de prompts son solo referencia.

---

## Cómo funciona

Claude Code permite crear **scheduled agents** que se ejecutan automáticamente
en un horario definido. Cada ejecución es una sesión remota aislada que:

1. Clona el repositorio especificado
2. Ejecuta el prompt con las herramientas permitidas
3. Puede hacer commits con los resultados
4. Se apaga al terminar

La frecuencia se controla desde la interfaz web, no desde los archivos .md.

---

## Tareas programadas activas

| Tarea | Prompt | Modelo | Horario | Repo |
|---|---|---|---|---|
| Security Radar | [PROMPT-A-RADAR.md](PROMPT-A-RADAR.md) | Sonnet 4.6 | Diario 08:00 Europe/Paris | TheArkytech/SecurityChecks |

---

## Cómo crear o modificar tareas programadas

### Desde Claude Code CLI

Usar el comando `/schedule` dentro de Claude Code para crear, listar o
ejecutar tareas programadas.

### Desde la interfaz web

1. Ir a https://claude.ai/code/scheduled
2. Crear nueva tarea o editar una existente
3. Configurar: nombre, cron expression, modelo, repo, prompt, herramientas

### Configuración del Radar (referencia)

```
Nombre: Arkytech Security Radar (Prompt A)
Cron: 0 6 * * * (6:00 UTC = 8:00 Europe/Paris en verano)
Modelo: claude-sonnet-4-6
Repo: https://github.com/TheArkytech/SecurityChecks
Herramientas: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
```

---

## Tareas futuras a considerar

| Tarea | Prompt | Modelo | Horario sugerido |
|---|---|---|---|
| Code Auditor semanal | PROMPT-B-AUDITOR.md | Opus 4.6 | Lunes 09:00 Europe/Paris |

> **Nota sobre Prompt B:** Actualmente se ejecuta manualmente porque requiere
> interacción (preguntas sobre alcance). Podría automatizarse con un prompt
> que defina el alcance por defecto (ej: auditar ArkyHub cada lunes).

> **Nota sobre Prompt C:** Es on-demand por naturaleza. No se programa.

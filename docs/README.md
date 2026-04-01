# Arkytech Security System v2 — Documentacion

> Sistema modular de ciberseguridad para equipos de desarrollo
> que trabajan con AI-assisted coding (vibe coding).
> Diseñado para ser ejecutado por Claude.

---

## Arquitectura del Sistema

```
                    ┌─────────────────────────┐
                    │   KNOWLEDGE BASE        │
                    │   (Google Doc vivo)      │
                    │                         │
                    │  - Amenazas detectadas   │
                    │  - IOCs acumulados       │
                    │  - Historial de alertas  │
                    │  - Decisiones tomadas    │
                    └────────┬────────────────┘
                             │
                    Lee antes │ Escribe después
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ PROMPT A │  │ PROMPT B │  │ PROMPT C │
        │  RADAR   │  │ AUDITOR  │  │ VETTING  │
        │  Diario  │  │ Semanal  │  │ On-demand│
        └──────────┘  └──────────┘  └──────────┘
         Investiga     Revisa tu     Evalúa antes
         qué pasa      código        de instalar
         afuera        real          algo nuevo

        Sonnet 4.6     Opus 4.6      Sonnet 4.6

        Trigger:       Trigger:      Trigger:
        Cada mañana    A encuentra   npm/pip install
                       algo que      o AI sugiere
                       nos afecta    dependencia
```

---

## Cadencia

| Actividad | Modelo | Frecuencia | Quién | Duración |
|---|---|---|---|---|
| **Prompt A** (Radar) | Sonnet 4.6 | Diario, por la mañana | Guillermo | 15-20 min |
| **Prompt B** (Auditor) | Opus 4.6 | Semanal + cuando A lo pida | Guillermo/Daniel | 30-45 min |
| **Prompt C** (Vetting) | Sonnet 4.6 | Cada nueva dependencia | Quien la instale | 5 min |
| **Review KB** | — | Viernes (limpieza semanal) | Guillermo | 10 min |
| **GitHub security tab** | — | Semanal | Daniel | 5 min |
| **npm audit** | — | Automático en CI | CI/CD | Automático |
| **Dependabot PRs** | — | Cuando lleguen | Daniel | Variable |

---

## Documentos

| Documento | Descripción |
|---|---|
| [PROMPT-A-RADAR.md](PROMPT-A-RADAR.md) | Escaneo diario de ciberseguridad (automatizado) |
| [PROMPT-B-AUDITOR.md](PROMPT-B-AUDITOR.md) | Auditoría de código semanal (manual) |
| [PROMPT-C-VETTING.md](PROMPT-C-VETTING.md) | Evaluación pre-instalación de dependencias (manual) |
| [KNOWLEDGE-BASE-SETUP.md](KNOWLEDGE-BASE-SETUP.md) | Guía de configuración de la Knowledge Base en Google Docs |
| [IMPROVEMENTS.md](IMPROVEMENTS.md) | Roadmap de mejoras de seguridad |
| [SCHEDULED-TASKS-SETUP.md](SCHEDULED-TASKS-SETUP.md) | Configuración de tareas programadas en Claude Code |

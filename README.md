# SecurityChecks

Sistema modular de ciberseguridad de Arkytech para equipos de desarrollo
que trabajan con AI-assisted coding (vibe coding). Diseñado para ser
ejecutado por Claude.

## Quick Start

1. Copiar `.npmrc` a cada proyecto Node.js del equipo
2. Instalar pre-commit hooks: `pre-commit install` (requiere [gitleaks](https://github.com/gitleaks/gitleaks))
3. La Knowledge Base ya está lista en `docs/knowledge-base.md` — ver [KNOWLEDGE-BASE-SETUP.md](docs/KNOWLEDGE-BASE-SETUP.md) para detalles

## Estructura

```
SecurityChecks/
├── README.md
├── .npmrc                             # npm hardening
├── .pre-commit-config.yaml            # gitleaks pre-commit hook
└── docs/
    ├── README.md                      # Arquitectura + cadencia
    ├── PROMPT-A-RADAR.md              # Radar diario (Sonnet 4.6)
    ├── PROMPT-B-AUDITOR.md            # Auditor semanal (Opus 4.6)
    ├── PROMPT-C-VETTING.md            # Vetting on-demand (Sonnet 4.6)
    ├── KNOWLEDGE-BASE-SETUP.md        # Guía de la Knowledge Base
    ├── knowledge-base.md              # KB viva: amenazas, IOCs, decisiones
    ├── IMPROVEMENTS.md                # Roadmap de mejoras
    ├── SELF-IMPROVEMENT.md            # Auto-mejora del sistema
    └── SCHEDULED-TASKS-SETUP.md       # Tareas programadas
```

## Componentes

| Componente | Archivo | Modelo | Frecuencia | Descripción |
|---|---|---|---|---|
| Radar | [PROMPT-A-RADAR.md](docs/PROMPT-A-RADAR.md) | Sonnet 4.6 | Diario (automatizado) | Escaneo de ciberseguridad global |
| Auditor | [PROMPT-B-AUDITOR.md](docs/PROMPT-B-AUDITOR.md) | Opus 4.6 | Semanal / triggered | Auditoría de código fuente |
| Vetting | [PROMPT-C-VETTING.md](docs/PROMPT-C-VETTING.md) | Sonnet 4.6 | On-demand | Evaluación pre-instalación de dependencias |

## Documentación

- [Arquitectura del sistema](docs/README.md) — Diagrama, cadencia, navegación
- [Knowledge Base Setup](docs/KNOWLEDGE-BASE-SETUP.md) — Estructura y mantenimiento de la KB
- [Mejoras de seguridad](docs/IMPROVEMENTS.md) — Roadmap con 12 mejoras priorizadas
- [Auto-mejora](docs/SELF-IMPROVEMENT.md) — Sugerencias de mejora generadas por los prompts
- [Tareas programadas](docs/SCHEDULED-TASKS-SETUP.md) — Configuración de scheduled agents

## Hardening incluido

- **`.npmrc`** — `ignore-scripts=true`, `audit=true`, `audit-level=high`
- **`.pre-commit-config.yaml`** — Gitleaks v8.22.1 para detectar secretos antes del commit

# SecurityChecks

Sistema modular de ciberseguridad de Arkytech para equipos de desarrollo
que trabajan con AI-assisted coding (vibe coding).

## Estructura

```
SecurityChecks/
├── docs/
│   ├── security-system.md    # Arquitectura completa + mejoras a implementar
│   └── knowledge-base.md     # KB viva: amenazas, IOCs, decisiones
├── prompts/
│   ├── prompt-a-radar.md     # Escaneo diario de ciberseguridad (automatizado)
│   ├── prompt-b-auditor.md   # Auditoría de código semanal (manual)
│   └── prompt-c-vetting.md   # Evaluación pre-instalación de dependencias (manual)
└── README.md
```

## Cómo usar

| Prompt | Cuándo | Cómo |
|--------|--------|------|
| **A - Radar** | Cada mañana (automático) | Scheduled agent en Claude Code |
| **B - Auditor** | Semanal o cuando A lo pida | Abrir Claude Code en el proyecto a auditar y pegar el prompt |
| **C - Vetting** | Antes de instalar cualquier dependencia nueva | Pegar el prompt rellenando paquete, registry, proyecto y quién lo sugirió |

## Knowledge Base

El archivo `docs/knowledge-base.md` es el cerebro del sistema. Los tres prompts
lo leen antes de ejecutar y lo actualizan después. Contiene:

- Registro de amenazas con IDs únicos (THREAT-2026-XXXX)
- IOCs acumulados (dominios, IPs, hashes)
- Dependencias bajo vigilancia
- Decisiones de seguridad tomadas
- Historial de auditorías

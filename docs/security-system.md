# Arkytech Security System v2

> Sistema modular de ciberseguridad para equipos de desarrollo
> que trabajan con AI-assisted coding (vibe coding).
> Diseñado para ser ejecutado por Claude.

---

## Arquitectura del Sistema

```
                    ┌─────────────────────────┐
                    │   KNOWLEDGE BASE        │
                    │   (knowledge-base.md)   │
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

        Trigger:       Trigger:      Trigger:
        Cada mañana    A encuentra   npm/pip install
                       algo que      o AI sugiere
                       nos afecta    dependencia
```

---

## Cadencia

| Actividad | Frecuencia | Quién | Duración |
|---|---|---|---|
| **Prompt A** (Radar) | Diario, por la mañana | Guillermo | 15-20 min |
| **Prompt B** (Auditor) | Semanal + cuando A lo pida | Guillermo/Daniel | 30-45 min |
| **Prompt C** (Vetting) | Cada nueva dependencia | Quien la instale | 5 min |
| **Review KB** | Viernes (limpieza semanal) | Guillermo | 10 min |
| **GitHub security tab** | Semanal | Daniel | 5 min |
| **npm audit** | Automático en CI | CI/CD | Automático |
| **Dependabot PRs** | Cuando lleguen | Daniel | Variable |

---

## Mejoras Adicionales a Implementar

### Inmediato (esta semana)

#### 1. `.npmrc` en todos los proyectos
```ini
ignore-scripts=true
package-lock=true
audit=true
audit-level=high
```

#### 2. GitHub: Activar features de seguridad gratuitos
- **Dependabot alerts** → Se activa en Settings > Security
- **Secret scanning** → Detecta API keys commiteadas por accidente
- **Push protection** → Bloquea push si contiene un secreto detectado
- **Branch protection** en main → Require PR reviews

#### 3. Pre-commit hook para secretos
```bash
# Instalar gitleaks
brew install gitleaks  # macOS

# Añadir como pre-commit hook
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.22.1
    hooks:
      - id: gitleaks
```

#### 4. npm audit en CI
```yaml
# En GitHub Actions, añadir step:
- name: Security audit
  run: npm audit --audit-level=high
```

### Corto plazo (este mes)

#### 5. Socket.dev (gratis para open source)
Monitorea tus dependencias y te alerta de paquetes comprometidos
en tiempo real. Tiene GitHub App que comenta en PRs.

#### 6. Pinning de GitHub Actions por SHA
```yaml
# Inseguro (tag mutable, puede ser hijackeado)
- uses: actions/checkout@v4

# Seguro (SHA inmutable)
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
```

Herramienta para automatizar: StepSecurity `secure-repo`

#### 7. Lockfile enforcement en CI
```yaml
# Usar npm ci en vez de npm install en CI
- name: Install dependencies
  run: npm ci --ignore-scripts
```

#### 8. SBOM generation
```bash
npx @cyclonedx/cyclonedx-npm --output-file sbom.json
```

### Medio plazo (próximos 2-3 meses)

#### 9. Monitoreo de credenciales filtradas
- Configurar alertas en HaveIBeenPwned para emails del equipo
- GitHub secret scanning partner program

#### 10. Network-level protections
- Bloquear dominios C2 conocidos a nivel de DNS (IOCs de la Knowledge Base)
- Considerar Cloudflare Gateway o similar para el equipo

#### 11. MCP Server security
Dado que conectáis varios MCP servers (Linear, Notion, Gmail, Calendar, Vercel, Gamma), revisar periódicamente:
- Qué permisos tiene cada uno
- Si alguno ha tenido incidentes de seguridad
- Si los tokens de conexión se rotan

#### 12. Revisar configuración de Cursor / Claude Code
- Verificar que los archivos .cursorrules y configs de AI tools en repos son legítimos
- No aceptar automáticamente rules files de repos clonados
- Revisar qué contexto se envía a los AI providers

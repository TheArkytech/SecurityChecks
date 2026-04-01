# Mejoras de Seguridad — Roadmap

Mejoras ordenadas por impacto/esfuerzo. Marcar cada una al completarla.

---

## Inmediato (esta semana)

- [x] **1. `.npmrc` en todos los proyectos**
  ```ini
  ignore-scripts=true
  package-lock=true
  audit=true
  audit-level=high
  ```
  Archivo base incluido en este repo. Copiar a cada proyecto.

- [ ] **2. GitHub: Activar features de seguridad gratuitos**
  - **Dependabot alerts** → Se activa en Settings > Security
  - **Secret scanning** → Detecta API keys commiteadas por accidente
  - **Push protection** → Bloquea push si contiene un secreto detectado
  - **Branch protection** en main → Require PR reviews

- [x] **3. Pre-commit hook para secretos**
  ```bash
  # Instalar gitleaks
  brew install gitleaks  # macOS
  ```
  Archivo `.pre-commit-config.yaml` incluido en este repo. Activar con `pre-commit install`.

- [ ] **4. npm audit en CI**
  ```yaml
  # En GitHub Actions, añadir step:
  - name: Security audit
    run: npm audit --audit-level=high
  ```

---

## Corto plazo (este mes)

- [ ] **5. Socket.dev (gratis para open source)**
  Monitorea tus dependencias y te alerta de paquetes comprometidos
  en tiempo real. Tiene GitHub App que comenta en PRs.

- [ ] **6. Pinning de GitHub Actions por SHA**
  ```yaml
  # Inseguro (tag mutable, puede ser hijackeado)
  - uses: actions/checkout@v4

  # Seguro (SHA inmutable)
  - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
  ```
  Herramienta para automatizar: StepSecurity `secure-repo`

- [ ] **7. Lockfile enforcement en CI**
  ```yaml
  # Usar npm ci en vez de npm install en CI
  - name: Install dependencies
    run: npm ci --ignore-scripts
  ```

- [ ] **8. SBOM generation**
  ```bash
  npx @cyclonedx/cyclonedx-npm --output-file sbom.json
  ```

---

## Medio plazo (próximos 2-3 meses)

- [ ] **9. Monitoreo de credenciales filtradas**
  - Configurar alertas en HaveIBeenPwned para emails del equipo
  - GitHub secret scanning partner program

- [ ] **10. Network-level protections**
  - Bloquear dominios C2 conocidos a nivel de DNS (IOCs de la Knowledge Base)
  - Considerar Cloudflare Gateway o similar para el equipo

- [ ] **11. MCP Server security**
  Dado que conectáis varios MCP servers (Linear, Notion, Gmail, Calendar, Vercel, Gamma), revisar periódicamente:
  - Qué permisos tiene cada uno
  - Si alguno ha tenido incidentes de seguridad
  - Si los tokens de conexión se rotan

- [ ] **12. Revisar configuración de Cursor / Claude Code**
  - Verificar que los archivos .cursorrules y configs de AI tools en repos son legítimos
  - No aceptar automáticamente rules files de repos clonados
  - Revisar qué contexto se envía a los AI providers

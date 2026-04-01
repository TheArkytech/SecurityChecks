# Prompt C — Dependency Vetting (Pre-Instalación)

> **Frecuencia:** SIEMPRE antes de instalar algo nuevo.
> **Especialmente crítico cuando la dependencia la sugirió una AI.**

---

Voy a instalar una nueva dependencia.

**Paquete:** [NOMBRE]
**Registry:** [npm / PyPI / cargo / otro]
**Proyecto destino:** [cuál]
**¿Quién lo sugirió?:** [Yo / Claude Code / Cursor / Antigravity / Copilot]

---

Consulta la Knowledge Base (`docs/knowledge-base.md` en el repo
SecurityChecks) para ver si este paquete ya fue evaluado o si está
bajo vigilancia.

Luego busca en la web y evalúa:

### 1. ¿Existe realmente?
- Verificar en el registry oficial (npmjs.com / pypi.org)
- Si lo sugirió una AI: ¿podría ser una alucinación (slopsquat)?
- ¿El nombre es exactamente correcto? ¿Hay typosquats?

### 2. ¿Es confiable?
- Mantenedor(es): ¿quién? ¿cuántos? ¿empresa o individuo?
- Actividad: último release, último commit, issues abiertos
- ¿Usa trusted publishing (OIDC) o tokens clásicos?
- Downloads semanales y tendencia

### 3. ¿Es seguro?
- CVEs históricas
- ¿Ha sido comprometido anteriormente?
- GitHub Advisory Database
- Socket.dev score si disponible
- ¿Tiene postinstall scripts? ¿Qué hacen?
- Número de dependencias transitivas

### 4. ¿Es necesario?
- ¿Hay alternativa nativa o ya incluida en nuestro framework?
- ¿Hay opción con menos dependencias?
- ¿Podemos escribir la funcionalidad nosotros (~50 líneas)?

### 5. Veredicto

- **INSTALAR** — Seguro, confiable, necesario
- **INSTALAR CON PRECAUCIÓN** — [qué precauciones]
- **BUSCAR ALTERNATIVA** — [por qué y cuáles]
- **NO INSTALAR** — [razón concreta]

Si se aprueba → Comando con versión exacta pinneada.
Registrar evaluación en la Knowledge Base.

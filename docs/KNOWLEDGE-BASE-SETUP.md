# Configuración de la Knowledge Base (Google Doc)

> La Knowledge Base es un Google Doc compartido entre Guillermo y Daniel.
> Los tres prompts (A, B, C) la leen antes de ejecutar y la actualizan después.

---

## Por qué Google Doc

- Accesible para ambos miembros del equipo
- Claude puede leerlo y actualizarlo
- Tiene historial de versiones
- Es buscable

---

## Cómo crear el Google Doc

1. Crear un nuevo Google Doc
2. Nombrarlo: **Arkytech Security KB — 2026**
3. Compartirlo con Daniel (permisos de edición)
4. Copiar la plantilla completa de abajo en el documento

---

## Flujo de datos

```
Prompt A (Radar diario)
  → Lee la KB antes de investigar
  → Escribe: nuevas amenazas, IOCs, actualizaciones de estado

Prompt B (Auditor semanal)
  → Lee la KB para saber qué verificar
  → Escribe: resultados de auditoría, scorecard, issues creados

Prompt C (Vetting on-demand)
  → Lee la KB para ver si el paquete ya fue evaluado
  → Escribe: resultado de la evaluación del paquete
```

---

## Plantilla completa

Copiar todo lo siguiente en el Google Doc:

````markdown
# Arkytech Security Knowledge Base — 2026

## Índice
- Registro de Amenazas
- IOCs Acumulados
- Dependencias Bajo Vigilancia
- Decisiones de Seguridad
- Historial de Auditorías (Prompt B)

---

## Registro de Amenazas

<!-- Formato por entrada: -->
<!-- Cada amenaza tiene un ID único para deduplicación -->

### [THREAT-2026-XXXX] Nombre descriptivo de la amenaza
- **Fecha detectada:** YYYY-MM-DD
- **Estado:** 🔴 Activo → 🟡 Remediado parcialmente → 🟢 Resuelto
- **Categoría:** Supply Chain / AI Dev / Infra / Threat Actor / CVE / Breach
- **Afecta a Arkytech:** Sí / No / Potencialmente
- **Resumen:** [2-3 líneas describiendo la amenaza]
- **Versiones afectadas:** [si aplica]
- **Versión segura:** [si aplica]
- **IOCs:** [dominios, IPs, hashes]
- **Acción tomada:** [lo que hicimos]
- **Última actualización:** YYYY-MM-DD
- **Fuentes:** [links]

---

## IOCs Acumulados

| Fecha | Threat ID | Tipo | Indicador | Contexto |
|-------|-----------|------|-----------|----------|
| YYYY-MM-DD | THREAT-2026-XXXX | Domain/IP/Hash | indicador[.]com | Descripción |

---

## Dependencias Bajo Vigilancia

<!-- Paquetes que usamos o podríamos usar que han tenido problemas -->

| Paquete | Registry | Razón de vigilancia | Desde | Estado |
|---------|----------|---------------------|-------|--------|
| nombre | npm/PyPI | Razón | YYYY-MM-DD | Vigilar/Cuidado/Bloqueado |

---

## Decisiones de Seguridad

<!-- Registro de qué decidimos y por qué -->

| Fecha | Decisión | Contexto | Decidido por |
|-------|----------|----------|-------------|
| YYYY-MM-DD | Descripción | Por qué | Quién |

---

## Historial de Auditorías (Prompt B)

| Fecha | Proyecto | Scorecard | Hallazgos críticos | Issues creados |
|-------|----------|-----------|---------------------|----------------|
| YYYY-MM-DD | Nombre | X/10 | Descripción | #123, #124 |
````

---

## Datos iniciales de ejemplo

Estos datos pueden copiarse como primeras entradas al crear la KB:

**Amenaza inicial:**
- `[THREAT-2026-0001]` Axios npm supply chain compromise
- Fecha: 2026-04-01, Estado: Activo
- IOCs: sfrclak[.]com, 142.11.206.73
- Versiones afectadas: axios@1.14.1, axios@0.30.4

**IOCs iniciales:**
| 2026-04-01 | THREAT-2026-0001 | Domain | sfrclak[.]com | Axios C2 |
| 2026-04-01 | THREAT-2026-0001 | IP | 142.11.206.73 | Axios C2 |
| 2026-03-27 | THREAT-2026-0002 | Domain | models.litellm[.]cloud | TeamPCP C2 |

**Dependencias bajo vigilancia:**
| axios | npm | Comprometido 2026-03-31 | 2026-04-01 | Vigilar |
| crypto-js | npm | Typosquat target | 2026-04-01 | Cuidado |

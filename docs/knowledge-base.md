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

### [THREAT-2026-0001] Axios npm supply chain compromise
- **Fecha detectada:** 2026-04-01
- **Estado:** 🔴 Activo
- **Categoría:** Supply Chain > npm
- **Afecta a Arkytech:** Potencialmente
- **Resumen:** Cuenta del mantenedor principal comprometida, versiones
  1.14.1 y 0.30.4 publicadas con RAT multiplataforma vía plain-crypto-js.
  Atribuido a UNC1069 (actor norcoreano).
- **Versiones afectadas:** axios@1.14.1, axios@0.30.4
- **Versión segura:** axios@1.14.0 o anterior
- **IOCs:** sfrclak[.]com, 142.11.206.73
- **Acción tomada:** Pendiente de verificar si usamos axios en algún proyecto
- **Última actualización:** 2026-04-01
- **Fuentes:** Pendiente de agregar enlaces

---

## IOCs Acumulados

| Fecha | Threat ID | Tipo | Indicador | Contexto |
|-------|-----------|------|-----------|----------|
| 2026-04-01 | THREAT-2026-0001 | Domain | sfrclak[.]com | Axios C2 |
| 2026-04-01 | THREAT-2026-0001 | IP | 142.11.206.73 | Axios C2 |
| 2026-03-27 | THREAT-2026-0002 | Domain | models.litellm[.]cloud | TeamPCP C2 |

---

## Dependencias Bajo Vigilancia

<!-- Paquetes que usamos o podríamos usar que han tenido problemas -->

| Paquete | Registry | Razón de vigilancia | Desde | Estado |
|---------|----------|---------------------|-------|--------|
| axios | npm | Comprometido 2026-03-31 | 2026-04-01 | Vigilar |
| crypto-js | npm | Typosquat target | 2026-04-01 | Cuidado |

---

## Decisiones de Seguridad

<!-- Registro de qué decidimos y por qué -->

| Fecha | Decisión | Contexto | Decidido por |
|-------|----------|----------|-------------|
| 2026-04-01 | Activar ignore-scripts en .npmrc | Post-axios | Guillermo |
| 2026-04-01 | Implementar Arkytech Security System v2 | Protección proactiva | Guillermo |

---

## Historial de Auditorías (Prompt B)

| Fecha | Proyecto | Scorecard | Hallazgos críticos | Issues creados |
|-------|----------|-----------|---------------------|----------------|
| | | | | |

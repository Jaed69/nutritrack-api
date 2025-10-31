# Asignación de Módulos - NutriTrack API

**Fecha de actualización:** Octubre 2025

## 📊 Distribución de Módulos

| # | Módulo | Responsable(s) | User Stories | Estado | Progreso |
|---|--------|----------------|--------------|--------|----------|
| 1 | **Gestión de Cuentas y Preferencias** | Leonel Alzamora | US-01 a US-05 | � Planificado | 0% |
| 2 | **Biblioteca de Contenido (Admin)** | Fabian Rojas, Gonzalo Huaranga, Victor Carranza | US-06 a US-10 | 🟡 Planificado | 0% |
| 3 | **Gestor de Catálogo (Admin)** | Gonzalo Huaranga, Victor Carranza | US-11 a US-15 | � Planificado | 0% |
| 4 | **Exploración y Activación (Cliente)** | Gonzalo Huaranga, Victor Carranza | US-16 a US-20 | 🟡 Planificado | 0% |
| 5 | **Seguimiento de Progreso (Cliente)** | Gonzalo Huaranga, Jhamil Peña, Victor Carranza | US-21 a US-25 | � Planificado | 0% |

**Leyenda:**
- 🟢 En progreso
- 🟡 Planificado
- 🔴 Bloqueado
- ✅ Completado

## 📋 Responsabilidades por Módulo

### 1️⃣ Gestión de Cuentas y Preferencias

**Responsable:** Leonel Alzamora

**User Stories Asignadas:** US-01 a US-05

**Componentes:**
- `CuentaAuth` - Gestión de cuentas de usuario
- `PerfilUsuario` - Información personal
- `UsuarioPerfilSalud` - Objetivos, alergias y condiciones
- `AuthController` - Endpoints de autenticación
- `PerfilUsuarioController` - Gestión de preferencias
- `SecurityConfig` - Configuración de seguridad

**Tareas Principales:**
- [ ] US-01: Crear cuenta con validaciones (email, contraseña)
- [ ] US-02: Iniciar sesión con JWT
- [ ] US-03: Configurar unidades de medida
- [ ] US-04: Editar perfil de salud (objetivos, alergias, condiciones)
- [ ] US-05: Eliminar cuenta con confirmación
- [ ] Tests de validación y seguridad

**Documentación:** [docs/modules/cuentas-preferencias.md](docs/modules/cuentas-preferencias.md)

---

### 2️⃣ Biblioteca de Contenido (Admin)

**Responsables:** 
- Fabian Rojas (US-06, US-07)
- Gonzalo Huaranga (US-08)
- Victor Carranza (US-09, US-10)

**User Stories Asignadas:** US-06 a US-10

**Componentes:**
- `Etiqueta` - Etiquetas maestras del sistema
- `Ingrediente` - Ingredientes con etiquetas
- `Ejercicio` - Ejercicios con dificultad y tipo
- `Comida` - Comidas con categorías
- `Receta` - Relación comida-ingrediente con cantidades
- `EtiquetaController` - CRUD de etiquetas
- `IngredienteController` - CRUD de ingredientes
- `EjercicioController` - CRUD de ejercicios
- `ComidaController` - CRUD de comidas

**Tareas Principales:**
- [ ] US-06: CRUD de etiquetas maestras (Fabian)
- [ ] US-07: Gestión de ingredientes con etiquetas (Fabian)
- [ ] US-08: Gestión de ejercicios con etiquetas (Gonzalo)
- [ ] US-09: Gestión de comidas con etiquetas (Victor)
- [ ] US-10: Gestión de recetas (ingredientes + cantidades) (Victor)
- [ ] Validaciones de dependencias y duplicados
- [ ] Tests unitarios e integración

**Documentación:** [docs/modules/biblioteca-contenido.md](docs/modules/biblioteca-contenido.md)

---

### 3️⃣ Gestor de Catálogo (Admin)

**Responsables:**
- Gonzalo Huaranga (US-11, US-12, US-13)
- Victor Carranza (US-14, US-15)

**User Stories Asignadas:** US-11 a US-15

**Componentes:**
- `CatalogoMeta` - Metas del catálogo
- `CatalogoActividad` - Actividades de cada meta
- `CatalogoRutina` - Rutinas de ejercicios (series, reps)
- `EtiquetaMeta` - Relación meta-etiqueta
- `CatalogoMetaController` - Gestión de metas
- `CatalogoActividadController` - Gestión de actividades

**Tareas Principales:**
- [ ] US-11: Crear metas del catálogo (Gonzalo)
- [ ] US-12: Asignar etiquetas y actividades a metas (Gonzalo)
- [ ] US-13: Ver catálogo de metas para admin (Gonzalo)
- [ ] US-14: Eliminar metas con validación de uso (Victor)
- [ ] US-15: Ensamblar rutinas (ejercicios + series/reps) (Victor)
- [ ] Validaciones de dependencias
- [ ] Tests unitarios e integración

**Documentación:** [docs/modules/gestor-catalogo.md](docs/modules/gestor-catalogo.md)

---

### 4️⃣ Exploración y Activación (Cliente)

**Responsables:**
- Gonzalo Huaranga (US-16, US-17, US-18)
- Victor Carranza (US-19, US-20)

**User Stories Asignadas:** US-16 a US-20

**Componentes:**
- `CatalogoMetaController` - Vista de catálogo para cliente
- `UsuarioMetaAsignada` - Metas asignadas a usuario
- `UsuarioMetaAsignadaService` - Lógica de activación/gestión
- `FiltroPerfilService` - Filtrado por perfil de salud

**Tareas Principales:**
- [ ] US-16: Ver catálogo con filtros personalizados (Gonzalo)
- [ ] US-17: Ver detalle de meta con avisos (Gonzalo)
- [ ] US-18: Activar meta con validaciones (Gonzalo)
- [ ] US-19: Pausar y reanudar meta (Victor)
- [ ] US-20: Completar o cancelar meta (Victor)
- [ ] Sistema de filtrado por alergias y condiciones
- [ ] Tests de casos de uso

**Documentación:** [docs/modules/exploracion-activacion.md](docs/modules/exploracion-activacion.md)

---

### 5️⃣ Seguimiento de Progreso (Cliente)

**Responsables:**
- Gonzalo Huaranga (US-21, US-22, US-23)
- Jhamil Peña (US-21)
- Victor Carranza (US-24, US-25)

**User Stories Asignadas:** US-21 a US-25

**Componentes:**
- `UsuarioActividadProgreso` - Actividades completadas
- `UsuarioHistorialMedida` - Mediciones corporales
- `ActividadProgresoService` - Lógica de seguimiento
- `ReporteService` - Generación de reportes PDF
- `GraficoService` - Datos para gráficos

**Tareas Principales:**
- [ ] US-21: Ver actividades del plan con estado (Gonzalo, Jhamil)
- [ ] US-22: Marcar actividad como completada (Gonzalo)
- [ ] US-23: Desmarcar actividad (Gonzalo)
- [ ] US-24: Registrar mediciones con validaciones (Victor)
- [ ] US-25: Ver gráficos y generar reportes PDF (Victor)
- [ ] Validaciones de estado de meta
- [ ] Tests unitarios e integración

**Documentación:** [docs/modules/seguimiento-progreso.md](docs/modules/seguimiento-progreso.md)

---

## 📅 Cronograma General

### Sprint 1 (Semanas 1-2) - Fundamentos
- **Módulo 1:** US-01, US-02 - Crear cuenta e iniciar sesión (Leonel)
- **Módulo 2:** US-06 - Gestionar etiquetas maestras (Fabian)
- **Infraestructura:** Configuración base, excepciones, CORS

### Sprint 2 (Semanas 3-4) - Biblioteca de Contenido
- **Módulo 1:** US-03, US-04, US-05 - Preferencias y perfil de salud (Leonel)
- **Módulo 2:** US-07, US-08 - Ingredientes y ejercicios (Fabian, Gonzalo)
- **Módulo 2:** US-09, US-10 - Comidas y recetas (Victor)

### Sprint 3 (Semanas 5-6) - Catálogo y Exploración
- **Módulo 3:** US-11, US-12, US-13 - Gestión de metas (Gonzalo)
- **Módulo 3:** US-14, US-15 - Eliminar metas y rutinas (Victor)
- **Módulo 4:** US-16, US-17 - Ver catálogo y detalles (Gonzalo)

### Sprint 4 (Semanas 7-8) - Activación y Progreso
- **Módulo 4:** US-18, US-19, US-20 - Activar y gestionar metas (Gonzalo, Victor)
- **Módulo 5:** US-21, US-22, US-23 - Seguimiento de actividades (Gonzalo, Jhamil)
- **Módulo 5:** US-24, US-25 - Mediciones y reportes (Victor)
- **Testing:** Tests de integración completos
- **Deployment:** Configuración de ambientes

---

## 🔄 Dependencias entre Módulos

```
┌─────────────────────────────────┐
│ Módulo 1: Cuentas y Preferencias │ (Base - US-01 a US-05)
└────────────┬────────────────────┘
             │
    ┌────────┴────────┐
    │                 │
┌───▼─────────────────▼────┐
│ Módulo 2: Biblioteca     │ (Admin - US-06 a US-10)
│ Contenido (Etiquetas,    │
│ Ingredientes, Ejercicios)│
└───┬──────────────────────┘
    │
┌───▼──────────────────────┐
│ Módulo 3: Gestor         │ (Admin - US-11 a US-15)
│ Catálogo (Metas)         │
└───┬──────────────────────┘
    │
    ├──────────────────────┐
    │                      │
┌───▼───────────────┐  ┌──▼─────────────────┐
│ Módulo 4:         │  │ Módulo 5:          │
│ Exploración y     │→ │ Seguimiento de     │
│ Activación        │  │ Progreso           │
│ (US-16 a US-20)   │  │ (US-21 a US-25)    │
└───────────────────┘  └────────────────────┘
```

**Orden de desarrollo sugerido:**
1. **Módulo 1** (US-01, US-02): Autenticación básica
2. **Módulo 2** (US-06): Etiquetas maestras (requeridas por todo)
3. **Módulo 1** (US-03, US-04): Preferencias y perfil de salud
4. **Módulo 2** (US-07 a US-10): Ingredientes, ejercicios, comidas
5. **Módulo 3** (US-11 a US-15): Catálogo de metas y rutinas
6. **Módulo 4** (US-16 a US-20): Exploración cliente
7. **Módulo 5** (US-21 a US-25): Seguimiento y progreso

---

## 📞 Comunicación

### Daily Standups
- **Cuándo:** Lunes a Viernes, 9:00 AM
- **Dónde:** Zoom / Presencial
- **Duración:** 15 minutos

### Revisiones de Código
- **Proceso:** Pull Request → Revisión → Aprobación → Merge
- **Revisores:** Mínimo 1 persona del equipo
- **Tiempo de respuesta:** Máximo 24 horas

### Reuniones Semanales
- **Sprint Planning:** Lunes 10:00 AM
- **Sprint Review:** Viernes 3:00 PM
- **Retrospectiva:** Viernes 4:00 PM

---

## 📊 Métricas de Progreso

### Objetivos por Sprint

| Sprint | Objetivo | Métricas |
|--------|----------|----------|
| 1 | Base del sistema | 3 módulos al 50% |
| 2 | Funcionalidad core | 2 módulos al 80% |
| 3 | Features avanzadas | 5 módulos al 60% |
| 4 | Finalización | 5 módulos al 100% |

### Indicadores de Calidad

- **Cobertura de Tests:** Mínimo 70%
- **Code Review:** 100% de PRs revisados
- **Documentación:** Cada módulo documentado
- **Bugs Críticos:** 0 en producción

---

## 🚨 Escalación de Problemas

### Nivel 1: Compañero de Equipo
Consulta directa con otro desarrollador del equipo.

### Nivel 2: Responsable de Módulo
Si el problema es específico de un módulo.

### Nivel 3: Líder Técnico
Para decisiones de arquitectura o problemas complejos.

### Nivel 4: Product Owner
Para cambios de alcance o prioridades.

---

## 📝 Notas

- Actualizar este documento semanalmente
- Reportar bloqueos inmediatamente
- Documentar decisiones importantes
- Mantener comunicación activa

---

**Última actualización:** [Fecha]  
**Próxima revisión:** [Fecha]

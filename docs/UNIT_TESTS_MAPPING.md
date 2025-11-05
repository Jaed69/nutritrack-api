# 🧪 MAPEO COMPLETO: UNIT TESTS ↔ REGLAS DE NEGOCIO

> **Documento de Trazabilidad**  
> Este documento mapea cada test unitario con su regla de negocio correspondiente.  
> **Última actualización:** 5 de Noviembre, 2025  
> **Cobertura Total:** 175/175 tests ✅ | 27/39 reglas implementadas (69.2%)

---

## 📊 RESUMEN EJECUTIVO

| Categoría | Tests | Status |
|-----------|-------|--------|
| **Total de Tests Unitarios** | 175 | ✅ 100% |
| **Tests de Integración** | 1 | ✅ 100% |
| **Reglas con Tests** | 27 | ✅ 69.2% |
| **Cobertura de Código** | ~85% | ✅ Alta |

---

## 🔐 MÓDULO 1: AUTENTICACIÓN Y PERFIL

### AuthServiceTest.java (13 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testRegistro_EmailValido()` | RN01, RN30 | Email único y formato válido RFC 5322 | ✅ |
| `testRegistro_EmailDuplicado()` | RN01 | No permitir emails duplicados | ✅ |
| `testRegistro_EmailFormatoInvalido()` | RN30 | Rechazar email sin @ o formato inválido | ✅ |
| `testRegistro_EmailDominioInexistente()` | RN30 | DNS lookup: rechazar dominios inexistentes | ✅ |
| `testRegistro_PasswordValida()` | RN31 | Contraseña con 12+ chars y complejidad | ✅ |
| `testRegistro_PasswordCorta()` | RN31 | Rechazar contraseñas < 12 caracteres | ✅ |
| `testRegistro_PasswordSinMayuscula()` | RN31 | Rechazar sin mayúscula | ✅ |
| `testRegistro_PasswordSinMinuscula()` | RN31 | Rechazar sin minúscula | ✅ |
| `testRegistro_PasswordSinNumero()` | RN31 | Rechazar sin número | ✅ |
| `testRegistro_PasswordSinSimbolo()` | RN31 | Rechazar sin símbolo especial | ✅ |
| `testRegistro_PasswordComun()` | RN31 | Rechazar contraseñas en blacklist | ✅ |
| `testRegistro_PasswordContieneEmail()` | RN31 | Rechazar si contiene email del usuario | ✅ |
| `testLogin_CredencialesValidas()` | RN02 | Login exitoso con credenciales correctas | ✅ |
| `testLogin_PasswordIncorrecta()` | RN02 | Login falla con password incorrecta | ✅ |
| `testLogin_CuentaInactiva()` | RN02 | Login falla si cuenta está inactiva | ✅ |

**Comando para ejecutar:**
```bash
./mvnw test -Dtest=AuthServiceTest
```

**Ubicación:** `src/test/java/com/example/nutritrackapi/service/AuthServiceTest.java`

---

### PerfilServiceTest.java (11 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrearPerfilSalud_Exitoso()` | RN04 | Crear perfil salud con etiquetas maestras | ✅ |
| `testActualizarPerfilSalud_Exitoso()` | RN04 | Actualizar etiquetas de salud | ✅ |
| `testObtenerPerfilSalud_Existente()` | RN04 | Consultar perfil salud existente | ✅ |
| `testObtenerPerfilSalud_NoExiste()` | - | Manejo de perfil no existente | ✅ |
| `testCrearMedicion_Exitosa()` | RN22 | Registrar medición con valores válidos | ✅ |
| `testCrearMedicion_PesoInvalido()` | RN22 | Rechazar peso < 20 o > 600 kg | ✅ |
| `testCrearMedicion_AlturaInvalida()` | RN22 | Rechazar altura < 50 o > 300 cm | ✅ |
| `testObtenerHistorialMediciones()` | RN23 | Consultar historial completo | ✅ |
| `testConvertirUnidades_KgALbs()` | RN03, RN27 | Conversión KG → LBS | ✅ |
| `testConvertirUnidades_LbsAKg()` | RN03, RN27 | Conversión LBS → KG | ✅ |
| `testConfirmarEliminacionCuenta()` | RN05 | Eliminación con confirmación explícita | ✅ |

**Comando:** `./mvnw test -Dtest=PerfilServiceTest`

---

## 📚 MÓDULO 2: BIBLIOTECA DE CONTENIDO

### EtiquetaServiceTest.java (12 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | RN06 | Crear etiqueta con nombre único | ✅ |
| `testCrear_NombreDuplicado()` | RN06 | Rechazar nombre duplicado | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID existente | ✅ |
| `testBuscarPorId_NoExiste()` | - | Manejo de ID inexistente | ✅ |
| `testListarTodas()` | - | Listar todas las etiquetas | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar etiqueta existente | ✅ |
| `testActualizar_NoExiste()` | - | Error al actualizar inexistente | ✅ |
| `testEliminar_SinUso()` | RN08 | Eliminar si no está en uso | ✅ |
| `testEliminar_EnUsoEnPlanes()` | RN08 | Rechazar si está en `plan_etiquetas` | ✅ |
| `testEliminar_EnUsoEnIngredientes()` | RN08 | Rechazar si está en `ingrediente_etiquetas` | ✅ |
| `testEliminar_EnUsoEnEjercicios()` | RN08 | Rechazar si está en `ejercicio_etiquetas` | ✅ |
| `testEliminar_EnUsoEnPerfilesSalud()` | RN08 | Rechazar si está en `usuario_etiquetas_salud` | ✅ |

**Comando:** `./mvnw test -Dtest=EtiquetaServiceTest`

---

### IngredienteServiceTest.java (9 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | RN07 | Crear ingrediente con nombre único | ✅ |
| `testCrear_NombreDuplicado()` | RN07 | Rechazar nombre duplicado | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID | ✅ |
| `testListarTodos()` | - | Listar todos los ingredientes | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar ingrediente | ✅ |
| `testEliminar_SinUso()` | RN09 | Eliminar si no está en recetas | ✅ |
| `testEliminar_EnUsoEnComidas()` | RN09 | Rechazar si está en `comida_ingredientes` | ✅ |
| `testAsignarEtiquetas_Exitoso()` | RN12 | Asignar solo etiquetas existentes | ✅ |
| `testAsignarEtiquetas_NoExiste()` | RN12 | Rechazar etiqueta inexistente | ✅ |

**Comando:** `./mvnw test -Dtest=IngredienteServiceTest`

---

### EjercicioServiceTest.java (9 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | RN07 | Crear ejercicio con nombre único | ✅ |
| `testCrear_NombreDuplicado()` | RN07 | Rechazar nombre duplicado | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID | ✅ |
| `testListarTodos()` | - | Listar todos los ejercicios | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar ejercicio | ✅ |
| `testEliminar_SinUso()` | RN09 | Eliminar si no está en rutinas | ✅ |
| `testEliminar_EnUsoEnRutinas()` | RN09 | Rechazar si está en `rutina_ejercicios` | ✅ |
| `testAsignarEtiquetas_Exitoso()` | RN12 | Asignar solo etiquetas existentes | ✅ |
| `testAsignarEtiquetas_NoExiste()` | RN12 | Rechazar etiqueta inexistente | ✅ |

**Comando:** `./mvnw test -Dtest=EjercicioServiceTest`

---

### ComidaServiceTest.java (9 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | - | Crear receta/comida | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID | ✅ |
| `testListarTodas()` | - | Listar todas las comidas | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar comida | ✅ |
| `testEliminar_Exitoso()` | - | Eliminar comida | ✅ |
| `testAgregarIngrediente_Exitoso()` | RN10 | Agregar ingrediente con cantidad válida | ✅ |
| `testAgregarIngrediente_CantidadNegativa()` | RN10 | Rechazar cantidad negativa | ✅ |
| `testAgregarIngrediente_CantidadCero()` | RN10 | Rechazar cantidad cero | ✅ |
| `testAgregarIngrediente_IngredienteNoExiste()` | - | Error si ingrediente no existe | ✅ |

**Comando:** `./mvnw test -Dtest=ComidaServiceTest`

---

## 🗂️ MÓDULO 3: GESTOR DE CATÁLOGO

### PlanServiceTest.java (22 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | RN11 | Crear plan con nombre único | ✅ |
| `testCrear_NombreDuplicado()` | RN11 | Rechazar nombre duplicado | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID | ✅ |
| `testListarTodos()` | - | Listar todos los planes | ✅ |
| `testListarActivos()` | RN28 | Listar solo planes activos (soft delete) | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar plan | ✅ |
| `testEliminar_SinUsuariosActivos()` | RN14 | Eliminar si no tiene usuarios activos | ✅ |
| `testEliminar_ConUsuariosActivos()` | RN14 | Rechazar si tiene usuarios con estado ACTIVO | ✅ |
| `testEliminar_SoloConUsuariosPausados()` | RN14 | Permitir si solo hay pausados/completados | ✅ |
| `testSoftDelete_MarcaComoInactivo()` | RN28 | Soft delete: marca activo=false | ✅ |
| `testAsignarEtiquetas_Exitoso()` | RN12 | Asignar solo etiquetas existentes | ✅ |
| `testAsignarEtiquetas_NoExiste()` | RN12 | Rechazar etiqueta inexistente | ✅ |
| `testAgregarDia_Exitoso()` | - | Agregar día al plan | ✅ |
| `testAgregarDia_ComidaNoExiste()` | - | Error si comida no existe | ✅ |
| `testAgregarDia_NumeroDiaDuplicado()` | - | Rechazar día duplicado | ✅ |
| `testCalcularCaloriasDiarias_Automatico()` | RN25 | Cálculo automático de calorías | ✅ |
| `testValidarDuracion_MinimoUnDia()` | - | Duración mínima 1 día | ✅ |
| `testValidarDuracion_MaximoTresMeses()` | - | Duración máxima 90 días | ✅ |
| `testFiltrarPorEtiquetas()` | - | Filtrar planes por etiquetas | ✅ |
| `testBuscarPorNombre()` | - | Búsqueda por nombre | ✅ |
| `testObtenerPlanesConComidasCompletas()` | - | Eager loading de relaciones | ✅ |
| `testVerificarIntegridadNutricional()` | RN25 | Verificar cálculo nutricional | ✅ |

**Comando:** `./mvnw test -Dtest=PlanServiceTest`

---

### RutinaServiceTest.java (17 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testCrear_Exitoso()` | RN11 | Crear rutina con nombre único | ✅ |
| `testCrear_NombreDuplicado()` | RN11 | Rechazar nombre duplicado | ✅ |
| `testBuscarPorId_Existe()` | - | Consulta por ID | ✅ |
| `testListarTodas()` | - | Listar todas las rutinas | ✅ |
| `testListarActivas()` | RN28 | Listar solo rutinas activas | ✅ |
| `testActualizar_Exitoso()` | - | Actualizar rutina | ✅ |
| `testEliminar_SinUsuariosActivos()` | RN14 | Eliminar si no tiene usuarios activos | ✅ |
| `testEliminar_ConUsuariosActivos()` | RN14 | Rechazar si tiene usuarios ACTIVO | ✅ |
| `testSoftDelete()` | RN28 | Soft delete en rutinas | ✅ |
| `testAgregarEjercicio_Exitoso()` | RN13 | Agregar ejercicio con series/reps válidas | ✅ |
| `testAgregarEjercicio_SeriesNegativas()` | RN13 | Rechazar series negativas | ✅ |
| `testAgregarEjercicio_SeriesCero()` | RN13 | Rechazar series = 0 | ✅ |
| `testAgregarEjercicio_RepeticionesNegativas()` | RN13 | Rechazar repeticiones negativas | ✅ |
| `testAgregarEjercicio_RepeticionesCero()` | RN13 | Rechazar repeticiones = 0 | ✅ |
| `testAsignarEtiquetas_Exitoso()` | RN12 | Asignar etiquetas existentes | ✅ |
| `testFiltrarPorNivelDificultad()` | - | Filtrar por dificultad | ✅ |
| `testCalcularDuracionTotal()` | - | Calcular duración estimada | ✅ |

**Comando:** `./mvnw test -Dtest=RutinaServiceTest`

---

## 🔍 MÓDULO 4: EXPLORACIÓN Y ACTIVACIÓN

### UsuarioPlanServiceTest.java (37 tests)

| Test | Regla | Descripción | Status |
|------|-------|-------------|--------|
| `testActivarPlan_Exitoso()` | RN17, RN32 | Activar plan sin duplicados ni alérgenos | ✅ |
| `testActivarPlan_MismoPlanActivo()` | RN17 | Rechazar duplicado del mismo plan ACTIVO | ✅ |
| `testActivarPlan_PermitiDiferentesPlanesActivos()` | RN17 | Permitir múltiples planes diferentes | ✅ |
| `testActivarPlan_ConAlergenosIncompatibles()` | **RN32** | **Rechazar si plan tiene alérgenos del usuario** | ✅ |
| `testActivarPlan_SinAlergias()` | **RN32** | **Permitir si usuario no tiene alergias** | ✅ |
| `testActivarPlan_AlergiasPeroCompatibles()` | **RN32** | **Permitir si plan no tiene esos alérgenos** | ✅ |
| `testPausarPlan_Exitoso()` | RN19, RN26 | Pausar plan ACTIVO | ✅ |
| `testPausarPlan_YaCompletado()` | RN19 | Rechazar pausar si estado = COMPLETADO | ✅ |
| `testPausarPlan_YaCancelado()` | RN19 | Rechazar pausar si estado = CANCELADO | ✅ |
| `testReanudarPlan_Exitoso()` | RN26 | Reanudar plan PAUSADO → ACTIVO | ✅ |
| `testReanudarPlan_NoEstabaEnPausa()` | RN26 | Rechazar si no estaba PAUSADO | ✅ |
| `testCompletarPlan_Exitoso()` | RN20, RN26 | Completar plan al llegar a duración | ✅ |
| `testCompletarPlan_AutomaticoAlLlegarADia30()` | RN20 | Auto-completar cuando día_actual = duración | ✅ |
| `testCancelarPlan_Exitoso()` | RN26 | Cancelar plan activo o pausado | ✅ |
| `testCancelarPlan_YaCompletado()` | RN26 | Rechazar cancelar si ya está COMPLETADO | ✅ |
| `testConsultarPlanes_SoloDelUsuario()` | - | Solo ve sus propios planes | ✅ |
| `testConsultarPlanes_FiltrarPorEstado()` | - | Filtrar por estado ACTIVO/PAUSADO/etc | ✅ |
| `testTransiciones_ActivoAPausado()` | RN26 | Transición válida ACTIVO → PAUSADO | ✅ |
| `testTransiciones_PausadoAActivo()` | RN26 | Transición válida PAUSADO → ACTIVO | ✅ |
| `testTransiciones_ActivoACompletado()` | RN26 | Transición válida ACTIVO → COMPLETADO | ✅ |
| `testTransiciones_ActivoACancelado()` | RN26 | Transición válida ACTIVO → CANCELADO | ✅ |
| `testTransiciones_CompletadoAActivo_Invalida()` | RN26 | Transición inválida COMPLETADO → ACTIVO | ✅ |
| `testTransiciones_CanceladoAActivo_Invalida()` | RN26 | Transición inválida CANCELADO → ACTIVO | ✅ |
| ... | ... | (14 tests más de transiciones de estado) | ✅ |

**Tests Clave para RN32 (Validación de Alérgenos):**
1. `testActivarPlan_ConAlergenosIncompatibles()` - Query 5-join detecta alérgenos
2. `testActivarPlan_SinAlergias()` - Usuario sin alergias puede activar cualquier plan
3. `testActivarPlan_AlergiasPeroCompatibles()` - Plan sin esos alérgenos específicos

**Comando:** `./mvnw test -Dtest=UsuarioPlanServiceTest`

---

### UsuarioRutinaServiceTest.java (35 tests)

Similar estructura a UsuarioPlanServiceTest, pero para rutinas de ejercicio:
- RN17: No duplicar misma rutina activa
- RN18: Proponer reemplazo
- RN19: No pausar/reanudar en estados finales
- RN26: Transiciones válidas de estado

**Comando:** `./mvnw test -Dtest=UsuarioRutinaServiceTest`

---

## 📈 MÓDULO 5: SEGUIMIENTO DE PROGRESO

**Nota:** Los tests de este módulo están implementados pero no documentados aquí por brevedad.
- RN20: Mostrar checks en actividades completadas
- RN21: No marcar si plan está pausado
- RN22: Validación de mediciones en rango
- RN23: Gráfico requiere 2+ registros

---

## 🧪 CÓMO EJECUTAR LOS TESTS

### Ejecutar todos los tests (175 tests)
```bash
./mvnw test
```

### Ejecutar tests por módulo
```bash
# Módulo 1: Autenticación
./mvnw test -Dtest=AuthServiceTest,PerfilServiceTest

# Módulo 2: Biblioteca
./mvnw test -Dtest=EtiquetaServiceTest,IngredienteServiceTest,EjercicioServiceTest,ComidaServiceTest

# Módulo 3: Catálogo
./mvnw test -Dtest=PlanServiceTest,RutinaServiceTest

# Módulo 4: Asignación
./mvnw test -Dtest=UsuarioPlanServiceTest,UsuarioRutinaServiceTest
```

### Ejecutar tests de una regla específica
```bash
# RN30 y RN31 (Email y Contraseña)
./mvnw test -Dtest=AuthServiceTest#testRegistro*

# RN32 (Alérgenos)
./mvnw test -Dtest=UsuarioPlanServiceTest#testActivarPlan_ConAlergenos*
```

### Ver cobertura de tests
```bash
./mvnw test jacoco:report
# Abrir: target/site/jacoco/index.html
```

---

## 📋 VALIDACIÓN EN POSTMAN

Cada colección de Postman incluye tests automáticos que validan las reglas de negocio:

1. **NutriTrack_Unit_Tests_Demo.postman_collection.json**
   - 🎯 Colección específica para demostrar RN30, RN31, RN32
   - Incluye casos de éxito y error con assertions

2. **NutriTrack_Modulo1.postman_collection.json**
   - Tests para RN01, RN02, RN30, RN31

3. **NutriTrack_Modulo4.postman_collection.json**
   - Tests para RN17, RN18, RN19, RN32, RN26

### Ejecutar tests de Postman
```bash
# Instalar Newman (CLI de Postman)
npm install -g newman

# Ejecutar colección de demos
newman run postman/NutriTrack_Unit_Tests_Demo.postman_collection.json

# Ejecutar todas las colecciones
newman run postman/NutriTrack_API_Complete.postman_collection.json
```

---

## 📊 SWAGGER UI

La documentación Swagger incluye ejemplos de validación para cada endpoint:

**URL:** http://localhost:8080/swagger-ui/index.html

**Endpoints documentados con reglas:**
- `POST /api/v1/auth/registro` - RN01, RN30, RN31 con ejemplos de error
- `POST /api/v1/usuario/planes/activar` - RN17, RN32 con ejemplos de error
- Cada endpoint incluye descripción de unit tests y comandos para ejecutarlos

---

## 🎯 PRÓXIMOS PASOS

### Reglas pendientes de implementar (12 reglas):

**Prioridad Alta (Sprint 1 - Seguridad):**
- RN29: Rate Limiting (4 horas)
- RN37: Exportación GDPR (6 horas)

**Prioridad Media (Sprint 2 - Integridad):**
- RN33: Validación lógica de fechas (4 horas)
- RN34: Límite de registros diarios (3 horas)
- RN36: Versionado de planes (8 horas)

**Prioridad Baja (Sprint 3-4):**
- RN24: Reporte PDF (8 horas)
- RN35: Sistema de notificaciones (16 horas)
- RN38: Caché de catálogos (4 horas)
- RN39: Búsqueda full-text (6 horas)

---

## 📞 SOPORTE

**Documentos relacionados:**
- `docs/REGLAS_NEGOCIO.MD` - Especificación completa de las 39 reglas
- `postman/README.md` - Guía de uso de colecciones Postman
- `src/test/java/` - Código fuente de todos los tests

**Comando útil para contar tests:**
```bash
grep -r "@Test" src/test/java/ | wc -l
# Resultado: 175 tests
```

---

**Última actualización:** 5 de Noviembre, 2025  
**Versión:** 1.0  
**Responsable:** Equipo NutriTrack

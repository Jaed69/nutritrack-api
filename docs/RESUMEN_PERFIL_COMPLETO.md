# 📋 Resumen Completo - Módulo de Perfil de Usuario

## 🎯 Nuevo Endpoint Creado

### **GET** `/api/v1/perfil/completo`

Este endpoint retorna **toda la información del usuario** en una sola llamada:

✅ **Datos de Cuenta:** email, rol, estado, fecha registro  
✅ **Datos Personales:** nombre, apellido, unidades de medida  
✅ **Perfil de Salud:** objetivo, nivel actividad, etiquetas médicas  
✅ **Última Medición:** peso, altura, IMC con categorización  
✅ **Estadísticas:** total de mediciones registradas  

---

## 📦 Archivos Creados/Modificados

### ✨ Nuevos Archivos

1. **`PerfilCompletoResponse.java`** (DTO)
   - Ubicación: `src/main/java/com/example/nutritrackapi/dto/`
   - Contiene la estructura completa de respuesta
   - Incluye clases internas: `PerfilSaludInfo`, `EtiquetaInfo`, `UltimaMedicionInfo`

2. **`PERFIL_COMPLETO_ENDPOINT.md`** (Documentación)
   - Ubicación: `docs/`
   - Documentación completa del endpoint
   - Ejemplos de uso, casos de uso, estructura detallada

### 🔧 Archivos Modificados

3. **`PerfilService.java`** (Servicio)
   - Método nuevo: `obtenerPerfilCompleto(String email)`
   - Método auxiliar: `categorizarIMC(Double imc)`
   - Agrega lógica de negocio para obtener datos completos

4. **`PerfilController.java`** (Controlador)
   - Endpoint nuevo: `GET /api/v1/perfil/completo`
   - Documentación Swagger incluida

---

## 📊 Ejemplo de Respuesta Completa

```json
{
  "success": true,
  "message": "Perfil completo obtenido",
  "data": {
    "id": 1,
    "email": "usuario@example.com",
    "rol": "ROLE_USER",
    "activo": true,
    "fechaRegistro": "2024-01-15",
    "nombre": "Juan",
    "apellido": "Pérez",
    "nombreCompleto": "Juan Pérez",
    "unidadesMedida": "KG",
    "fechaInicioApp": "2024-01-15",
    "perfilSalud": {
      "id": 1,
      "objetivoActual": "PERDER_PESO",
      "nivelActividadActual": "MODERADO",
      "fechaActualizacion": "2024-11-15",
      "etiquetas": [
        {
          "id": 1,
          "nombre": "Diabetes",
          "tipoEtiqueta": "CONDICION_MEDICA",
          "descripcion": "Diabetes tipo 2"
        }
      ]
    },
    "ultimaMedicion": {
      "id": 15,
      "peso": 75.5,
      "altura": 175,
      "imc": 24.65,
      "fechaMedicion": "2025-11-19",
      "unidadPeso": "KG",
      "categoriaIMC": "Peso normal"
    },
    "totalMediciones": 15
  }
}
```

---

## 🔍 Todos los Endpoints del Módulo Perfil

### 1. **GET** `/api/v1/perfil/completo` ⭐ NUEVO
Obtener toda la información del usuario (nombre, email, perfil salud, última medición)

### 2. **PATCH** `/api/v1/perfil/unidades`
Cambiar unidades de medida (KG ↔ LBS)

### 3. **POST** `/api/v1/perfil/salud`
Crear perfil de salud por primera vez

### 4. **PUT** `/api/v1/perfil/salud`
Actualizar perfil de salud existente

### 5. **GET** `/api/v1/perfil/salud`
Obtener solo el perfil de salud

### 6. **POST** `/api/v1/perfil/mediciones`
Registrar nueva medición corporal

### 7. **GET** `/api/v1/perfil/mediciones`
Obtener historial completo de mediciones

### 8. **PUT** `/api/v1/perfil/mediciones/{id}`
Actualizar una medición existente

### 9. **DELETE** `/api/v1/perfil/mediciones/{id}`
Eliminar una medición

---

## 💡 Casos de Uso del Nuevo Endpoint

### 1️⃣ Pantalla de Perfil
Mostrar toda la información del usuario en una sola vista

### 2️⃣ Dashboard Principal
Presentar resumen con datos clave y última medición

### 3️⃣ Validación de Setup
Verificar si el usuario completó su configuración inicial

### 4️⃣ Personalización
Usar preferencias (unidades, nombre) para personalizar la app

---

## 🔐 Información de Seguridad

- **Autenticación:** Requiere Bearer Token JWT
- **Roles:** `ROLE_USER` y `ROLE_ADMIN`
- **Privacidad:** Solo el usuario autenticado puede ver su información
- **CORS:** Configurado para permitir origen del frontend

---

## 📋 Información Devuelta por Campo

### Datos de Cuenta
| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `id` | ID único de la cuenta | `1` |
| `email` | Email del usuario | `"juan@example.com"` |
| `rol` | Rol del usuario | `"ROLE_USER"` |
| `activo` | Estado de la cuenta | `true` |
| `fechaRegistro` | Fecha de registro | `"2024-01-15"` |

### Datos Personales
| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `nombre` | Nombre | `"Juan"` |
| `apellido` | Apellido | `"Pérez"` |
| `nombreCompleto` | Nombre completo | `"Juan Pérez"` |
| `unidadesMedida` | Sistema de unidades | `"KG"` o `"LBS"` |
| `fechaInicioApp` | Primera vez en la app | `"2024-01-15"` |

### Perfil de Salud (opcional)
| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `objetivoActual` | Objetivo de salud | `"PERDER_PESO"` |
| `nivelActividadActual` | Nivel de actividad | `"MODERADO"` |
| `fechaActualizacion` | Última actualización | `"2024-11-15"` |
| `etiquetas` | Condiciones médicas/alergias | `[{...}]` |

### Última Medición (opcional)
| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `peso` | Peso en unidad preferida | `75.5` |
| `altura` | Altura en cm | `175` |
| `imc` | Índice de masa corporal | `24.65` |
| `categoriaIMC` | Categoría OMS | `"Peso normal"` |
| `fechaMedicion` | Fecha de medición | `"2025-11-19"` |

### Estadísticas
| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| `totalMediciones` | Total de mediciones | `15` |

---

## 🧮 Categorías de IMC

El endpoint calcula automáticamente la categoría según la OMS:

| IMC | Categoría |
|-----|-----------|
| < 18.5 | Bajo peso |
| 18.5 - 24.9 | Peso normal |
| 25.0 - 29.9 | Sobrepeso |
| ≥ 30.0 | Obesidad |

---

## 🚀 Cómo Probarlo

### Opción 1: cURL
```bash
# Login
TOKEN=$(curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nutritrack.com","password":"admin123"}' \
  | jq -r '.data.token')

# Obtener perfil completo
curl -X GET "http://localhost:8080/api/v1/perfil/completo" \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Opción 2: Postman
1. Importar colección de Postman del proyecto
2. Hacer login para obtener token
3. Usar request `GET Perfil Completo`

### Opción 3: Swagger UI
1. Abrir `http://localhost:8080/swagger-ui.html`
2. Autenticarse con el botón "Authorize"
3. Buscar endpoint `/api/v1/perfil/completo`
4. Click en "Try it out" → "Execute"

---

## ✅ Ventajas de Este Endpoint

1. **Eficiencia:** Una sola llamada en vez de múltiples requests
2. **Completo:** Incluye toda la información necesaria del usuario
3. **Optimizado:** Usa `@Transactional(readOnly = true)` para mejor performance
4. **Flexible:** Maneja casos donde el usuario no tiene perfil o mediciones
5. **Conversión Automática:** Respeta las unidades preferidas del usuario
6. **Categorización:** Incluye interpretación del IMC para mejor UX

---

## 📝 Notas Técnicas

- **Conversión de Unidades:** Peso siempre se almacena en KG, se convierte al mostrar
- **Campos Opcionales:** `perfilSalud` y `ultimaMedicion` pueden ser `null`
- **IMC Calculado:** Se calcula automáticamente en `@PrePersist`/`@PreUpdate`
- **Última Medición:** Se ordena por fecha descendente y toma la primera
- **BigDecimal a Double:** Conversión necesaria para compatibilidad con JSON

---

## 📚 Documentación Adicional

- **Documentación Detallada:** `docs/PERFIL_COMPLETO_ENDPOINT.md`
- **Swagger UI:** `http://localhost:8080/swagger-ui.html`
- **Reglas de Negocio:** `docs/REGLAS_NEGOCIO.MD`
- **User Stories:** `docs/USER_STORIES.MD`

---

## 🎯 Resumen Ejecutivo

Se ha creado exitosamente un **endpoint unificado** que proporciona toda la información del usuario en una sola llamada a la API, incluyendo:

✅ Información de cuenta y autenticación  
✅ Datos personales completos (nombre, apellido)  
✅ Perfil de salud con objetivos y condiciones médicas  
✅ Última medición corporal con categorización de IMC  
✅ Estadísticas básicas del usuario  

Este endpoint mejora significativamente la experiencia de usuario al reducir el número de llamadas necesarias para obtener información completa del perfil.

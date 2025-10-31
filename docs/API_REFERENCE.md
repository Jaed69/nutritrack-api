# API REST Reference - NutriTrack 📡

**Versión:** 1.0  
**Base URL:** `/api/v1`  
**Autenticación:** Bearer Token (JWT)

## 📋 Tabla de Contenidos

- [Autenticación](#autenticación)
- [Gestión de Perfil](#gestión-de-perfil)
- [Admin - Etiquetas](#admin---etiquetas)
- [Admin - Ingredientes](#admin---ingredientes)
- [Admin - Ejercicios](#admin---ejercicios)
- [Admin - Comidas](#admin---comidas)
- [Admin - Catálogo de Metas](#admin---catálogo-de-metas)
- [Cliente - Catálogo](#cliente---catálogo)
- [Cliente - Mi Plan](#cliente---mi-plan)
- [Cliente - Actividades](#cliente---actividades)
- [Cliente - Mediciones](#cliente---mediciones)
- [Cliente - Reportes](#cliente---reportes)
- [Códigos de Estado](#códigos-de-estado)

---

## 🔐 Autenticación

### Crear Cuenta (US-01)

```http
POST /api/v1/auth/register
```

**Request Body:**
```json
{
  "email": "leonel@test.com",
  "password": "password123!",
  "nombre": "Leonel"
}
```

**Response (201):**
```json
{
  "userId": "a1b2c3d4-e5f6-...",
  "profileId": "f6e5d4c3-b2a1-...",
  "email": "leonel@test.com",
  "token": "jwt.token.string"
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-01

**Casos de Error:**
- `400 Bad Request`: Formato de email inválido o contraseña débil
- `409 Conflict`: Email ya registrado

---

### Iniciar Sesión (US-02)

```http
POST /api/v1/auth/login
```

**Request Body:**
```json
{
  "email": "leonel@test.com",
  "password": "password123!"
}
```

**Response (200):**
```json
{
  "userId": "a1b2c3d4-e5f6-...",
  "token": "jwt.token.string"
}
```

**Códigos:** `200`, `400`, `401`  
**Regla de Negocio:** RN-02

**Casos de Error:**
- `400 Bad Request`: Campos faltantes
- `401 Unauthorized`: Credenciales incorrectas o cuenta inactiva

---

## 👤 Gestión de Perfil

### Obtener Mi Perfil (US-04)

```http
GET /api/v1/app/profile
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "profileId": "f6e5d4c3-b2a1-...",
  "nombre": "Leonel Alzamora",
  "unidades": "kg",
  "perfil_salud": {
    "objetivo_tag_id": 5,
    "alergia_tag_ids": [10, 15],
    "condicion_tag_ids": []
  }
}
```

**Códigos:** `200`, `401`, `404`

---

### Actualizar Mi Perfil (US-03, US-04)

```http
PUT /api/v1/app/profile
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "nombre": "Leonel",
  "unidades": "lbs",
  "perfil_salud": {
    "objetivo_tag_id": 6,
    "alergia_tag_ids": [10]
  }
}
```

**Response (200):**
```json
{
  "profileId": "f6e5d4c3-b2a1-...",
  "nombre": "Leonel",
  "unidades": "lbs",
  "perfil_salud": {
    "objetivo_tag_id": 6,
    "alergia_tag_ids": [10]
  }
}
```

**Códigos:** `200`, `400`, `401`  
**Reglas de Negocio:** RN-03, RN-04

---

### Eliminar Cuenta (US-05)

```http
DELETE /api/v1/app/account
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Tu cuenta ha sido eliminada permanentemente"
}
```

**Códigos:** `200`, `401`, `403`  
**Regla de Negocio:** RN-05

---

## 🏷️ Admin - Etiquetas

### Crear Etiqueta (US-06)

```http
POST /api/v1/admin/tags
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Nueces",
  "tipo_etiqueta": "alergia"
}
```

**Tipos válidos:** `alergia`, `objetivo`, `dieta`, `condicion`, `dificultad`, `tipo_ejercicio`

**Response (201):**
```json
{
  "id": 1,
  "nombre": "Nueces",
  "tipo_etiqueta": "alergia"
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-06

---

### Obtener Etiquetas (US-06)

```http
GET /api/v1/admin/tags?tipo=alergia
Authorization: Bearer {adminToken}
```

**Query Parameters:**
- `tipo` (opcional): Filtrar por tipo de etiqueta

**Response (200):**
```json
[
  {
    "id": 1,
    "nombre": "Nueces"
  },
  {
    "id": 2,
    "nombre": "Lácteos"
  }
]
```

**Códigos:** `200`

---

### Eliminar Etiqueta (US-06)

```http
DELETE /api/v1/admin/tags/{id}
Authorization: Bearer {adminToken}
```

**Response (200):**
```json
{
  "message": "Etiqueta 'Nueces' eliminada"
}
```

**Códigos:** `200`, `404`, `409`  
**Regla de Negocio:** RN-07

**Casos de Error:**
- `409 Conflict`: Etiqueta en uso (no se puede eliminar)

---

## 🥗 Admin - Ingredientes

### Crear Ingrediente (US-07)

```http
POST /api/v1/admin/ingredients
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Maní",
  "tag_ids": [1]
}
```

**Response (201):**
```json
{
  "id": 10,
  "nombre": "Maní",
  "tags": [
    {
      "id": 1,
      "nombre": "Nueces"
    }
  ]
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-08

---

### Eliminar Ingrediente (US-07)

```http
DELETE /api/v1/admin/ingredients/{id}
Authorization: Bearer {adminToken}
```

**Response (200):**
```json
{
  "message": "Ingrediente 'Maní' eliminado"
}
```

**Códigos:** `200`, `404`, `409`  
**Regla de Negocio:** RN-09

---

## 🏋️ Admin - Ejercicios

### Crear Ejercicio (US-08)

```http
POST /api/v1/admin/exercises
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Burpee",
  "tag_ids": [20, 30]
}
```

**Response (201):**
```json
{
  "id": 15,
  "nombre": "Burpee",
  "tags": [
    {
      "id": 20,
      "nombre": "Cardio"
    },
    {
      "id": 30,
      "nombre": "Avanzado"
    }
  ]
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-08

---

## 🍽️ Admin - Comidas

### Crear Comida con Receta (US-09, US-10)

```http
POST /api/v1/admin/meals
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Batido Vegano",
  "tag_ids": [40],
  "receta": [
    {
      "ingredient_id": 12,
      "cantidad_ingrediente": "150.5"
    }
  ]
}
```

**Response (201):**
```json
{
  "id": 55,
  "nombre": "Batido Vegano",
  "tags": [
    {
      "id": 40,
      "nombre": "Desayuno"
    }
  ],
  "receta": [
    {
      "ingredient_id": 12,
      "nombre_ingrediente": "Tofu",
      "cantidad_ingrediente": "150.5"
    }
  ]
}
```

**Códigos:** `201`, `400`  
**Regla de Negocio:** RN-10

---

## 🎯 Admin - Catálogo de Metas

### Crear Meta (US-11)

```http
POST /api/v1/admin/catalog/goals
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Perder 10kg en 8 semanas",
  "descripcion": "Un plan intenso..."
}
```

**Response (201):**
```json
{
  "id": 50,
  "nombre": "Perder 10kg en 8 semanas",
  "descripcion": "Un plan intenso..."
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-11

---

### Asignar Etiqueta a Meta (US-12)

```http
POST /api/v1/admin/catalog/goals/{goalId}/tags
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "tag_id": 5
}
```

**Response (201):**
```json
{
  "message": "Etiqueta 'Perder Peso' asignada a la meta 'Perder 10kg...'"
}
```

**Códigos:** `201`, `404`  
**Regla de Negocio:** RN-12

---

### Crear Actividad (US-12)

```http
POST /api/v1/admin/catalog/goals/{goalId}/activities
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "nombre": "Día 1: Pecho",
  "tipo_actividad": "Ejercicio"
}
```

**Tipos válidos:** `Ejercicio`, `Comida`, `Descanso`

**Response (201):**
```json
{
  "id": 100,
  "nombre": "Día 1: Pecho",
  "goal_id": 50,
  "tipo_actividad": "Ejercicio"
}
```

**Códigos:** `201`, `404`

---

### Ensamblar Rutina (US-15)

```http
POST /api/v1/admin/catalog/activities/{activityId}/routine
Authorization: Bearer {adminToken}
```

**Request Body:**
```json
{
  "exercise_id": 15,
  "series": 4,
  "repeticiones": 10
}
```

**Response (201):**
```json
{
  "message": "Ejercicio 'Burpee' añadido a la rutina 'Día 1: Pecho'"
}
```

**Códigos:** `201`, `400`, `404`  
**Regla de Negocio:** RN-13

---

### Eliminar Meta (US-14)

```http
DELETE /api/v1/admin/catalog/goals/{goalId}
Authorization: Bearer {adminToken}
```

**Response (200):**
```json
{
  "message": "Meta 'Perder 10kg...' eliminada"
}
```

**Códigos:** `200`, `404`, `409`  
**Regla de Negocio:** RN-14

**Casos de Error:**
- `409 Conflict`: Meta en uso por clientes activos

---

## 📚 Cliente - Catálogo

### Ver Catálogo (US-16)

```http
GET /api/v1/app/catalog/goals
Authorization: Bearer {token}
```

**Descripción:** Retorna metas filtradas según el perfil del usuario (objetivo, alergias, condiciones).

**Response (200):**
```json
[
  {
    "id": 50,
    "nombre": "Perder 10kg en 8 semanas",
    "descripcion": "...",
    "tags": [
      {
        "id": 5,
        "nombre": "Perder Peso"
      }
    ]
  },
  {
    "id": 52,
    "nombre": "Ganar Músculo",
    "tags": [...]
  }
]
```

**Códigos:** `200`  
**Reglas de Negocio:** RN-15, RN-16

---

### Ver Detalle de Meta (US-17)

```http
GET /api/v1/app/catalog/goals/{goalId}
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "id": 50,
  "nombre": "Perder 10kg en 8 semanas",
  "descripcion": "...",
  "tags": [...],
  "actividades": [
    {
      "id": 100,
      "nombre": "Día 1: Pecho",
      "tipo_actividad": "Ejercicio"
    },
    {
      "id": 101,
      "nombre": "Desayuno Proteico",
      "tipo_actividad": "Comida"
    }
  ],
  "avisos": [
    "Este plan contiene: Nueces"
  ]
}
```

**Códigos:** `200`, `404`

---

## 💪 Cliente - Mi Plan

### Activar Plan (US-18)

```http
POST /api/v1/app/my-plan
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "catalog_goal_id": 50
}
```

**Response (201):**
```json
{
  "id_asignacion": 201,
  "estado": "activo",
  "meta_id": 50,
  "fecha_inicio": "2025-10-31"
}
```

**Códigos:** `201`, `409`  
**Reglas de Negocio:** RN-17, RN-18

**Casos de Error:**
- `409 Conflict`: Ya tienes un plan activo

---

### Actualizar Estado del Plan (US-19, US-20)

```http
PUT /api/v1/app/my-plan
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "estado": "pausado"
}
```

**Estados válidos:** `activo`, `pausado`, `completado`, `cancelado`

**Response (200):**
```json
{
  "id_asignacion": 201,
  "estado": "pausado",
  "meta_id": 50,
  "fecha_inicio": "2025-10-31"
}
```

**Códigos:** `200`, `400`, `404`  
**Regla de Negocio:** RN-19

---

## ✅ Cliente - Actividades

### Ver Actividades del Plan (US-21)

```http
GET /api/v1/app/my-plan/activities
Authorization: Bearer {token}
```

**Response (200):**
```json
[
  {
    "id_actividad": 100,
    "nombre": "Día 1: Pecho",
    "tipo_actividad": "Ejercicio",
    "is_completed": false
  },
  {
    "id_actividad": 101,
    "nombre": "Desayuno Proteico",
    "tipo_actividad": "Comida",
    "is_completed": true
  }
]
```

**Códigos:** `200`, `404`  
**Regla de Negocio:** RN-20

---

### Marcar Actividad Completada (US-22)

```http
POST /api/v1/app/my-plan/activities/{activityId}/complete
Authorization: Bearer {token}
```

**Response (201):**
```json
{
  "message": "Actividad 'Día 1: Pecho' completada"
}
```

**Códigos:** `201`, `400`, `409`  
**Regla de Negocio:** RN-21

**Casos de Error:**
- `400 Bad Request`: Plan pausado (reanudar primero)

---

### Desmarcar Actividad (US-23)

```http
DELETE /api/v1/app/my-plan/activities/{activityId}/complete
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Progreso de 'Día 1: Pecho' reiniciado"
}
```

**Códigos:** `200`, `404`

---

## 📊 Cliente - Mediciones

### Registrar Medición (US-24)

```http
POST /api/v1/app/measurements
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "peso": 69.5,
  "fecha": "2025-10-31"
}
```

**Response (201):**
```json
{
  "id": 300,
  "peso": 69.5,
  "fecha": "2025-10-31"
}
```

**Códigos:** `201`, `400`  
**Regla de Negocio:** RN-22

**Validaciones:**
- Peso debe ser numérico positivo
- Rango válido: 20-600 kg

---

### Ver Mis Mediciones (US-24)

```http
GET /api/v1/app/measurements
Authorization: Bearer {token}
```

**Response (200):**
```json
[
  {
    "id": 300,
    "peso": 69.5,
    "fecha": "2025-10-31",
    "unidad": "kg"
  },
  {
    "id": 299,
    "peso": 70.1,
    "fecha": "2025-10-24",
    "unidad": "kg"
  }
]
```

**Códigos:** `200`

---

## 📈 Cliente - Reportes

### Ver Datos de Gráfico (US-25)

```http
GET /api/v1/app/reports/progress-chart
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "labels": ["Oct 24", "Oct 31"],
  "data": [70.1, 69.5],
  "objetivo": 65.0
}
```

**Códigos:** `200`  
**Regla de Negocio:** RN-23

---

### Descargar Reporte PDF (US-25)

```http
GET /api/v1/app/reports/download-pdf
Authorization: Bearer {token}
```

**Response (200):**
- Content-Type: `application/pdf`
- Content-Disposition: `attachment; filename="NutriTrack_Reporte.pdf"`

**Códigos:** `200`, `500`  
**Regla de Negocio:** RN-24

---

## 📋 Códigos de Estado HTTP

| Código | Significado | Uso en NutriTrack |
|--------|-------------|-------------------|
| **2xx - Éxito** | | |
| 200 | OK | Operación exitosa (GET, PUT, DELETE) |
| 201 | Created | Recurso creado exitosamente (POST) |
| 204 | No Content | Eliminación sin contenido en respuesta |
| **4xx - Error del Cliente** | | |
| 400 | Bad Request | Datos de entrada inválidos o faltantes |
| 401 | Unauthorized | Token ausente, inválido o expirado |
| 403 | Forbidden | Sin permisos para la operación |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Conflicto (email duplicado, recurso en uso) |
| **5xx - Error del Servidor** | | |
| 500 | Internal Server Error | Error inesperado del servidor |

---

## 🔑 Autenticación y Headers

### Headers Requeridos

**Para endpoints públicos:**
```http
Content-Type: application/json
```

**Para endpoints protegidos:**
```http
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Para endpoints de Admin:**
```http
Authorization: Bearer {admin_jwt_token}
Content-Type: application/json
```

---

## 📝 Formato de Errores

Todos los errores siguen el siguiente formato:

```json
{
  "timestamp": "2025-10-31T15:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "El formato de email es inválido",
  "path": "/api/v1/auth/register"
}
```

**Errores de Validación:**
```json
{
  "timestamp": "2025-10-31T15:30:00Z",
  "status": 400,
  "error": "Validation Failed",
  "errors": {
    "email": "Email es requerido",
    "password": "La contraseña debe tener al menos 8 caracteres"
  },
  "path": "/api/v1/auth/register"
}
```

---

## 🔗 Enlaces Útiles

- **[Postman Collection](../testing/POSTMAN_GUIDE.md)** - Guía de pruebas con Postman
- **[Reglas de Negocio](BUSINESS_RULES.md)** - Detalle de todas las RN
- **[Base de Datos](../architecture/DATABASE_SCHEMA.md)** - Esquema de BD
- **[Autenticación](../modules/auth.md)** - Detalles de seguridad JWT

---

**Última actualización:** Octubre 2025  
**Versión del API:** 1.0  
**Mantenido por:** Equipo NutriTrack

**¿Encontraste un error?** Reporta en GitHub con etiqueta `documentation`

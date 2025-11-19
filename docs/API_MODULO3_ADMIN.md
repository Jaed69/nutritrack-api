# 📋 API MÓDULO 3 - ADMIN: Planes y Rutinas

**Base URL:** `http://localhost:8080/api/v1`  
**Autenticación:** Bearer Token (ROLE_ADMIN requerido)  
**Autor:** Jhamil Peña

---

## 🔐 Autenticación

Todas las rutas requieren header de autenticación:

```javascript
headers: {
  'Authorization': 'Bearer {token}',
  'Content-Type': 'application/json'
}
```

**Usuario Admin:**
- Email: `admin@nutritrack.com`
- Password: `Admin123!`

---

## 🍽️ PLANES NUTRICIONALES

### 1. Crear Plan (US-11)

**Endpoint:** `POST /api/v1/planes`  
**Reglas:** RN11 (Nombre único)

```javascript
// Request Body
{
  "nombre": "Plan Pérdida de Peso - 7 días",
  "descripcion": "Plan diseñado para reducción de peso gradual",
  "duracionDias": 7,
  "caloriasTotales": 1800.00,
  "objetivos": [
    {
      "objetivo": "PERDER_PESO",
      "proteinas": 120.00,
      "carbohidratos": 180.00,
      "grasas": 60.00
    }
  ]
}

// Response 201
{
  "success": true,
  "message": "Plan creado exitosamente",
  "data": {
    "id": 1,
    "nombre": "Plan Pérdida de Peso - 7 días",
    "descripcion": "Plan diseñado para reducción de peso gradual",
    "duracionDias": 7,
    "caloriasTotales": 1800.00,
    "activo": true,
    "createdAt": "2025-11-18T10:30:00",
    "objetivos": [...]
  }
}

// Error 400 (Nombre duplicado)
{
  "success": false,
  "message": "Ya existe un plan con ese nombre",
  "data": null
}
```

**Validaciones:**
- `nombre`: requerido, único, max 100 caracteres
- `duracionDias`: >= 1
- `caloriasTotales`: >= 0
- `objetivos`: al menos 1 objetivo

**Objetivos disponibles:**
- `PERDER_PESO`
- `GANAR_MASA_MUSCULAR`
- `MANTENER_FORMA`
- `REHABILITACION`
- `CONTROLAR_ESTRES`

---

### 2. Obtener Plan por ID

**Endpoint:** `GET /api/v1/planes/{id}`

```javascript
// Response 200
{
  "success": true,
  "message": "Plan encontrado",
  "data": {
    "id": 1,
    "nombre": "Plan Pérdida de Peso - 7 días",
    "descripcion": "...",
    "duracionDias": 7,
    "caloriasTotales": 1800.00,
    "activo": true,
    "createdAt": "2025-11-18T10:30:00",
    "objetivos": [
      {
        "id": 1,
        "objetivo": "PERDER_PESO",
        "proteinas": 120.00,
        "carbohidratos": 180.00,
        "grasas": 60.00
      }
    ]
  }
}

// Error 404
{
  "success": false,
  "message": "Plan no encontrado",
  "data": null
}
```

---

### 3. Listar Todos los Planes (US-13)

**Endpoint:** `GET /api/v1/planes?page=0&size=20`

```javascript
// Response 200
{
  "success": true,
  "message": "Planes listados exitosamente",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Plan Pérdida de Peso - 7 días",
        "descripcion": "...",
        "duracionDias": 7,
        "caloriasTotales": 1800.00,
        "activo": true
      },
      {
        "id": 2,
        "nombre": "Plan Ganancia Muscular - 14 días",
        "descripcion": "...",
        "duracionDias": 14,
        "caloriasTotales": 2500.00,
        "activo": false  // Incluye inactivos
      }
    ],
    "totalElements": 2,
    "totalPages": 1,
    "number": 0,
    "size": 20
  }
}
```

**Query Params:**
- `page`: número de página (default: 0)
- `size`: elementos por página (default: 20)

---

### 4. Listar Planes Activos

**Endpoint:** `GET /api/v1/planes/activos?page=0&size=20`

```javascript
// Response 200 (solo planes con activo=true)
{
  "success": true,
  "message": "Planes activos listados",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Plan Pérdida de Peso - 7 días",
        "activo": true
      }
    ],
    "totalElements": 1,
    "totalPages": 1
  }
}
```

---

### 5. Buscar Planes por Nombre

**Endpoint:** `GET /api/v1/planes/buscar?nombre=perdida&page=0&size=20`

```javascript
// Response 200
{
  "success": true,
  "message": "Búsqueda completada",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Plan Pérdida de Peso - 7 días"
      }
    ]
  }
}
```

**Query Params:**
- `nombre`: texto a buscar (case-insensitive)

---

### 6. Actualizar Plan (US-12)

**Endpoint:** `PUT /api/v1/planes/{id}`

```javascript
// Request Body
{
  "nombre": "Plan Pérdida de Peso - 7 días (V2)",
  "descripcion": "Nueva descripción actualizada",
  "duracionDias": 7,
  "caloriasTotales": 1900.00,
  "objetivos": [
    {
      "objetivo": "PERDER_PESO",
      "proteinas": 130.00,
      "carbohidratos": 170.00,
      "grasas": 65.00
    }
  ]
}

// Response 200
{
  "success": true,
  "message": "Plan actualizado exitosamente",
  "data": {
    "id": 1,
    "nombre": "Plan Pérdida de Peso - 7 días (V2)",
    "descripcion": "Nueva descripción actualizada",
    "caloriasTotales": 1900.00,
    "updatedAt": "2025-11-18T11:00:00"
  }
}

// Error 400 (Nombre duplicado con otro plan)
{
  "success": false,
  "message": "Ya existe otro plan con ese nombre",
  "data": null
}
```

---

### 7. Eliminar Plan (US-14)

**Endpoint:** `DELETE /api/v1/planes/{id}`  
**Reglas:** RN14 (No eliminar con usuarios activos), RN28 (Soft delete)

```javascript
// Response 200
{
  "success": true,
  "message": "Plan eliminado exitosamente",
  "data": null
}

// Error 409 (Tiene usuarios activos)
{
  "success": false,
  "message": "No se puede eliminar el plan porque tiene usuarios activos asignados",
  "data": null
}

// Error 404
{
  "success": false,
  "message": "Plan no encontrado",
  "data": null
}
```

**Nota:** Es soft delete, marca `activo=false` sin borrar físicamente.

---

### 8. Agregar Comida al Plan (US-12)

**Endpoint:** `POST /api/v1/planes/{id}/dias`

```javascript
// Request Body
{
  "numeroDia": 1,
  "tipoComida": "DESAYUNO",
  "idComida": 5,
  "notas": "Desayuno alto en proteína"
}

// Response 201
{
  "success": true,
  "message": "Actividad agregada al plan",
  "data": {
    "id": 1,
    "numeroDia": 1,
    "tipoComida": "DESAYUNO",
    "comida": {
      "id": 5,
      "nombre": "Avena con frutas y almendras",
      "tipo": "DESAYUNO",
      "tiempoPreparacion": 10
    },
    "notas": "Desayuno alto en proteína"
  }
}

// Error 400 (Día excede duración)
{
  "success": false,
  "message": "El número de día excede la duración del plan",
  "data": null
}
```

**Tipos de comida disponibles:**
- `DESAYUNO`
- `ALMUERZO`
- `CENA`
- `SNACK`
- `PRE_ENTRENAMIENTO`
- `POST_ENTRENAMIENTO`
- `COLACION`
- `MERIENDA`

**Validaciones:**
- `numeroDia`: 1 <= numeroDia <= duracionDias
- `tipoComida`: enum válido
- `idComida`: debe existir en tabla comidas

---

### 9. Obtener Todos los Días del Plan

**Endpoint:** `GET /api/v1/planes/{id}/dias`

```javascript
// Response 200
{
  "success": true,
  "message": "Días del plan obtenidos",
  "data": [
    {
      "id": 1,
      "numeroDia": 1,
      "tipoComida": "DESAYUNO",
      "comida": {
        "id": 5,
        "nombre": "Avena con frutas y almendras"
      },
      "notas": "Desayuno alto en proteína"
    },
    {
      "id": 2,
      "numeroDia": 1,
      "tipoComida": "ALMUERZO",
      "comida": {
        "id": 8,
        "nombre": "Ensalada de pollo a la parrilla"
      },
      "notas": "Almuerzo ligero"
    },
    {
      "id": 3,
      "numeroDia": 1,
      "tipoComida": "CENA",
      "comida": {
        "id": 12,
        "nombre": "Pescado al horno con verduras"
      }
    }
  ]
}
```

**Nota:** Ordenado por `numeroDia` y `tipoComida`

---

### 10. Obtener Actividades de un Día Específico

**Endpoint:** `GET /api/v1/planes/{id}/dias/{numeroDia}`

```javascript
// GET /api/v1/planes/1/dias/1

// Response 200
{
  "success": true,
  "message": "Actividades del día obtenidas",
  "data": [
    {
      "id": 1,
      "numeroDia": 1,
      "tipoComida": "DESAYUNO",
      "comida": {
        "id": 5,
        "nombre": "Avena con frutas y almendras",
        "calorias": 350.00
      }
    },
    {
      "id": 2,
      "numeroDia": 1,
      "tipoComida": "ALMUERZO",
      "comida": {
        "id": 8,
        "nombre": "Ensalada de pollo a la parrilla",
        "calorias": 450.00
      }
    }
  ]
}
```

---

### 11. Eliminar Comida del Plan

**Endpoint:** `DELETE /api/v1/planes/{planId}/dias/{diaId}`

```javascript
// Response 200
{
  "success": true,
  "message": "Actividad eliminada del plan",
  "data": null
}

// Error 404
{
  "success": false,
  "message": "Actividad no encontrada",
  "data": null
}
```

**Nota:** `diaId` es el ID del registro en la tabla `plan_dias`

---

## 🏋️ RUTINAS DE EJERCICIO

### 12. Crear Rutina (US-11)

**Endpoint:** `POST /api/v1/rutinas`  
**Reglas:** RN11 (Nombre único)

```javascript
// Request Body
{
  "nombre": "Rutina Principiante - 4 semanas",
  "descripcion": "Rutina de fuerza básica para principiantes",
  "duracionSemanas": 4,
  "nivelDificultad": "PRINCIPIANTE",
  "objetivo": "GANAR_MASA_MUSCULAR"
}

// Response 201
{
  "success": true,
  "message": "Rutina creada exitosamente",
  "data": {
    "id": 1,
    "nombre": "Rutina Principiante - 4 semanas",
    "descripcion": "Rutina de fuerza básica para principiantes",
    "duracionSemanas": 4,
    "nivelDificultad": "PRINCIPIANTE",
    "objetivo": "GANAR_MASA_MUSCULAR",
    "activo": true,
    "createdAt": "2025-11-18T10:30:00"
  }
}

// Error 400 (Nombre duplicado)
{
  "success": false,
  "message": "Ya existe una rutina con ese nombre",
  "data": null
}
```

**Niveles de dificultad:**
- `PRINCIPIANTE`
- `INTERMEDIO`
- `AVANZADO`
- `EXPERTO`

**Objetivos disponibles:**
- `PERDER_PESO`
- `GANAR_MASA_MUSCULAR`
- `MANTENER_FORMA`
- `REHABILITACION`
- `CONTROLAR_ESTRES`

---

### 13. Obtener Rutina por ID

**Endpoint:** `GET /api/v1/rutinas/{id}`

```javascript
// Response 200
{
  "success": true,
  "message": "Rutina encontrada",
  "data": {
    "id": 1,
    "nombre": "Rutina Principiante - 4 semanas",
    "descripcion": "Rutina de fuerza básica",
    "duracionSemanas": 4,
    "nivelDificultad": "PRINCIPIANTE",
    "objetivo": "GANAR_MASA_MUSCULAR",
    "activo": true,
    "createdAt": "2025-11-18T10:30:00"
  }
}

// Error 404
{
  "success": false,
  "message": "Rutina no encontrada",
  "data": null
}
```

---

### 14. Listar Todas las Rutinas (US-13)

**Endpoint:** `GET /api/v1/rutinas?page=0&size=20`

```javascript
// Response 200
{
  "success": true,
  "message": "Rutinas listadas exitosamente",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Rutina Principiante - 4 semanas",
        "duracionSemanas": 4,
        "nivelDificultad": "PRINCIPIANTE",
        "activo": true
      },
      {
        "id": 2,
        "nombre": "Rutina Avanzada - 8 semanas",
        "duracionSemanas": 8,
        "nivelDificultad": "AVANZADO",
        "activo": false  // Incluye inactivas
      }
    ],
    "totalElements": 2,
    "totalPages": 1
  }
}
```

---

### 15. Listar Rutinas Activas

**Endpoint:** `GET /api/v1/rutinas/activas?page=0&size=20`

```javascript
// Response 200 (solo rutinas con activo=true)
{
  "success": true,
  "message": "Rutinas activas listadas",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Rutina Principiante - 4 semanas",
        "activo": true
      }
    ]
  }
}
```

---

### 16. Buscar Rutinas por Nombre

**Endpoint:** `GET /api/v1/rutinas/buscar?nombre=fuerza&page=0&size=20`

```javascript
// Response 200
{
  "success": true,
  "message": "Búsqueda completada",
  "data": {
    "content": [
      {
        "id": 1,
        "nombre": "Rutina Fuerza Superior - 6 semanas"
      }
    ]
  }
}
```

---

### 17. Actualizar Rutina (US-12)

**Endpoint:** `PUT /api/v1/rutinas/{id}`

```javascript
// Request Body
{
  "nombre": "Rutina Principiante - 4 semanas (V2)",
  "descripcion": "Nueva descripción actualizada",
  "duracionSemanas": 4,
  "nivelDificultad": "INTERMEDIO",
  "objetivo": "GANAR_MASA_MUSCULAR"
}

// Response 200
{
  "success": true,
  "message": "Rutina actualizada exitosamente",
  "data": {
    "id": 1,
    "nombre": "Rutina Principiante - 4 semanas (V2)",
    "nivelDificultad": "INTERMEDIO",
    "updatedAt": "2025-11-18T11:00:00"
  }
}
```

---

### 18. Eliminar Rutina (US-14)

**Endpoint:** `DELETE /api/v1/rutinas/{id}`  
**Reglas:** RN14 (No eliminar con usuarios activos), RN28 (Soft delete)

```javascript
// Response 200
{
  "success": true,
  "message": "Rutina eliminada exitosamente",
  "data": null
}

// Error 409 (Tiene usuarios activos)
{
  "success": false,
  "message": "No se puede eliminar la rutina porque tiene usuarios activos asignados",
  "data": null
}
```

---

### 19. Agregar Ejercicio a Rutina (US-12, US-15)

**Endpoint:** `POST /api/v1/rutinas/{id}/ejercicios`  
**Reglas:** RN13 (Series y repeticiones >= 1)

```javascript
// Request Body
{
  "idEjercicio": 3,
  "orden": 1,
  "series": 3,
  "repeticiones": 12,
  "peso": 20.00,
  "duracionMinutos": null,
  "descansoSegundos": 60,
  "notas": "Mantener espalda recta"
}

// Response 201
{
  "success": true,
  "message": "Ejercicio agregado a la rutina",
  "data": {
    "id": 1,
    "ejercicio": {
      "id": 3,
      "nombre": "Sentadillas",
      "tipoEjercicio": "FUERZA",
      "grupoMuscular": "PIERNAS"
    },
    "orden": 1,
    "series": 3,
    "repeticiones": 12,
    "peso": 20.00,
    "duracionMinutos": null,
    "descansoSegundos": 60,
    "notas": "Mantener espalda recta"
  }
}

// Error 400 (Series o repeticiones < 1)
{
  "success": false,
  "message": "Series y repeticiones deben ser mayores a 0",
  "data": null
}
```

**Validaciones:**
- `series`: >= 1 (RN13)
- `repeticiones`: >= 1 (RN13)
- `peso`: >= 0 (opcional)
- `duracionMinutos`: >= 0 (opcional, para cardio)
- `descansoSegundos`: >= 0

**Nota:** Para ejercicios de cardio, usar `duracionMinutos` en lugar de `repeticiones`

---

### 20. Obtener Ejercicios de Rutina

**Endpoint:** `GET /api/v1/rutinas/{id}/ejercicios`

```javascript
// Response 200
{
  "success": true,
  "message": "Ejercicios de la rutina obtenidos",
  "data": [
    {
      "id": 1,
      "ejercicio": {
        "id": 3,
        "nombre": "Sentadillas",
        "descripcion": "Ejercicio fundamental para piernas",
        "tipoEjercicio": "FUERZA",
        "grupoMuscular": "PIERNAS",
        "nivelDificultad": "PRINCIPIANTE"
      },
      "orden": 1,
      "series": 3,
      "repeticiones": 12,
      "peso": 20.00,
      "descansoSegundos": 60,
      "notas": "Mantener espalda recta"
    },
    {
      "id": 2,
      "ejercicio": {
        "id": 5,
        "nombre": "Flexiones de pecho",
        "tipoEjercicio": "FUERZA",
        "grupoMuscular": "PECHO"
      },
      "orden": 2,
      "series": 3,
      "repeticiones": 10,
      "descansoSegundos": 60
    },
    {
      "id": 3,
      "ejercicio": {
        "id": 8,
        "nombre": "Trote en el lugar",
        "tipoEjercicio": "CARDIO",
        "grupoMuscular": "CARDIO"
      },
      "orden": 3,
      "series": 1,
      "duracionMinutos": 20,
      "notas": "Calentamiento final"
    }
  ]
}
```

**Nota:** Ordenado por campo `orden`

---

### 21. Actualizar Ejercicio de Rutina (US-15)

**Endpoint:** `PUT /api/v1/rutinas/{rutinaId}/ejercicios/{ejercicioId}`

```javascript
// Request Body
{
  "idEjercicio": 3,
  "orden": 1,
  "series": 4,  // cambió de 3 a 4
  "repeticiones": 15,  // cambió de 12 a 15
  "peso": 25.00,  // cambió de 20 a 25
  "descansoSegundos": 90,  // cambió de 60 a 90
  "notas": "Bajar hasta 90 grados"
}

// Response 200
{
  "success": true,
  "message": "Ejercicio actualizado",
  "data": {
    "id": 1,
    "ejercicio": {
      "id": 3,
      "nombre": "Sentadillas"
    },
    "orden": 1,
    "series": 4,
    "repeticiones": 15,
    "peso": 25.00,
    "descansoSegundos": 90,
    "notas": "Bajar hasta 90 grados"
  }
}

// Error 400 (Ejercicio no pertenece a la rutina)
{
  "success": false,
  "message": "El ejercicio no pertenece a esta rutina",
  "data": null
}
```

---

### 22. Eliminar Ejercicio de Rutina

**Endpoint:** `DELETE /api/v1/rutinas/{rutinaId}/ejercicios/{ejercicioId}`

```javascript
// Response 200
{
  "success": true,
  "message": "Ejercicio eliminado de la rutina",
  "data": null
}

// Error 404
{
  "success": false,
  "message": "Ejercicio no encontrado en la rutina",
  "data": null
}
```

**Nota:** `ejercicioId` es el ID del registro en tabla `rutina_ejercicios`, no el ID del ejercicio del catálogo

---

## 📊 RESUMEN DE ENDPOINTS

### Planes Nutricionales (11 endpoints)

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 1 | POST | `/api/v1/planes` | Crear plan |
| 2 | GET | `/api/v1/planes/{id}` | Obtener plan |
| 3 | GET | `/api/v1/planes` | Listar todos |
| 4 | GET | `/api/v1/planes/activos` | Listar activos |
| 5 | GET | `/api/v1/planes/buscar` | Buscar por nombre |
| 6 | PUT | `/api/v1/planes/{id}` | Actualizar plan |
| 7 | DELETE | `/api/v1/planes/{id}` | Eliminar plan |
| 8 | POST | `/api/v1/planes/{id}/dias` | Agregar comida |
| 9 | GET | `/api/v1/planes/{id}/dias` | Listar días |
| 10 | GET | `/api/v1/planes/{id}/dias/{numeroDia}` | Días específicos |
| 11 | DELETE | `/api/v1/planes/{planId}/dias/{diaId}` | Eliminar comida |

### Rutinas de Ejercicio (11 endpoints)

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 12 | POST | `/api/v1/rutinas` | Crear rutina |
| 13 | GET | `/api/v1/rutinas/{id}` | Obtener rutina |
| 14 | GET | `/api/v1/rutinas` | Listar todas |
| 15 | GET | `/api/v1/rutinas/activas` | Listar activas |
| 16 | GET | `/api/v1/rutinas/buscar` | Buscar por nombre |
| 17 | PUT | `/api/v1/rutinas/{id}` | Actualizar rutina |
| 18 | DELETE | `/api/v1/rutinas/{id}` | Eliminar rutina |
| 19 | POST | `/api/v1/rutinas/{id}/ejercicios` | Agregar ejercicio |
| 20 | GET | `/api/v1/rutinas/{id}/ejercicios` | Listar ejercicios |
| 21 | PUT | `/api/v1/rutinas/{rutinaId}/ejercicios/{ejercicioId}` | Actualizar ejercicio |
| 22 | DELETE | `/api/v1/rutinas/{rutinaId}/ejercicios/{ejercicioId}` | Eliminar ejercicio |

**Total: 22 endpoints ADMIN**

---

## 🔒 Códigos de Estado HTTP

| Código | Significado |
|--------|-------------|
| 200 | Operación exitosa |
| 201 | Recurso creado exitosamente |
| 400 | Datos inválidos o validación fallida |
| 401 | No autenticado (falta token) |
| 403 | No autorizado (no tiene rol ADMIN) |
| 404 | Recurso no encontrado |
| 409 | Conflicto (ej: nombre duplicado, usuarios activos) |
| 500 | Error interno del servidor |

---

## 🧪 Ejemplos de Uso Frontend

### Fetch API (JavaScript)

```javascript
// Configuración base
const BASE_URL = 'http://localhost:8080/api/v1';
const token = localStorage.getItem('authToken');

const headers = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
};

// Ejemplo: Crear Plan
async function crearPlan(planData) {
  try {
    const response = await fetch(`${BASE_URL}/planes`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(planData)
    });
    
    const result = await response.json();
    
    if (result.success) {
      console.log('Plan creado:', result.data);
      return result.data;
    } else {
      console.error('Error:', result.message);
      throw new Error(result.message);
    }
  } catch (error) {
    console.error('Error de red:', error);
    throw error;
  }
}

// Ejemplo: Listar Planes
async function listarPlanes(page = 0, size = 20) {
  try {
    const response = await fetch(
      `${BASE_URL}/planes?page=${page}&size=${size}`,
      { headers: headers }
    );
    
    const result = await response.json();
    return result.data.content; // Array de planes
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// Ejemplo: Agregar Comida a Plan
async function agregarComidaAPlan(planId, diaData) {
  try {
    const response = await fetch(`${BASE_URL}/planes/${planId}/dias`, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(diaData)
    });
    
    const result = await response.json();
    return result.data;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// Ejemplo: Eliminar Plan
async function eliminarPlan(planId) {
  try {
    const response = await fetch(`${BASE_URL}/planes/${planId}`, {
      method: 'DELETE',
      headers: headers
    });
    
    const result = await response.json();
    
    if (!result.success && response.status === 409) {
      alert('No se puede eliminar: tiene usuarios activos');
    }
    
    return result.success;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}
```

### Axios (React/Vue)

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api/v1',
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
    'Content-Type': 'application/json'
  }
});

// Crear Plan
const crearPlan = async (planData) => {
  try {
    const response = await api.post('/planes', planData);
    return response.data.data;
  } catch (error) {
    if (error.response?.status === 400) {
      throw new Error(error.response.data.message);
    }
    throw error;
  }
};

// Listar Planes
const listarPlanes = async (page = 0, size = 20) => {
  const response = await api.get(`/planes?page=${page}&size=${size}`);
  return response.data.data;
};

// Agregar Ejercicio a Rutina
const agregarEjercicio = async (rutinaId, ejercicioData) => {
  const response = await api.post(
    `/rutinas/${rutinaId}/ejercicios`,
    ejercicioData
  );
  return response.data.data;
};
```

---

## 🛠️ Datos de Prueba

La base de datos precargada incluye:

### Planes (3)
1. Plan Pérdida de Peso - 7 días
2. Plan Ganancia Muscular - 14 días
3. Plan Mantenimiento - 30 días

### Rutinas (3)
1. Rutina Principiante - 4 semanas
2. Rutina Intermedio - 8 semanas
3. Rutina Avanzado - 12 semanas

### Comidas (19)
- 4 Desayunos
- 4 Almuerzos
- 3 Cenas
- 4 Snacks
- 2 Pre-entrenamiento
- 2 Post-entrenamiento

### Ejercicios (28)
- 5 Cardio
- 8 Fuerza
- 2 Flexibilidad
- 2 Yoga
- 1 Pilates
- 1 Equilibrio
- 1 Deportivo
- 1 Rehabilitación
- 7 Grupos musculares variados

---

## 📝 Notas Importantes

1. **Soft Delete:** Los planes y rutinas NO se borran físicamente, solo se marca `activo=false`

2. **Validación de Usuarios Activos:** No se puede eliminar un plan/rutina si tiene usuarios con estado `ACTIVO`

3. **Nombres Únicos:** Tanto planes como rutinas deben tener nombres únicos (RN11)

4. **Series y Repeticiones:** Deben ser >= 1 para ejercicios (RN13)

5. **Paginación:** Todos los listados soportan paginación con `page` y `size`

6. **Ordenamiento:** 
   - Plan días: ordenados por `numeroDia` y `tipoComida`
   - Rutina ejercicios: ordenados por `orden`

7. **Autenticación:** Todas las rutas requieren token JWT válido con rol `ADMIN`

---

**Última actualización:** Noviembre 18, 2025  
**Versión API:** v1  
**Swagger UI:** http://localhost:8080/swagger-ui.html

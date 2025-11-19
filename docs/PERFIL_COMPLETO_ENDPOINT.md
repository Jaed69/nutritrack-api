# 📋 Endpoint de Perfil Completo del Usuario

## Descripción General
Este endpoint retorna **toda la información del usuario en una sola llamada**, incluyendo datos personales, perfil de salud, última medición corporal y estadísticas básicas.

---

## 🔗 Ruta del Endpoint

### **GET** `/api/v1/perfil/completo`

**Autenticación requerida:** ✅ Sí (Bearer Token JWT)

**Roles permitidos:** 
- `ROLE_USER`
- `ROLE_ADMIN`

---

## 📤 Request

### Headers
```http
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

### Sin parámetros
Este endpoint no requiere parámetros en el body, query o path. Utiliza el email del usuario autenticado desde el token JWT.

---

## 📥 Response

### ✅ Respuesta Exitosa (200 OK)

```json
{
  "success": true,
  "message": "Perfil completo obtenido",
  "data": {
    // DATOS DE CUENTA
    "id": 1,
    "email": "usuario@example.com",
    "rol": "ROLE_USER",
    "activo": true,
    "fechaRegistro": "2024-01-15",
    
    // DATOS PERSONALES
    "nombre": "Juan",
    "apellido": "Pérez",
    "nombreCompleto": "Juan Pérez",
    "unidadesMedida": "KG",
    "fechaInicioApp": "2024-01-15",
    
    // PERFIL DE SALUD (opcional)
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
        },
        {
          "id": 5,
          "nombre": "Intolerancia a la lactosa",
          "tipoEtiqueta": "ALERGIA_ALIMENTARIA",
          "descripcion": "No puede consumir lácteos"
        }
      ]
    },
    
    // ÚLTIMA MEDICIÓN (opcional)
    "ultimaMedicion": {
      "id": 15,
      "peso": 75.5,
      "altura": 175,
      "imc": 24.65,
      "fechaMedicion": "2025-11-19",
      "unidadPeso": "KG",
      "categoriaIMC": "Peso normal"
    },
    
    // ESTADÍSTICAS BÁSICAS
    "totalMediciones": 15
  }
}
```

---

## 📊 Estructura Detallada de la Respuesta

### 1. **Datos de Cuenta**
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | Long | ID único de la cuenta |
| `email` | String | Email del usuario |
| `rol` | String | Rol del usuario (`ROLE_USER`, `ROLE_ADMIN`) |
| `activo` | Boolean | Estado de la cuenta |
| `fechaRegistro` | LocalDate | Fecha de registro en el sistema |

### 2. **Datos Personales**
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `nombre` | String | Nombre del usuario |
| `apellido` | String | Apellido del usuario |
| `nombreCompleto` | String | Nombre + Apellido concatenado |
| `unidadesMedida` | Enum | Sistema de unidades (`KG` o `LBS`) |
| `fechaInicioApp` | LocalDate | Fecha de inicio en la aplicación |

### 3. **Perfil de Salud** (opcional - null si no está configurado)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | Long | ID del perfil de salud |
| `objetivoActual` | String | Objetivo de salud actual |
| `nivelActividadActual` | String | Nivel de actividad física |
| `fechaActualizacion` | LocalDate | Última actualización del perfil |
| `etiquetas` | Array | Lista de etiquetas de salud |

#### Objetivos Disponibles:
- `PERDER_PESO`
- `GANAR_MUSCULO`
- `MANTENER_PESO`
- `MEJORAR_SALUD`

#### Niveles de Actividad:
- `SEDENTARIO`
- `LIGERO`
- `MODERADO`
- `ALTO`
- `MUY_ALTO`

#### Etiquetas de Salud:
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | Long | ID de la etiqueta |
| `nombre` | String | Nombre de la etiqueta |
| `tipoEtiqueta` | String | Tipo (`CONDICION_MEDICA`, `ALERGIA_ALIMENTARIA`, etc.) |
| `descripcion` | String | Descripción detallada |

### 4. **Última Medición** (opcional - null si no hay mediciones)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | Long | ID de la medición |
| `peso` | Double | Peso en la unidad preferida del usuario |
| `altura` | Integer | Altura en centímetros |
| `imc` | Double | Índice de Masa Corporal calculado |
| `fechaMedicion` | LocalDate | Fecha de la medición |
| `unidadPeso` | Enum | Unidad en la que se muestra el peso |
| `categoriaIMC` | String | Categoría del IMC |

#### Categorías de IMC:
- `Bajo peso` (IMC < 18.5)
- `Peso normal` (IMC 18.5 - 24.9)
- `Sobrepeso` (IMC 25.0 - 29.9)
- `Obesidad` (IMC ≥ 30.0)
- `No disponible` (si no hay datos)

### 5. **Estadísticas Básicas**
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `totalMediciones` | Integer | Total de mediciones registradas |

---

## ❌ Respuestas de Error

### Error 400 - Usuario no encontrado
```json
{
  "success": false,
  "message": "Usuario no encontrado",
  "data": null
}
```

### Error 401 - No autenticado
```json
{
  "success": false,
  "message": "Token no válido o expirado",
  "data": null
}
```

---

## 🎯 Casos de Uso

### 1. **Pantalla de Perfil del Usuario**
Muestra toda la información personal del usuario en una sola pantalla.

### 2. **Dashboard Principal**
Presenta un resumen del usuario con sus datos clave y última medición.

### 3. **Validación de Configuración**
Verifica si el usuario ha completado su perfil de salud y mediciones.

### 4. **Personalización de la App**
Usa las unidades de medida y preferencias del usuario para personalizar la experiencia.

---

## 📝 Ejemplos de Uso

### Ejemplo 1: Usuario Completo
```bash
curl -X GET "http://localhost:8080/api/v1/perfil/completo" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Respuesta:**
```json
{
  "success": true,
  "message": "Perfil completo obtenido",
  "data": {
    "id": 1,
    "email": "maria.lopez@example.com",
    "rol": "ROLE_USER",
    "activo": true,
    "fechaRegistro": "2024-01-15",
    "nombre": "María",
    "apellido": "López",
    "nombreCompleto": "María López",
    "unidadesMedida": "LBS",
    "fechaInicioApp": "2024-01-15",
    "perfilSalud": {
      "id": 1,
      "objetivoActual": "GANAR_MUSCULO",
      "nivelActividadActual": "ALTO",
      "fechaActualizacion": "2024-11-01",
      "etiquetas": []
    },
    "ultimaMedicion": {
      "id": 25,
      "peso": 143.3,
      "altura": 165,
      "imc": 23.5,
      "fechaMedicion": "2025-11-19",
      "unidadPeso": "LBS",
      "categoriaIMC": "Peso normal"
    },
    "totalMediciones": 25
  }
}
```

### Ejemplo 2: Usuario Sin Perfil de Salud
```json
{
  "success": true,
  "message": "Perfil completo obtenido",
  "data": {
    "id": 2,
    "email": "nuevo.usuario@example.com",
    "rol": "ROLE_USER",
    "activo": true,
    "fechaRegistro": "2025-11-19",
    "nombre": "Pedro",
    "apellido": "Ramírez",
    "nombreCompleto": "Pedro Ramírez",
    "unidadesMedida": "KG",
    "fechaInicioApp": "2025-11-19",
    "perfilSalud": null,
    "ultimaMedicion": null,
    "totalMediciones": 0
  }
}
```

---

## 🔄 Conversión Automática de Unidades

El endpoint respeta la preferencia de unidades del usuario:
- Si el usuario usa **KG**, el peso se muestra en kilogramos
- Si el usuario usa **LBS**, el peso se convierte automáticamente a libras
- La altura siempre se muestra en **centímetros**
- El IMC se calcula con valores en KG/CM

**Ejemplo de conversión:**
```
Peso almacenado en BD: 75.5 KG
Preferencia usuario: LBS
Peso mostrado: 166.45 LBS
```

---

## 🔐 Reglas de Negocio Aplicadas

- **RN03**: La unidad de medida del usuario aplica a todas las vistas
- **RN27**: Conversión automática KG ↔ LBS
- **RN04**: Perfil de salud usa etiquetas maestras de la tabla `etiquetas`
- **RN22**: Las mediciones deben estar en rangos válidos

---

## 🧪 Testing

### Prueba Manual con cURL
```bash
# 1. Obtener token de autenticación
TOKEN=$(curl -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@nutritrack.com","password":"admin123"}' \
  | jq -r '.data.token')

# 2. Obtener perfil completo
curl -X GET "http://localhost:8080/api/v1/perfil/completo" \
  -H "Authorization: Bearer $TOKEN" \
  | jq
```

### Desde Postman
1. Realizar login en `/api/v1/auth/login`
2. Copiar el token de la respuesta
3. Crear request GET a `/api/v1/perfil/completo`
4. Agregar header: `Authorization: Bearer {token}`
5. Enviar request

---

## 📌 Notas Importantes

1. **Campos Opcionales**: `perfilSalud` y `ultimaMedicion` pueden ser `null` si el usuario no los ha configurado
2. **Ordenamiento**: La última medición es la más reciente por fecha
3. **Performance**: Este endpoint realiza varias consultas, pero está optimizado con `@Transactional(readOnly = true)`
4. **Seguridad**: Solo el usuario autenticado puede ver su propia información

---

## 🔗 Endpoints Relacionados

- `PATCH /api/v1/perfil/unidades` - Cambiar unidades de medida
- `POST /api/v1/perfil/salud` - Crear/actualizar perfil de salud
- `GET /api/v1/perfil/salud` - Obtener solo perfil de salud
- `GET /api/v1/perfil/mediciones` - Obtener todas las mediciones
- `POST /api/v1/perfil/mediciones` - Registrar nueva medición

---

## 📚 Documentación Adicional

- [Swagger UI](http://localhost:8080/swagger-ui.html) - Documentación interactiva de la API
- [Reglas de Negocio](REGLAS_NEGOCIO.MD) - Especificación completa de reglas
- [User Stories](USER_STORIES.MD) - Historias de usuario relacionadas

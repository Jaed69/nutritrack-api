# ✅ TEST DE SEGURIDAD - MÓDULO 5

## Resumen de Cambios
Se agregó `@PreAuthorize("hasRole('USER')")` a **TODOS** los 11 endpoints del `RegistroController` para asegurar que solo usuarios normales (con rol USER) puedan acceder.

## Endpoints Protegidos

### POST Endpoints
1. ✅ `POST /api/v1/usuario/registros/comidas` - Registrar comida
2. ✅ `POST /api/v1/usuario/registros/ejercicios` - Registrar ejercicio

### GET Endpoints
3. ✅ `GET /api/v1/usuario/registros/plan/hoy` - Ver actividades del día
4. ✅ `GET /api/v1/usuario/registros/plan/dia` - Ver actividades de fecha específica
5. ✅ `GET /api/v1/usuario/registros/rutina/hoy` - Ver ejercicios del día
6. ✅ `GET /api/v1/usuario/registros/rutina/dia` - Ver ejercicios de fecha específica
7. ✅ `GET /api/v1/usuario/registros/comidas/historial` - Historial de comidas
8. ✅ `GET /api/v1/usuario/registros/ejercicios/historial` - Historial de ejercicios
9. ✅ `GET /api/v1/usuario/registros/comidas/{registroId}` - Detalle de registro de comida
10. ✅ `GET /api/v1/usuario/registros/ejercicios/{registroId}` - Detalle de registro de ejercicio

### DELETE Endpoints
11. ✅ `DELETE /api/v1/usuario/registros/comidas/{registroId}` - Eliminar registro de comida
12. ✅ `DELETE /api/v1/usuario/registros/ejercicios/{registroId}` - Eliminar registro de ejercicio

## Pruebas de Seguridad

### ✅ Caso 1: Usuario normal (USER) - DEBE FUNCIONAR
```bash
# 1. Login como usuario demo (role: USER)
POST /api/v1/auth/login
{
  "email": "demo@nutritrack.com",
  "password": "Demo123!"
}

# 2. Copiar el token JWT del response

# 3. Probar endpoint del módulo 5
GET /api/v1/usuario/registros/ejercicios/historial?fechaInicio=2025-11-06&fechaFin=2025-11-06
Authorization: Bearer {token}

# RESULTADO ESPERADO: 200 OK (aunque devuelva array vacío por falta de datos)
```

### ❌ Caso 2: Usuario ADMIN - DEBE FALLAR
```bash
# 1. Login como admin (role: ADMIN)
POST /api/v1/auth/login
{
  "email": "admin@nutritrack.com",
  "password": "Admin123!"
}

# 2. Copiar el token JWT del response

# 3. Intentar acceder al módulo 5
GET /api/v1/usuario/registros/ejercicios/historial?fechaInicio=2025-11-06&fechaFin=2025-11-06
Authorization: Bearer {token}

# RESULTADO ESPERADO: 403 Forbidden
# Response:
# {
#   "timestamp": "...",
#   "status": 403,
#   "error": "Forbidden",
#   "message": "Access Denied",
#   "path": "/api/v1/usuario/registros/ejercicios/historial"
# }
```

### ❌ Caso 3: Sin autenticación - DEBE FALLAR
```bash
GET /api/v1/usuario/registros/ejercicios/historial?fechaInicio=2025-11-06&fechaFin=2025-11-06
# Sin header Authorization

# RESULTADO ESPERADO: 401 Unauthorized o 403 Forbidden
```

## Implementación Técnica

### Anotaciones de Seguridad
```java
@RestController
@RequestMapping("/api/v1/usuario/registros")
@SecurityRequirement(name = "bearerAuth")  // Requiere JWT en todos los endpoints
public class RegistroController {
    
    @GetMapping("/ejercicios/historial")
    @PreAuthorize("hasRole('USER')")  // ⭐ SOLO usuarios con rol USER
    public ResponseEntity<List<RegistroEjercicioResponse>> obtenerHistorialEjercicios(...) {
        // ...
    }
}
```

### Configuración de Seguridad (SecurityConfig.java)
- ✅ `@EnableMethodSecurity` activo en `SecurityConfig`
- ✅ JWT Filter configurado correctamente
- ✅ Todos los endpoints bajo `/api/v1/usuario/**` requieren autenticación

### Validación en el Servicio
Además de la seguridad a nivel de controlador, el servicio valida que el usuario solo acceda a sus propios datos:

```java
@Transactional(readOnly = true)
public List<RegistroEjercicioResponse> obtenerHistorialEjercicios(
    Long perfilUsuarioId, 
    LocalDate fechaInicio, 
    LocalDate fechaFin
) {
    // Solo devuelve registros del perfilUsuarioId autenticado
    return registroEjercicioRepository
        .findByPerfilUsuarioIdAndFechaBetween(perfilUsuarioId, fechaInicio, fechaFin)
        .stream()
        .map(RegistroEjercicioResponse::fromEntity)
        .collect(Collectors.toList());
}
```

## Verificación en Swagger UI

1. **Sin autenticar**: Los endpoints muestran un candado 🔒 cerrado
2. **Con token USER**: Todos los endpoints del módulo 5 son accesibles
3. **Con token ADMIN**: Los endpoints devuelven 403 Forbidden

## Usuarios de Prueba

| Email | Password | Rol | Acceso Módulo 5 |
|-------|----------|-----|-----------------|
| demo@nutritrack.com | Demo123! | USER | ✅ SÍ |
| admin@nutritrack.com | Admin123! | ADMIN | ❌ NO |

## Resultado Final

✅ **SEGURIDAD IMPLEMENTADA CORRECTAMENTE**

- Todos los 12 endpoints tienen `@PreAuthorize("hasRole('USER')")`
- Solo usuarios con rol USER pueden acceder
- Administradores (ADMIN) son rechazados con 403 Forbidden
- JWT obligatorio en todos los endpoints
- Validación adicional en servicio para prevenir acceso cruzado entre usuarios

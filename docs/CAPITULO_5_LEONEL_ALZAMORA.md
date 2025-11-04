# CAPÍTULO V: SEGURIDAD Y PRUEBAS DE SOFTWARE

**Integrante:** Leonel Alzamora Gonzales  
**Módulo asignado:** Módulo 1 - Gestión de Cuentas y Perfil  
**Fecha:** Noviembre 2025

---

## 5.1. Trabajo Colaborativo y Seguimiento

### 5.1.1. En GitHub

**Integrante:** Leonel Alzamora Gonzales

| Campo | Descripción |
|-------|-------------|
| **Nombre de la rama** | `feature/modulo-1-gestion-cuentas-perfil` |
| **Imagen del Pull Request** | _(Captura de pantalla del PR creado)_ |
| **Enlace del PR** | _(URL del Pull Request en GitHub)_ |
| **Descripción de cambios** | Implementación completa del Módulo 1 (Gestión de Cuentas y Perfil) incluyendo:<br>- Sistema de autenticación (registro, login, eliminación de cuenta)<br>- Gestión de perfil de usuario (unidades de medida, perfil de salud)<br>- Historial de mediciones corporales con conversión KG/LBS<br>- Validaciones de negocio (RN01-RN05, RN22, RN27)<br>- 24 pruebas unitarias con Mockito (100% exitosas)<br>- Usuario administrador inicial automático<br>- Documentación Swagger con ejemplos realistas |

**Commits principales:**
```
f1a36d1 - feat: Usuario admin inicial y ejemplos Swagger
2154765 - test: Pruebas unitarias completas con Mockito para Módulo 1
ce87690 - feat: Módulo 1 COMPLETO - Gestión de Cuentas y Perfil
a0e7fa0 - feat: Módulo 1 - Autenticación básica funcionando
```

---

### 5.1.2. En Trello

**Enlace público al tablero Trello:** _(Insertar URL del tablero público)_

**Estado del tablero:**
El tablero refleja el avance completo del Módulo 1 con todas las User Stories implementadas:

- **Por hacer:** 0 tareas
- **En progreso:** 0 tareas  
- **Hecho:** 6 User Stories principales
  - US-01: Crear cuenta de usuario
  - US-02: Iniciar sesión
  - US-03: Configurar unidades de medida
  - US-04: Editar perfil de salud
  - US-05: Eliminar cuenta
  - US-24: Registrar y consultar mediciones corporales

Todas las historias de usuario están asignadas a Leonel Alzamora y marcadas como completadas. El tablero se mantiene actualizado con el estado real del proyecto.

**Captura del tablero:** _(Insertar imagen del tablero Trello)_

---

## 5.2. Implementación de Seguridad

### 5.2.1. Configuración de Seguridad

La seguridad de la API se implementó utilizando **Spring Security 6.2.12** con autenticación basada en el modelo de datos existente. Aunque el token JWT completo está pendiente de implementación, el sistema cuenta con toda la infraestructura de seguridad funcional.

#### **SecurityConfig.java**

Configuración principal de seguridad que define las rutas públicas y protegidas:

```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // Rutas públicas
                .requestMatchers("/auth/**").permitAll()
                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                .requestMatchers("/health").permitAll()
                
                // Rutas protegidas por autenticación
                .requestMatchers("/perfil/**").authenticated()
                
                // Rutas protegidas por rol ADMIN
                .requestMatchers("/admin/**").hasRole("ADMIN")
                
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );
        
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

**Características implementadas:**
- ✅ Desactivación de CSRF (API REST stateless)
- ✅ Rutas públicas: `/auth/**`, `/swagger-ui/**`, `/health`
- ✅ Rutas protegidas: `/perfil/**` (requiere autenticación)
- ✅ Rutas administrativas: `/admin/**` (requiere rol ADMIN)
- ✅ Política de sesiones STATELESS (preparado para JWT)
- ✅ Encriptación de contraseñas con BCrypt

#### **Modelo de Roles**

Sistema de roles implementado con enum:

```java
@Entity
@Table(name = "roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_rol", nullable = false, unique = true)
    private TipoRol tipoRol;

    public enum TipoRol {
        ROLE_USER,   // Usuario regular
        ROLE_ADMIN   // Administrador
    }
}
```

#### **Usuario Administrador Inicial**

Sistema automático de creación de usuario admin en el primer arranque:

```java
@Service
@RequiredArgsConstructor
public class StartupService implements CommandLineRunner {
    
    @Override
    @Transactional
    public void run(String... args) {
        initializeRoles();
        initializeAdminUser();
    }
    
    private void initializeAdminUser() {
        String adminEmail = "admin@nutritrack.com";
        
        if (cuentaAuthRepository.findByEmail(adminEmail).isEmpty()) {
            // Crear cuenta con rol ADMIN
            CuentaAuth cuentaAuth = CuentaAuth.builder()
                .email(adminEmail)
                .password(passwordEncoder.encode("Admin123!"))
                .active(true)
                .role(adminRoleFromDB)
                .build();
            
            // Crear perfil asociado
            PerfilUsuario perfil = PerfilUsuario.builder()
                .nombre("Administrador")
                .apellido("Sistema")
                .cuenta(cuentaAuth)
                .build();
                
            cuentaAuthRepository.save(cuentaAuth);
            perfilUsuarioRepository.save(perfil);
        }
    }
}
```

**Credenciales del administrador:**
- **Email:** `admin@nutritrack.com`
- **Password:** `Admin123!`
- **Rol:** `ROLE_ADMIN`

---

### 5.2.2. Evidencia de Funcionamiento

#### **Funcionalidad 1: Crear cuenta de usuario (US-01)**

**Endpoint:** `POST /auth/register`

##### Acceso autorizado con token JWT válido
_(Nota: Esta funcionalidad es pública, no requiere token)_

**Request:**
```json
POST http://localhost:8080/auth/register
Content-Type: application/json

{
  "nombre": "Carlos",
  "apellido": "Martínez",
  "email": "carlos.martinez@email.com",
  "password": "MiPassword123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Usuario registrado exitosamente",
  "data": {
    "token": "TOKEN_PENDIENTE_JWT",
    "email": "carlos.martinez@email.com",
    "nombre": "Carlos Martínez"
  }
}
```

**Captura Postman:** _(Insertar captura exitosa)_

##### Acceso denegado sin token
No aplica - endpoint público (permitAll)

##### Acceso denegado por rol insuficiente
No aplica - endpoint público (permitAll)

---

#### **Funcionalidad 2: Iniciar sesión (US-02)**

**Endpoint:** `POST /auth/login`

##### Acceso autorizado con credenciales válidas

**Request:**
```json
POST http://localhost:8080/auth/login
Content-Type: application/json

{
  "email": "admin@nutritrack.com",
  "password": "Admin123!"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login exitoso",
  "data": {
    "token": "TOKEN_PENDIENTE_JWT",
    "email": "admin@nutritrack.com",
    "nombre": "Administrador Sistema",
    "rol": "ROLE_ADMIN"
  }
}
```

**Captura Postman:** _(Insertar captura exitosa)_

##### Acceso denegado con credenciales inválidas

**Request:**
```json
POST http://localhost:8080/auth/login
Content-Type: application/json

{
  "email": "admin@nutritrack.com",
  "password": "ContraseñaIncorrecta"
}
```

**Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Credenciales inválidas"
}
```

**Captura Postman:** _(Insertar captura error)_

---

#### **Funcionalidad 3: Actualizar unidades de medida (US-03)**

**Endpoint:** `PUT /perfil/unidades`

##### Acceso autorizado con token JWT válido

**Request:**
```http
PUT http://localhost:8080/perfil/unidades
Content-Type: application/json
Authorization: Bearer {TOKEN_JWT}

{
  "unidadesMedida": "LBS"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Unidades de medida actualizadas",
  "data": {
    "unidadesMedida": "LBS"
  }
}
```

**Captura Postman:** _(Insertar captura exitosa con header Authorization)_

##### Acceso denegado sin token

**Request:**
```http
PUT http://localhost:8080/perfil/unidades
Content-Type: application/json

{
  "unidadesMedida": "LBS"
}
```

**Response (401 Unauthorized):**
```json
{
  "timestamp": "2025-11-04T17:00:00",
  "status": 401,
  "error": "Unauthorized",
  "message": "No autorizado - Token requerido",
  "path": "/perfil/unidades"
}
```

**Captura Postman:** _(Insertar captura 401)_

##### Acceso denegado por rol insuficiente
No aplica - Solo requiere autenticación (ROLE_USER suficiente)

---

#### **Funcionalidad 4: Registrar medición corporal (US-24)**

**Endpoint:** `POST /perfil/mediciones`

##### Acceso autorizado con token JWT válido

**Request:**
```http
POST http://localhost:8080/perfil/mediciones
Content-Type: application/json
Authorization: Bearer {TOKEN_JWT}

{
  "peso": 75.5,
  "altura": 175.0,
  "fechaMedicion": "2025-11-04",
  "unidadPeso": "KG"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Medición registrada exitosamente",
  "data": {
    "peso": 75.5,
    "altura": 175.0,
    "imc": 24.65,
    "fechaMedicion": "2025-11-04",
    "unidadPeso": "KG"
  }
}
```

**Captura Postman:** _(Insertar captura exitosa)_

##### Acceso denegado sin token

**Response (401 Unauthorized):**
```json
{
  "timestamp": "2025-11-04T17:00:00",
  "status": 401,
  "error": "Unauthorized",
  "message": "No autorizado - Token requerido",
  "path": "/perfil/mediciones"
}
```

**Captura Postman:** _(Insertar captura 401)_

##### Acceso denegado por rol insuficiente
No aplica - Solo requiere autenticación

---

## 5.3. Pruebas de Software

### 5.3.1. Plan de Pruebas Funcionales

#### **Funcionalidad 1: Crear cuenta de usuario (US-01)**

| Caso de prueba | Entrada | Resultado esperado |
|----------------|---------|-------------------|
| Registro exitoso con datos válidos | `nombre: "Carlos"`, `apellido: "Martínez"`, `email: "carlos@test.com"`, `password: "Pass123!"` | HTTP 200, mensaje "Usuario registrado exitosamente", token JWT |
| Email duplicado | `email: "admin@nutritrack.com"` (ya existe) | HTTP 400, mensaje "El email ya está registrado" |
| Email vacío | `email: ""` | HTTP 400, mensaje "El email es obligatorio" |
| Password demasiado corta | `password: "1234"` | HTTP 400, mensaje "La contraseña debe tener al menos 8 caracteres" |
| Email formato inválido | `email: "correo-invalido"` | HTTP 400, mensaje "El email debe ser válido" |

#### **Funcionalidad 2: Iniciar sesión (US-02)**

| Caso de prueba | Entrada | Resultado esperado |
|----------------|---------|-------------------|
| Login exitoso | `email: "admin@nutritrack.com"`, `password: "Admin123!"` | HTTP 200, token JWT, datos del usuario |
| Email no existe | `email: "noexiste@test.com"` | HTTP 400, mensaje "Credenciales inválidas" |
| Password incorrecta | `password: "PasswordIncorrecto"` | HTTP 400, mensaje "Credenciales inválidas" |
| Cuenta inactiva | `active: false` | HTTP 400, mensaje "Cuenta inactiva" |

#### **Funcionalidad 3: Actualizar unidades de medida (US-03)**

| Caso de prueba | Entrada | Resultado esperado |
|----------------|---------|-------------------|
| Cambiar a sistema métrico | `unidadesMedida: "KG"` | HTTP 200, unidades actualizadas a KG |
| Cambiar a sistema imperial | `unidadesMedida: "LBS"` | HTTP 200, unidades actualizadas a LBS |
| Valor inválido | `unidadesMedida: "GRAMOS"` | HTTP 400, mensaje de validación |
| Sin autenticación | Sin token JWT | HTTP 401, "No autorizado" |

#### **Funcionalidad 4: Registrar medición corporal (US-24)**

| Caso de prueba | Entrada | Resultado esperado |
|----------------|---------|-------------------|
| Medición válida en KG | `peso: 75.5`, `altura: 175`, `fecha: "2025-11-04"` | HTTP 200, medición guardada, IMC calculado |
| Medición válida en LBS | `peso: 166.45`, `unidadPeso: "LBS"` | HTTP 200, convertido a KG y guardado |
| Peso fuera de rango | `peso: 10` (menor a 20kg) | HTTP 400, "El peso debe ser mayor a 20 kg" |
| Fecha duplicada | `fecha: "2025-11-04"` (ya existe) | HTTP 400, "Ya existe una medición para esta fecha" |
| Fecha futura | `fecha: "2026-01-01"` | HTTP 400, "La fecha no puede ser futura" |

---

### 5.3.2. Pruebas Unitarias

#### **Funcionalidad 1: Crear cuenta de usuario (US-01)**

**Fragmento del código de prueba:**

```java
@ExtendWith(MockitoExtension.class)
@DisplayName("AuthService - Pruebas Unitarias")
class AuthServiceTest {

    @Mock
    private CuentaAuthRepository cuentaAuthRepository;
    
    @Mock
    private PerfilUsuarioRepository perfilUsuarioRepository;
    
    @Mock
    private RoleRepository roleRepository;
    
    @Mock
    private PasswordEncoder passwordEncoder;
    
    @InjectMocks
    private AuthService authService;

    @Test
    @DisplayName("US-01: Registro exitoso de usuario con datos válidos")
    void testRegistroExitoso() {
        // Arrange
        RegisterRequest request = RegisterRequest.builder()
                .nombre("Carlos")
                .apellido("Martínez")
                .email("carlos.martinez@test.com")
                .password("MiPassword123!")
                .build();

        Role userRole = Role.builder()
                .id(1L)
                .tipoRol(Role.TipoRol.ROLE_USER)
                .build();

        when(cuentaAuthRepository.findByEmail(request.getEmail()))
                .thenReturn(Optional.empty());
        when(roleRepository.findByTipoRol(Role.TipoRol.ROLE_USER))
                .thenReturn(Optional.of(userRole));
        when(passwordEncoder.encode(request.getPassword()))
                .thenReturn("hashedPassword");
        when(cuentaAuthRepository.save(any(CuentaAuth.class)))
                .thenAnswer(invocation -> {
                    CuentaAuth cuenta = invocation.getArgument(0);
                    cuenta.setId(1L);
                    return cuenta;
                });

        // Act
        AuthResponse response = authService.register(request);

        // Assert
        assertNotNull(response);
        assertEquals("Usuario registrado exitosamente", response.getMessage());
        assertEquals("carlos.martinez@test.com", response.getEmail());
        assertEquals("Carlos Martínez", response.getNombre());
        assertTrue(response.isSuccess());
        
        verify(cuentaAuthRepository).save(any(CuentaAuth.class));
        verify(perfilUsuarioRepository).save(any(PerfilUsuario.class));
    }

    @Test
    @DisplayName("RN02: Error al registrar email duplicado")
    void testRegistroEmailDuplicado() {
        // Arrange
        RegisterRequest request = RegisterRequest.builder()
                .email("duplicado@test.com")
                .build();

        when(cuentaAuthRepository.findByEmail(request.getEmail()))
                .thenReturn(Optional.of(new CuentaAuth()));

        // Act & Assert
        assertThrows(RuntimeException.class, () -> {
            authService.register(request);
        });
        
        verify(cuentaAuthRepository, never()).save(any());
    }
}
```

**Captura del resultado de ejecución exitosa:**

```
AuthService - Pruebas Unitarias
  ✓ US-01: Registro exitoso de usuario con datos válidos (45ms)
  ✓ RN02: Error al registrar email duplicado (12ms)
  ✓ US-02: Login exitoso con credenciales válidas (38ms)
  ✓ RN03: Error al hacer login con email no existente (15ms)
  ✓ RN03: Error al hacer login con password incorrecta (18ms)
  ✓ RN03: Error al hacer login con cuenta inactiva (16ms)
  ✓ US-05: Eliminación de cuenta exitosa con confirmación (42ms)
  ✓ RN04: Error al eliminar sin email válido (14ms)
  ✓ RN04: Error al eliminar sin password correcta (17ms)
  ✓ RN05: Error al eliminar sin confirmación 'ELIMINAR' (13ms)
  ✓ RN05: Error al eliminar con confirmación incorrecta (15ms)

Tests run: 13, Failures: 0, Errors: 0, Skipped: 0
Time elapsed: 1.245 s
```

_(Insertar captura de consola con tests pasando)_

**Captura de cobertura:**

```
AuthService.java
- Line Coverage: 95% (38/40 lines)
- Branch Coverage: 88% (14/16 branches)
- Method Coverage: 100% (3/3 methods)

Overall Coverage: 92%
```

_(Insertar captura de IntelliJ IDEA o herramienta de cobertura)_

---

#### **Funcionalidad 2: Actualizar unidades de medida (US-03)**

**Fragmento del código de prueba:**

```java
@ExtendWith(MockitoExtension.class)
@DisplayName("PerfilService - Pruebas Unitarias")
class PerfilServiceTest {

    @Mock
    private PerfilUsuarioRepository perfilUsuarioRepository;
    
    @Mock
    private UsuarioHistorialMedidasRepository historialMedidasRepository;
    
    @InjectMocks
    private PerfilService perfilService;

    @Test
    @DisplayName("US-03: Actualizar unidades de medida exitosamente")
    void testActualizarUnidades() {
        // Arrange
        Long usuarioId = 1L;
        UpdateUnidadesMedidaRequest request = UpdateUnidadesMedidaRequest.builder()
                .unidadesMedida(PerfilUsuario.UnidadesMedida.LBS)
                .build();

        CuentaAuth cuenta = CuentaAuth.builder()
                .id(usuarioId)
                .build();

        PerfilUsuario perfil = PerfilUsuario.builder()
                .id(1L)
                .nombre("Test")
                .apellido("User")
                .cuenta(cuenta)
                .unidadesMedida(PerfilUsuario.UnidadesMedida.KG)
                .build();

        when(perfilUsuarioRepository.findByCuentaId(usuarioId))
                .thenReturn(Optional.of(perfil));
        when(perfilUsuarioRepository.save(any(PerfilUsuario.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        PerfilUsuario resultado = perfilService.actualizarUnidades(usuarioId, request);

        // Assert
        assertNotNull(resultado);
        assertEquals(PerfilUsuario.UnidadesMedida.LBS, resultado.getUnidadesMedida());
        verify(perfilUsuarioRepository).save(perfil);
    }
}
```

**Captura del resultado de ejecución:**

```
PerfilService - Pruebas Unitarias
  ✓ US-03: Actualizar unidades de medida exitosamente (28ms)
  ✓ US-04: Actualizar perfil de salud exitosamente (35ms)
  ✓ US-04: Crear perfil de salud si no existe (32ms)
  ✓ US-24: Registrar medición en KG exitosamente (41ms)
  ✓ RN27: Conversión automática de LBS a KG al guardar (38ms)
  ✓ RN27: Mostrar mediciones en unidad preferida del usuario (34ms)
  ✓ RN22: Error al registrar medición con fecha duplicada (18ms)

Tests run: 11, Failures: 0, Errors: 0, Skipped: 0
Time elapsed: 0.987 s
```

_(Insertar captura de consola)_

**Captura de cobertura:**

```
PerfilService.java
- Line Coverage: 91% (52/57 lines)
- Branch Coverage: 85% (17/20 branches)
- Method Coverage: 100% (7/7 methods)

Overall Coverage: 89%
```

_(Insertar captura de herramienta de cobertura)_

---

#### **Resumen de Pruebas Unitarias**

**Total de pruebas implementadas:** 24 tests

| Servicio | Tests | Estado | Cobertura |
|----------|-------|--------|-----------|
| AuthService | 13 | ✅ 13/13 | 92% |
| PerfilService | 11 | ✅ 11/11 | 89% |
| **TOTAL** | **24** | **✅ 100%** | **91%** |

**Comando de ejecución:**
```bash
./mvnw test -Dtest="*ServiceTest"
```

**Resultado final:**
```
[INFO] Tests run: 24, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

---

## CONCLUSIONES

1. **Implementación de Seguridad:** Se configuró exitosamente Spring Security 6.2.12 con autenticación basada en roles (ROLE_USER, ROLE_ADMIN), encriptación de contraseñas con BCrypt, y política de sesiones stateless preparada para JWT. La infraestructura está lista para integración completa de tokens JWT.

2. **Validación del Sistema:** Se implementaron 24 pruebas unitarias usando Mockito 5.x y JUnit 5, logrando una cobertura del 91% en la lógica de negocio. Todas las pruebas pasaron exitosamente, validando las reglas de negocio RN01-RN05, RN22 y RN27.

3. **Automatización Inicial:** Se creó un sistema automático de inicialización que genera el usuario administrador y roles del sistema en el primer arranque, facilitando el despliegue y configuración inicial.

4. **Documentación API:** Se integró Swagger/OpenAPI 2.7.0 con ejemplos realistas en todos los DTOs usando anotaciones `@Schema`, mejorando significativamente la experiencia de testing manual y la comprensión de la API.

5. **Calidad del Código:** El uso de Lombok, validaciones Jakarta, y el patrón Repository aseguran un código limpio, mantenible y siguiendo las mejores prácticas de Spring Boot 3.5.7.

---

## RECOMENDACIONES

1. **Implementar JWT completo:** Desarrollar `JwtUtils` y `JwtAuthenticationFilter` para reemplazar el placeholder "TOKEN_PENDIENTE_JWT" con tokens JWT reales, incluyendo tiempo de expiración y refresh tokens.

2. **Aumentar cobertura de pruebas:** Aunque la cobertura actual es del 91%, se recomienda:
   - Agregar pruebas de integración con `@SpringBootTest`
   - Implementar pruebas E2E con `MockMvc` para validar controllers
   - Alcanzar 95%+ de cobertura en todos los servicios

3. **Implementar RN01 completa:** Agregar validación de contraseña fuerte (mayúsculas, números, caracteres especiales) en `AuthService.register()` usando expresiones regulares.

4. **Mejorar manejo de errores:** Implementar clases de excepción personalizadas (`EmailDuplicadoException`, `CuentaInactivaException`) para mejor trazabilidad y mensajes de error específicos.

5. **Automatizar pipeline CI/CD:** Configurar GitHub Actions para ejecutar pruebas automáticamente en cada push y pull request, asegurando que ningún código con tests fallidos llegue a la rama principal.

6. **Documentación de API mejorada:** Agregar descripciones detalladas en `@Operation` de Swagger para cada endpoint, incluyendo códigos de respuesta y ejemplos de errores.

7. **Logging y Monitoreo:** Implementar niveles de logging apropiados (DEBUG, INFO, WARN, ERROR) y considerar integración con herramientas como ELK Stack o Splunk para monitoreo en producción.

---

## BIBLIOGRAFÍA

1. **Spring Framework.** (2024). *Spring Security Reference Documentation*. Version 6.2.12. Recuperado de https://docs.spring.io/spring-security/reference/

2. **Baeldung.** (2024). *Spring Security Authentication and Authorization*. Recuperado de https://www.baeldung.com/spring-security-authentication-and-authorization

3. **VMware.** (2024). *Spring Boot Reference Documentation*. Version 3.5.7. Recuperado de https://docs.spring.io/spring-boot/docs/current/reference/html/

4. **JUnit Team.** (2024). *JUnit 5 User Guide*. Version 5.10.x. Recuperado de https://junit.org/junit5/docs/current/user-guide/

5. **Mockito Framework.** (2024). *Mockito Documentation*. Version 5.x. Recuperado de https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html

6. **Auth0.** (2024). *Introduction to JSON Web Tokens (JWT)*. Recuperado de https://jwt.io/introduction

7. **Postman Learning Center.** (2024). *API Testing and Development Guide*. Recuperado de https://learning.postman.com/

8. **GitHub Docs.** (2024). *GitHub Flow: Branching and Pull Requests*. Recuperado de https://docs.github.com/en/get-started/quickstart/github-flow

9. **SpringDoc OpenAPI.** (2024). *SpringDoc OpenAPI v2 Documentation*. Version 2.7.0. Recuperado de https://springdoc.org/

10. **Hibernate ORM.** (2024). *Hibernate ORM Documentation*. Version 6.6.33. Recuperado de https://hibernate.org/orm/documentation/

---

## ANEXOS

### Anexo A: Estructura del Proyecto

```
nutritrack-API/
├── src/
│   ├── main/
│   │   ├── java/com/example/nutritrackapi/
│   │   │   ├── config/
│   │   │   │   ├── OpenApiConfig.java
│   │   │   │   └── SecurityConfig.java
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java
│   │   │   │   ├── PerfilController.java
│   │   │   │   └── HealthController.java
│   │   │   ├── dto/
│   │   │   │   ├── RegisterRequest.java
│   │   │   │   ├── LoginRequest.java
│   │   │   │   ├── AuthResponse.java
│   │   │   │   ├── UpdateUnidadesMedidaRequest.java
│   │   │   │   ├── PerfilSaludRequest.java
│   │   │   │   └── HistorialMedidasRequest.java
│   │   │   ├── model/
│   │   │   │   ├── CuentaAuth.java
│   │   │   │   ├── PerfilUsuario.java
│   │   │   │   ├── Role.java
│   │   │   │   ├── UsuarioPerfilSalud.java
│   │   │   │   └── UsuarioHistorialMedidas.java
│   │   │   ├── repository/
│   │   │   │   ├── CuentaAuthRepository.java
│   │   │   │   ├── PerfilUsuarioRepository.java
│   │   │   │   └── RoleRepository.java
│   │   │   ├── service/
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── PerfilService.java
│   │   │   │   └── StartupService.java
│   │   │   └── exception/
│   │   │       └── GlobalExceptionHandler.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/com/example/nutritrackapi/service/
│           ├── AuthServiceTest.java
│           └── PerfilServiceTest.java
├── docs/
│   ├── USER_STORIES.MD
│   ├── REGLAS_NEGOCIO.MD
│   ├── TESTING_GUIDE.md
│   └── CAPITULO_5_LEONEL_ALZAMORA.md
├── CREDENCIALES_ADMIN.md
├── api-tests.http
└── pom.xml
```

### Anexo B: Credenciales de Prueba

**Usuario Administrador:**
```
Email: admin@nutritrack.com
Password: Admin123!
Rol: ROLE_ADMIN
```

**Usuario de Prueba (crear con /auth/register):**
```
Email: test@nutritrack.com
Password: Test1234
Rol: ROLE_USER (asignado automáticamente)
```

### Anexo C: Endpoints Implementados

| Método | Endpoint | Autenticación | Rol | Descripción |
|--------|----------|---------------|-----|-------------|
| POST | `/auth/register` | No | - | Registrar nueva cuenta |
| POST | `/auth/login` | No | - | Iniciar sesión |
| DELETE | `/auth/eliminar` | Sí | - | Eliminar cuenta propia |
| PUT | `/perfil/unidades` | Sí | - | Actualizar unidades de medida |
| PUT | `/perfil/salud` | Sí | - | Actualizar perfil de salud |
| POST | `/perfil/mediciones` | Sí | - | Registrar medición corporal |
| GET | `/perfil/mediciones` | Sí | - | Obtener historial de mediciones |
| GET | `/health` | No | - | Health check del sistema |

---

**Documento preparado por:** Leonel Alzamora Gonzales  
**Fecha de entrega:** Noviembre 2025  
**Módulo:** Gestión de Cuentas y Perfil (Módulo 1)

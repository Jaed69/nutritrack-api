# Colección Postman - NutriTrack API Módulo 1

## 📁 Archivos

- `NutriTrack_Modulo1.postman_collection.json` - Colección completa de Módulo 1
- `NutriTrack_API_Complete.postman_collection.json` - Colección completa (todos los módulos)

## 🚀 Importar en Postman

1. Abre Postman
2. Click en **Import** (esquina superior izquierda)
3. Arrastra el archivo `NutriTrack_Modulo1.postman_collection.json`
4. Click en **Import**

## 📋 Estructura de la Colección

```
NutriTrack API - Módulo 1/
├── 1. Autenticación/
│   ├── Login Admin
│   ├── Registrar Usuario
│   ├── Login Usuario
│   └── Eliminar Cuenta
│
├── 2. Gestión de Perfil/
│   ├── Obtener Mi Perfil
│   ├── Actualizar Mi Perfil
│   └── Actualizar Unidades de Medida
│
├── 3. Perfil de Salud/
│   ├── Configurar Perfil de Salud
│   └── Obtener Perfil de Salud
│
├── 4. Historial de Medidas/
│   ├── Registrar Medidas
│   ├── Obtener Historial de Medidas
│   └── Obtener Última Medida
│
└── 5. Health Check/
    └── Health Check
```

## 🔧 Variables de Colección

La colección usa variables automáticas que se configuran con scripts:

| Variable | Descripción | Valor Inicial |
|----------|-------------|---------------|
| `baseUrl` | URL base de la API | `http://localhost:8080` |
| `adminToken` | Token del usuario admin | _(se guarda automáticamente)_ |
| `userToken` | Token del usuario regular | _(se guarda automáticamente)_ |
| `userId` | ID del usuario autenticado | _(se guarda automáticamente)_ |

## 🎯 Flujo de Pruebas Recomendado

### 1️⃣ **Configuración Inicial**

```
1. Health Check → Verificar que el servidor está corriendo
2. Login Admin → Obtener token de administrador
```

### 2️⃣ **Flujo Usuario Nuevo**

```
1. Registrar Usuario → Crea cuenta y obtiene token
2. Obtener Mi Perfil → Ver perfil recién creado
3. Actualizar Mi Perfil → Modificar nombre/apellido
4. Actualizar Unidades de Medida → Elegir KG o LBS
5. Configurar Perfil de Salud → Establecer objetivo y nivel de actividad
6. Registrar Medidas → Primera entrada de peso/altura
7. Obtener Historial de Medidas → Verificar registro
```

### 3️⃣ **Flujo Usuario Existente**

```
1. Login Usuario → Obtener token
2. Obtener Mi Perfil → Ver datos completos
3. Obtener Última Medida → Ver progreso reciente
4. Registrar Medidas → Nueva entrada
```

### 4️⃣ **Pruebas Negativas**

```
1. Registrar Usuario (email duplicado) → Error 400
2. Login Usuario (password incorrecta) → Error 401
3. Eliminar Cuenta (sin confirmación) → Error 400
4. Actualizar Unidades (valor inválido) → Error 400
5. Registrar Medidas (fecha futura) → Error 400
```

## 🔑 Credenciales Iniciales

### Usuario Administrador (creado automáticamente)
```
Email: admin@nutritrack.com
Password: Admin123!
```

### Usuario de Prueba (crear con "Registrar Usuario")
```
Nombre: Carlos
Apellido: Martínez
Email: carlos.martinez@email.com
Password: MiPassword123!
```

## 🤖 Scripts Automáticos

Los siguientes requests tienen scripts que guardan tokens automáticamente:

- **Login Admin** → Guarda en `adminToken`
- **Registrar Usuario** → Guarda en `userToken`
- **Login Usuario** → Guarda en `userToken`
- **Eliminar Cuenta** → Limpia `userToken`

## 📊 Códigos de Respuesta HTTP

| Código | Significado | Cuándo aparece |
|--------|-------------|----------------|
| 200 | OK | Operación exitosa (GET, PUT, DELETE) |
| 201 | Created | Registro exitoso |
| 400 | Bad Request | Datos inválidos o regla de negocio violada |
| 401 | Unauthorized | Token inválido o credenciales incorrectas |
| 404 | Not Found | Recurso no encontrado |
| 500 | Server Error | Error interno del servidor |

## 🛡️ Reglas de Negocio Implementadas

| Código | Descripción |
|--------|-------------|
| RN01 | El email debe ser único en el sistema |
| RN02 | Validación de credenciales al login |
| RN03 | Solo se permiten unidades KG o LBS |
| RN04 | No se pueden registrar medidas en fechas futuras |
| RN05 | Eliminar cuenta requiere escribir "ELIMINAR" |

## 📝 Ejemplos de Uso

### Crear Usuario y Configurar Perfil Completo

1. **Registrar Usuario**
```json
POST /api/v1/auth/registro
{
  "nombre": "Carlos",
  "apellido": "Martínez",
  "email": "carlos.martinez@email.com",
  "password": "MiPassword123!"
}
```

2. **Configurar Salud**
```json
POST /api/v1/perfil/salud
{
  "objetivo": "PERDER_PESO",
  "nivelActividad": "MODERADO",
  "diasEntrenamiento": [1, 3, 5]
}
```

3. **Registrar Primera Medida**
```json
POST /api/v1/perfil/medidas
{
  "peso": 75.5,
  "altura": 175.0,
  "fecha": "2025-11-04"
}
```

### Seguimiento de Progreso

1. **Obtener Última Medida**
```
GET /api/v1/perfil/medidas/ultima
```

2. **Ver Historial Completo**
```
GET /api/v1/perfil/medidas
```

## 🔍 Verificación de Swagger

Puedes verificar todos los endpoints también en Swagger UI:

```
http://localhost:8080/swagger-ui.html
```

## 💡 Tips

1. **Orden de ejecución:** Los requests están ordenados en el flujo lógico de uso
2. **Variables:** No necesitas copiar/pegar tokens, se guardan automáticamente
3. **Autenticación:** La colección usa Bearer Token por defecto con `{{userToken}}`
4. **Ejemplos:** Cada request tiene valores de ejemplo listos para usar
5. **Descripciones:** Revisa la pestaña "Description" de cada request para más detalles

## 🐛 Troubleshooting

### Error: "Connection refused"
- Verifica que la aplicación esté corriendo en `localhost:8080`
- Ejecuta: `./mvnw spring-boot:run`

### Error: "Unauthorized"
- Ejecuta primero "Login Admin" o "Login Usuario"
- Verifica que el token se guardó en las variables

### Error: "Email ya existe"
- El email ya fue registrado
- Usa otro email o ejecuta "Login Usuario" en su lugar

### Error: "Confirmation required"
- Al eliminar cuenta, debes enviar `{"confirmacion": "ELIMINAR"}`

## 📚 Documentación Adicional

- [CREDENCIALES_ADMIN.md](../CREDENCIALES_ADMIN.md) - Información de usuario admin
- [docs/USER_STORIES.MD](../docs/USER_STORIES.MD) - Historias de usuario
- [docs/REGLAS_NEGOCIO.MD](../docs/REGLAS_NEGOCIO.MD) - Reglas de negocio completas
- [docs/TESTING_GUIDE.md](../docs/TESTING_GUIDE.md) - Guía de pruebas

## 📞 Soporte

Para dudas o problemas con la API:
1. Revisa los logs de la aplicación
2. Consulta el Swagger UI
3. Revisa la documentación en `/docs`

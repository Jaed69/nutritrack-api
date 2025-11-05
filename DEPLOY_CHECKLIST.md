# ✅ Checklist de Despliegue en Render

Usa esta lista para verificar cada paso del despliegue.

## 📦 Fase 1: Preparación Local
- [x] ✅ Código actualizado con documentación Swagger
- [x] ✅ Colecciones Postman con reglas de negocio
- [x] ✅ Archivos de configuración creados:
  - [x] `render.yaml`
  - [x] `application-production.properties`
  - [x] `build.sh` y `start.sh`
  - [x] `DEPLOY_RENDER.md`
  - [x] `.gitattributes`
- [x] ✅ Commits realizados
- [x] ✅ Push a GitHub completado

## 🌐 Fase 2: Configuración en Render

### A. Crear cuenta Render (si no tienes)
- [ ] Ir a https://render.com
- [ ] Sign up (usa GitHub para más fácil)
- [ ] Confirmar email

### B. Crear Base de Datos PostgreSQL
- [ ] Dashboard → **New +** → **PostgreSQL**
- [ ] Configurar:
  - [ ] Name: `nutritrack_db`
  - [ ] Database: `nutritrack_db`
  - [ ] Region: Oregon (US West) - FREE
  - [ ] Plan: **Free**
- [ ] **Create Database**
- [ ] Esperar hasta status **"Available"** (2-3 min)
- [ ] Copiar credenciales (botón **Info**)

### C. Cargar Scripts SQL
- [ ] Conectar con DBeaver/pgAdmin usando credenciales de arriba
- [ ] Ejecutar scripts EN ORDEN:
  - [ ] 1. `SQL/NutriDB.sql` (estructura)
  - [ ] 2. `SQL/catalogo_basico.sql` (datos base)
  - [ ] 3. `SQL/data_demo.sql` (usuarios demo)
  - [ ] 4. `SQL/modulo2_catalogo_demo.sql` (opcional)
  - [ ] 5. `SQL/modulo3_data_demo.sql` (opcional)
  - [ ] 6. `SQL/modulo4_asignaciones_demo.sql` (opcional)
  - [ ] 7. `SQL/modulo5_registros_demo.sql` (opcional)
- [ ] Verificar que tablas existen:
  ```sql
  SELECT table_name FROM information_schema.tables 
  WHERE table_schema = 'public';
  ```

### D. Crear Web Service (API)
- [ ] Dashboard → **New +** → **Web Service**
- [ ] Connect Repository:
  - [ ] Seleccionar `leonelalz/nutritrack-api`
  - [ ] Branch: `main`
- [ ] Configurar:
  - [ ] Name: `nutritrack-api`
  - [ ] Region: Oregon (US West) - mismo que DB
  - [ ] Runtime: **Java**
  - [ ] Build Command: `./mvnw clean package -DskipTests`
  - [ ] Start Command: `java -Dspring.profiles.active=production -Xmx512m -jar target/nutritrack-API-0.0.1-SNAPSHOT.jar`
- [ ] Advanced Settings:
  - [ ] Health Check Path: `/actuator/health`
  - [ ] Auto-Deploy: **Yes**
- [ ] **Create Web Service**

### E. Configurar Variables de Entorno
- [ ] En tu Web Service → **Environment** tab
- [ ] Agregar estas variables:

```bash
SPRING_PROFILES_ACTIVE=production
```

- [ ] Agregar `DATABASE_URL`:
  - [ ] Ir a `nutritrack_db` service
  - [ ] Copiar **Internal Database URL**
  - [ ] Pegar en variable `DATABASE_URL`

- [ ] Agregar `JWT_SECRET`:
  - [ ] Generar uno nuevo: `openssl rand -base64 32`
  - [ ] O usar: `4D6351655468576D5A7134743777217A25432A462D4A614E645267556B58703273357638792F423F4528482B4D6251655368566D597133743677397A24432646`

- [ ] Agregar `JAVA_TOOL_OPTIONS`:
```bash
-Xmx512m
```

- [ ] **Save Changes**
- [ ] Render redesplegará automáticamente (5-10 min)

## 🧪 Fase 3: Verificación

### A. Health Check
- [ ] Esperar a que el deploy termine (ver Logs tab)
- [ ] Copiar la URL pública (ej: `https://nutritrack-api.onrender.com`)
- [ ] Probar health check:
  ```bash
  curl https://TU-URL.onrender.com/actuator/health
  ```
- [ ] Respuesta esperada: `{"status":"UP"}`

### B. Swagger UI
- [ ] Abrir en navegador: `https://TU-URL.onrender.com/swagger-ui.html`
- [ ] Verificar que se carga la documentación
- [ ] Verificar que aparecen las reglas [RN##] en las descripciones

### C. Login de Prueba
- [ ] Probar login con usuario admin:
  ```bash
  curl -X POST https://TU-URL.onrender.com/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@nutritrack.com","password":"Admin123!"}'
  ```
- [ ] Respuesta esperada: `{"success":true,"data":{"token":"eyJ..."}}`

### D. Probar Endpoint Protegido
- [ ] Copiar el token del paso anterior
- [ ] Probar endpoint (ej: obtener perfil):
  ```bash
  curl https://TU-URL.onrender.com/api/v1/perfil/mi-perfil \
    -H "Authorization: Bearer TU_TOKEN"
  ```

## 📱 Fase 4: Actualizar Postman

- [ ] Importar colecciones `_con_RN` en Postman
- [ ] Actualizar variable `base_url` con tu URL de Render
- [ ] Ejecutar "Login Admin" para obtener token
- [ ] Probar algunos requests de ejemplo
- [ ] Verificar que pm.test() pasan correctamente

## 🔒 Fase 5: Seguridad Post-Despliegue

### A. Cambiar Password de Admin
- [ ] Generar nuevo password hash con BCrypt
- [ ] Actualizar en la base de datos:
  ```sql
  UPDATE cuentas_auth 
  SET password = '$2a$10$NUEVO_HASH' 
  WHERE email = 'admin@nutritrack.com';
  ```

### B. Cambiar JWT Secret
- [ ] Generar nuevo secret: `openssl rand -base64 32`
- [ ] Actualizar variable `JWT_SECRET` en Render
- [ ] Los tokens antiguos dejarán de funcionar (esperado)

### C. Configurar Monitoreo (Opcional)
- [ ] Crear cuenta en [UptimeRobot](https://uptimerobot.com/)
- [ ] Configurar monitor:
  - [ ] Type: HTTP(s)
  - [ ] URL: `https://TU-URL.onrender.com/actuator/health`
  - [ ] Interval: 5 minutes (14 min para evitar sleep)
  - [ ] Notification: Email

## 📊 Fase 6: Documentación

### Guardar URLs importantes:
- [ ] API Base URL: `https://________________.onrender.com`
- [ ] Swagger UI: `https://________________.onrender.com/swagger-ui.html`
- [ ] PostgreSQL Host: `________________.oregon-postgres.render.com`
- [ ] PostgreSQL Port: `5432`
- [ ] Database Name: `nutritrack_db`

### Compartir con el equipo:
- [ ] URL pública de Swagger
- [ ] Credenciales de admin (nuevas, seguras)
- [ ] Colecciones Postman actualizadas
- [ ] Esta checklist completada

## ✅ Resultado Final

Si todos los checkboxes están marcados:
- ✅ Base de datos PostgreSQL funcionando en Render
- ✅ API Spring Boot desplegada y accesible públicamente
- ✅ Swagger UI mostrando todas las reglas de negocio
- ✅ 27 reglas de negocio documentadas y funcionando
- ✅ 175 tests unitarios validando la lógica
- ✅ Colecciones Postman con demostraciones de cada regla
- ✅ Sistema completo listo para presentación

## 🎉 ¡Felicidades!

Tu NutriTrack API está completamente desplegada en producción.

**URLs útiles:**
- Dashboard Render: https://dashboard.render.com/
- Documentación Render: https://render.com/docs
- UptimeRobot: https://uptimerobot.com/

**Próximos pasos:**
- Monitorear logs en Render Dashboard
- Configurar alertas en UptimeRobot
- Compartir URL pública con usuarios/evaluadores
- Preparar demo para presentación

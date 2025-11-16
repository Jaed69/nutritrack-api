# 🐳 Docker Setup - NutriTrack API

## Configuración de Base de Datos con Docker

Este proyecto usa Docker Compose para ejecutar PostgreSQL en un contenedor, evitando conflictos con instalaciones locales.

### ⚙️ Configuración de Puertos

- **PostgreSQL Container:** Puerto interno `5432`
- **Puerto expuesto en host:** `5433` (para evitar conflicto con PostgreSQL local)
- **Spring Boot API:** Puerto `8080`

### 🚀 Comandos Rápidos

#### 1. Iniciar Base de Datos
```bash
docker-compose up -d
```

#### 2. Verificar que el contenedor está corriendo
```bash
docker ps
```

Deberías ver algo como:
```
CONTAINER ID   IMAGE                    STATUS         PORTS                    NAMES
xxxxx          postgres:16.10-alpine    Up 10 seconds  0.0.0.0:5433->5432/tcp   nutritrack-postgres
```

#### 3. Ver logs del contenedor
```bash
docker-compose logs -f postgres
```

#### 4. Iniciar la aplicación Spring Boot
```bash
# Windows (PowerShell)
.\mvnw.cmd spring-boot:run

# Linux/Mac
./mvnw spring-boot:run
```

#### 5. Detener la base de datos
```bash
docker-compose down
```

#### 6. Detener y eliminar datos (limpieza completa)
```bash
docker-compose down -v
```

### 🔧 Conexión a la Base de Datos

#### Desde la aplicación Spring Boot:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/nutritrack_db
spring.datasource.username=postgres
spring.datasource.password=root
```

#### Desde un cliente SQL (DBeaver, pgAdmin, etc.):
- **Host:** `localhost`
- **Puerto:** `5433`
- **Database:** `nutritrack_db`
- **Usuario:** `postgres`
- **Contraseña:** `root`

#### Desde línea de comandos (psql):
```bash
docker exec -it nutritrack-postgres psql -U postgres -d nutritrack_db
```

### 📊 Verificación de Datos

Una vez iniciado el contenedor, la base de datos se inicializa automáticamente con el script `SQL/NutriDB.sql`.

Para verificar:
```sql
-- Conectar al contenedor
docker exec -it nutritrack-postgres psql -U postgres -d nutritrack_db

-- Ver tablas
\dt

-- Contar usuarios
SELECT COUNT(*) FROM cuentas_auth;

-- Salir
\q
```

### ⚠️ Solución de Problemas

#### Error: "puerto 5433 ya está en uso"
Si el puerto 5433 también está ocupado, cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "5434:5432"  # Cambia 5433 por 5434
```

Y actualiza `application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5434/nutritrack_db
```

#### Error: "Cannot connect to database"
1. Verifica que el contenedor está corriendo:
   ```bash
   docker ps
   ```

2. Verifica los logs:
   ```bash
   docker-compose logs postgres
   ```

3. Espera a que el healthcheck pase:
   ```bash
   docker inspect nutritrack-postgres | grep -A 5 Health
   ```

#### Error: "Database does not exist"
El contenedor se inicializa con el script automáticamente. Si falla:
```bash
# Eliminar volumen y recrear
docker-compose down -v
docker-compose up -d
```

### 🔄 Reiniciar Base de Datos desde Cero

```bash
# 1. Detener y eliminar contenedor + volumen
docker-compose down -v

# 2. Iniciar de nuevo (ejecutará init.sql automáticamente)
docker-compose up -d

# 3. Esperar 10 segundos para que se inicialice
timeout /t 10

# 4. Iniciar Spring Boot
.\mvnw.cmd spring-boot:run
```

### 📦 Estructura de Volúmenes

- **postgres_data:** Persistencia de datos de PostgreSQL
- **./SQL/NutriDB.sql:** Script de inicialización (se ejecuta solo la primera vez)

### 🌐 URLs de la Aplicación

Una vez que todo esté corriendo:

- **API:** http://localhost:8080
- **Swagger UI:** http://localhost:8080/swagger-ui.html
- **Health Check:** http://localhost:8080/actuator/health (si está habilitado)

### 🔐 Credenciales de Usuarios Demo

#### Admin:
- **Email:** admin@nutritrack.com
- **Password:** Admin123!@#

#### Usuario Regular:
- **Email:** demo@nutritrack.com
- **Password:** Demo123!@#

### 💡 Tips

1. **Siempre inicia Docker antes de Spring Boot:**
   ```bash
   docker-compose up -d && sleep 10 && .\mvnw.cmd spring-boot:run
   ```

2. **Verifica conexión antes de iniciar:**
   ```bash
   docker exec nutritrack-postgres pg_isready -U postgres
   ```

3. **Backup de datos:**
   ```bash
   docker exec nutritrack-postgres pg_dump -U postgres nutritrack_db > backup.sql
   ```

4. **Restaurar backup:**
   ```bash
   docker exec -i nutritrack-postgres psql -U postgres -d nutritrack_db < backup.sql
   ```

---

**Última actualización:** 16 de Noviembre, 2025  
**Puerto PostgreSQL:** 5433 (host) → 5432 (container)  
**Puerto Spring Boot:** 8080

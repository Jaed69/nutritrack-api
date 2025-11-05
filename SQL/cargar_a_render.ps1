# ============================================================================
# Script PowerShell para cargar datos a PostgreSQL en Render
# ============================================================================
# Requisitos: psql instalado (viene con PostgreSQL)
# Verificar: psql --version
# ============================================================================

# CONFIGURACIÓN - Datos de Render
$RENDER_HOST = "dpg-d45po50dl3ps738jg31g-a.oregon-postgres.render.com"
$RENDER_DB = "nutritrack_db_0maz"
$RENDER_USER = "nutritrack_db_0maz_user"
$RENDER_PORT = "5432"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CARGA DE DATOS A RENDER - NUTRITRACK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que psql está instalado
Write-Host "🔍 Verificando instalación de psql..." -ForegroundColor Yellow
$psqlPath = Get-Command psql -ErrorAction SilentlyContinue

if (-not $psqlPath) {
    Write-Host "❌ ERROR: psql no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "Instala PostgreSQL desde: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    Write-Host "O instala solo psql: https://www.enterprisedb.com/download-postgresql-binaries" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ psql encontrado: $($psqlPath.Source)" -ForegroundColor Green
Write-Host ""

# Solicitar contraseña
Write-Host "🔑 Ingresa la contraseña de Render:" -ForegroundColor Yellow
$RENDER_PASSWORD = Read-Host -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RENDER_PASSWORD)
$RENDER_PASSWORD_PLAIN = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Construir string de conexión
$connectionString = "postgresql://${RENDER_USER}:${RENDER_PASSWORD_PLAIN}@${RENDER_HOST}:${RENDER_PORT}/${RENDER_DB}?sslmode=require"

Write-Host ""
Write-Host "🔗 Conectando a Render..." -ForegroundColor Yellow
Write-Host "   Host: $RENDER_HOST" -ForegroundColor Gray
Write-Host "   DB:   $RENDER_DB" -ForegroundColor Gray
Write-Host ""

# Test de conexión
Write-Host "🧪 Probando conexión..." -ForegroundColor Yellow
$testQuery = "SELECT version();"
$env:PGPASSWORD = $RENDER_PASSWORD_PLAIN
$testResult = psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -c $testQuery 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERROR: No se pudo conectar a Render" -ForegroundColor Red
    Write-Host $testResult -ForegroundColor Red
    exit 1
}

Write-Host "✅ Conexión exitosa" -ForegroundColor Green
Write-Host ""

# Confirmar antes de continuar
Write-Host "⚠️  ADVERTENCIA: Esta operación eliminará todos los datos existentes" -ForegroundColor Yellow
Write-Host "   y creará el schema desde cero." -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "¿Deseas continuar? (escribe 'SI' para confirmar)"

if ($confirm -ne "SI") {
    Write-Host "❌ Operación cancelada" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INICIANDO CARGA DE DATOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Crear schema (NutriDB.sql)
Write-Host "📦 [1/4] Creando schema de base de datos..." -ForegroundColor Yellow
$env:PGPASSWORD = $RENDER_PASSWORD_PLAIN
psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "NutriDB.sql"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERROR al crear schema" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Schema creado correctamente" -ForegroundColor Green
Write-Host ""

# Paso 2: Cargar catálogo básico
Write-Host "📚 [2/4] Cargando catálogo básico (ingredientes, comidas, ejercicios)..." -ForegroundColor Yellow
psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "catalogo_basico.sql"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERROR al cargar catálogo" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Catálogo cargado correctamente" -ForegroundColor Green
Write-Host ""

# Paso 3: Cargar datos demo
Write-Host "👥 [3/4] Cargando datos de demo (usuarios, planes, rutinas)..." -ForegroundColor Yellow
psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "data_demo.sql"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERROR al cargar datos demo" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Datos demo cargados correctamente" -ForegroundColor Green
Write-Host ""

# Paso 4: Cargar extensiones (opcional)
Write-Host "🔧 [4/4] Cargando extensiones de testing..." -ForegroundColor Yellow
if (Test-Path "data_demo_EXTENSIONS.sql") {
    psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "data_demo_EXTENSIONS.sql"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Advertencia: Error al cargar extensiones (opcional)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Extensiones cargadas correctamente" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  Archivo data_demo_EXTENSIONS.sql no encontrado (opcional)" -ForegroundColor Yellow
}
Write-Host ""

# Verificar carga
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VERIFICACIÓN DE DATOS CARGADOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$verifyQuery = @"
SELECT 'Usuarios' as tabla, COUNT(*) as registros FROM usuarios
UNION ALL
SELECT 'Ingredientes', COUNT(*) FROM ingredientes
UNION ALL
SELECT 'Ejercicios', COUNT(*) FROM ejercicios
UNION ALL
SELECT 'Comidas', COUNT(*) FROM comidas
UNION ALL
SELECT 'Planes', COUNT(*) FROM planes
UNION ALL
SELECT 'Rutinas', COUNT(*) FROM rutinas
UNION ALL
SELECT 'Etiquetas', COUNT(*) FROM etiquetas
UNION ALL
SELECT 'Usuarios-Planes', COUNT(*) FROM usuarios_planes
UNION ALL
SELECT 'Usuarios-Rutinas', COUNT(*) FROM usuarios_rutinas
UNION ALL
SELECT 'Mediciones', COUNT(*) FROM mediciones
ORDER BY tabla;
"@

psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -c $verifyQuery

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ CARGA COMPLETADA EXITOSAMENTE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Credenciales de prueba:" -ForegroundColor Yellow
Write-Host "  Admin: admin@nutritrack.com / admin123456" -ForegroundColor Cyan
Write-Host "  Demo:  demo@nutritrack.com / demo123456" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Verifica la API: https://tu-app.onrender.com/api/auth/login" -ForegroundColor Gray
Write-Host "  2. Prueba el endpoint de catálogo: GET /api/planes" -ForegroundColor Gray
Write-Host "  3. Revisa el archivo COBERTURA_TEST.md para casos de prueba" -ForegroundColor Gray
Write-Host ""

# Limpiar contraseña de memoria
$env:PGPASSWORD = $null

#!/bin/bash
# ============================================================================
# Script Bash para cargar datos a PostgreSQL en Render
# ============================================================================
# Requisitos: psql instalado
# Verificar: psql --version
# ============================================================================

# CONFIGURACIÓN - Reemplaza con tus datos de Render
RENDER_HOST="dpg-csmvfhij1k6c73asf620-a.oregon-postgres.render.com"
RENDER_DB="nutritrack_db"
RENDER_USER="nutritrack_db_user"
RENDER_PORT="5432"

echo "========================================"
echo "  CARGA DE DATOS A RENDER - NUTRITRACK"
echo "========================================"
echo ""

# Verificar que psql está instalado
echo "🔍 Verificando instalación de psql..."
if ! command -v psql &> /dev/null; then
    echo "❌ ERROR: psql no está instalado"
    echo ""
    echo "Instala PostgreSQL:"
    echo "  Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "  MacOS: brew install postgresql"
    echo "  Fedora/RHEL: sudo dnf install postgresql"
    exit 1
fi

echo "✅ psql encontrado: $(which psql)"
echo ""

# Solicitar contraseña
echo "🔑 Ingresa la contraseña de Render:"
read -s RENDER_PASSWORD
export PGPASSWORD=$RENDER_PASSWORD

echo ""
echo "🔗 Conectando a Render..."
echo "   Host: $RENDER_HOST"
echo "   DB:   $RENDER_DB"
echo ""

# Test de conexión
echo "🧪 Probando conexión..."
if ! psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -c "SELECT version();" &> /dev/null; then
    echo "❌ ERROR: No se pudo conectar a Render"
    echo "Verifica:"
    echo "  - Contraseña correcta"
    echo "  - Whitelist de IP en Render (https://render.com)"
    echo "  - Conexiones SSL habilitadas"
    exit 1
fi

echo "✅ Conexión exitosa"
echo ""

# Confirmar antes de continuar
echo "⚠️  ADVERTENCIA: Esta operación eliminará todos los datos existentes"
echo "   y creará el schema desde cero."
echo ""
read -p "¿Deseas continuar? (escribe 'SI' para confirmar): " confirm

if [ "$confirm" != "SI" ]; then
    echo "❌ Operación cancelada"
    exit 0
fi

echo ""
echo "========================================"
echo "  INICIANDO CARGA DE DATOS"
echo "========================================"
echo ""

# Paso 1: Crear schema (NutriDB.sql)
echo "📦 [1/4] Creando schema de base de datos..."
if ! psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "NutriDB.sql"; then
    echo "❌ ERROR al crear schema"
    exit 1
fi
echo "✅ Schema creado correctamente"
echo ""

# Paso 2: Cargar catálogo básico
echo "📚 [2/4] Cargando catálogo básico (ingredientes, comidas, ejercicios)..."
if ! psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "catalogo_basico.sql"; then
    echo "❌ ERROR al cargar catálogo"
    exit 1
fi
echo "✅ Catálogo cargado correctamente"
echo ""

# Paso 3: Cargar datos demo
echo "👥 [3/4] Cargando datos de demo (usuarios, planes, rutinas)..."
if ! psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "data_demo.sql"; then
    echo "❌ ERROR al cargar datos demo"
    exit 1
fi
echo "✅ Datos demo cargados correctamente"
echo ""

# Paso 4: Cargar extensiones (opcional)
echo "🔧 [4/4] Cargando extensiones de testing..."
if [ -f "data_demo_EXTENSIONS.sql" ]; then
    if ! psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -f "data_demo_EXTENSIONS.sql"; then
        echo "⚠️  Advertencia: Error al cargar extensiones (opcional)"
    else
        echo "✅ Extensiones cargadas correctamente"
    fi
else
    echo "⚠️  Archivo data_demo_EXTENSIONS.sql no encontrado (opcional)"
fi
echo ""

# Verificar carga
echo "========================================"
echo "  VERIFICACIÓN DE DATOS CARGADOS"
echo "========================================"
echo ""

psql -h $RENDER_HOST -p $RENDER_PORT -U $RENDER_USER -d $RENDER_DB -c "
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
"

echo ""
echo "========================================"
echo "  ✅ CARGA COMPLETADA EXITOSAMENTE"
echo "========================================"
echo ""
echo "Credenciales de prueba:"
echo "  Admin: admin@nutritrack.com / admin123456"
echo "  Demo:  demo@nutritrack.com / demo123456"
echo ""
echo "Próximos pasos:"
echo "  1. Verifica la API: https://tu-app.onrender.com/api/auth/login"
echo "  2. Prueba el endpoint de catálogo: GET /api/planes"
echo "  3. Revisa el archivo COBERTURA_TEST.md para casos de prueba"
echo ""

# Limpiar contraseña
unset PGPASSWORD

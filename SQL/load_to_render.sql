-- ============================================================================
-- CARGA COMPLETA DE DATOS A RENDER - NUTRITRACK
-- ============================================================================
-- Este archivo consolida todos los scripts en uno solo para carga rápida
-- Ejecutar con: psql -h HOST -U USER -d DB -f load_to_render.sql
-- ============================================================================

\echo '========================================'
\echo '  CARGA DE DATOS A RENDER - NUTRITRACK'
\echo '========================================'
\echo ''

-- Paso 1: Crear schema
\echo '📦 [1/4] Creando schema de base de datos...'
\i NutriDB.sql
\echo '✅ Schema creado correctamente'
\echo ''

-- Paso 2: Cargar catálogo básico
\echo '📚 [2/4] Cargando catálogo básico...'
\i catalogo_basico.sql
\echo '✅ Catálogo cargado correctamente'
\echo ''

-- Paso 3: Cargar datos demo
\echo '👥 [3/4] Cargando datos de demo...'
\i data_demo.sql
\echo '✅ Datos demo cargados correctamente'
\echo ''

-- Paso 4: Cargar extensiones
\echo '🔧 [4/4] Cargando extensiones de testing...'
\i data_demo_EXTENSIONS.sql
\echo '✅ Extensiones cargadas correctamente'
\echo ''

-- Verificación final
\echo '========================================'
\echo '  VERIFICACIÓN DE DATOS CARGADOS'
\echo '========================================'
\echo ''

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

\echo ''
\echo '========================================'
\echo '  ✅ CARGA COMPLETADA EXITOSAMENTE'
\echo '========================================'
\echo ''
\echo 'Credenciales de prueba:'
\echo '  Admin: admin@nutritrack.com / admin123456'
\echo '  Demo:  demo@nutritrack.com / demo123456'
\echo ''

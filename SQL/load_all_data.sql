-- ============================================================================
-- SCRIPT DE CARGA COMPLETA - NutriTrack Database
-- Ejecuta todos los scripts en el orden correcto
-- Compatible con PostgreSQL 16+
-- Fecha: November 5, 2025
-- ============================================================================

\echo '=========================================='
\echo 'NUTRITRACK DATABASE - CARGA COMPLETA'
\echo '=========================================='
\echo ''

-- ============================================================================
-- PASO 1: CREAR SCHEMA
-- ============================================================================
\echo '1. Creando schema de base de datos...'
\i NutriDB.sql
\echo '   ✓ Schema creado exitosamente'
\echo ''

-- ============================================================================
-- PASO 2: CARGAR CATÁLOGO BÁSICO
-- ============================================================================
\echo '2. Cargando catálogo básico (ingredientes, comidas, ejercicios)...'
\i catalogo_basico.sql
\echo '   ✓ Catálogo básico cargado'
\echo ''

-- ============================================================================
-- PASO 3: CARGAR DATOS DE DEMOSTRACIÓN
-- ============================================================================
\echo '3. Cargando datos de demostración (perfiles, planes, rutinas, registros)...'
\i data_demo.sql
\echo '   ✓ Datos demo cargados'
\echo ''

-- ============================================================================
-- RESUMEN FINAL
-- ============================================================================
\echo '=========================================='
\echo 'RESUMEN DE CARGA'
\echo '=========================================='

SELECT 
    '✓ BASE DE DATOS LISTA PARA USAR' as estado,
    (SELECT COUNT(*) FROM roles) as roles,
    (SELECT COUNT(*) FROM ingredientes) as ingredientes,
    (SELECT COUNT(*) FROM comidas) as comidas,
    (SELECT COUNT(*) FROM ejercicios) as ejercicios,
    (SELECT COUNT(*) FROM etiquetas) as etiquetas,
    (SELECT COUNT(*) FROM planes) as planes,
    (SELECT COUNT(*) FROM rutinas) as rutinas,
    (SELECT COUNT(*) FROM usuario_perfil_salud) as perfiles_con_datos;

\echo ''
\echo '=========================================='
\echo 'USUARIOS DE PRUEBA'
\echo '=========================================='
\echo 'Admin: admin@nutritrack.com / Admin123!'
\echo 'Demo:  demo@nutritrack.com / Demo123!'
\echo ''
\echo 'Nota: Los usuarios se crean automáticamente'
\echo 'al iniciar la aplicación Spring Boot.'
\echo '=========================================='
\echo ''
\echo '✓ Carga completa finalizada exitosamente'

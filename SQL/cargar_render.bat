@echo off
REM ============================================================================
REM Script para cargar datos a Render - Ejecuta en terminal externa
REM ============================================================================

set PGPASSWORD=72DJGUgyUMBZLmjQ0Vtk1AfiA8mE19LR
set HOST=dpg-d45po50dl3ps738jg31g-a.oregon-postgres.render.com
set PORT=5432
set USER=nutritrack_db_0maz_user
set DB=nutritrack_db_0maz

echo ========================================
echo   CARGA DE DATOS A RENDER - NUTRITRACK
echo ========================================
echo.
echo Conectando a: %HOST%
echo Database: %DB%
echo.
echo IMPORTANTE: Este proceso puede tardar 2-3 minutos
echo Por favor NO cierres esta ventana hasta que termine
echo.
pause

cd /d "%~dp0"

echo [1/4] Creando schema...
psql -h %HOST% -p %PORT% -U %USER% -d %DB% -f NutriDB.sql
if errorlevel 1 (
    echo ERROR al crear schema
    pause
    exit /b 1
)
echo OK - Schema creado
echo.

echo [2/4] Cargando catalogo basico...
psql -h %HOST% -p %PORT% -U %USER% -d %DB% -f catalogo_basico.sql
if errorlevel 1 (
    echo ERROR al cargar catalogo
    pause
    exit /b 1
)
echo OK - Catalogo cargado
echo.

echo [3/4] Cargando datos demo...
psql -h %HOST% -p %PORT% -U %USER% -d %DB% -f data_demo.sql
if errorlevel 1 (
    echo ERROR al cargar datos demo
    pause
    exit /b 1
)
echo OK - Datos demo cargados
echo.

echo [4/4] Cargando extensiones...
psql -h %HOST% -p %PORT% -U %USER% -d %DB% -f data_demo_EXTENSIONS.sql
if errorlevel 1 (
    echo ADVERTENCIA: Error al cargar extensiones
) else (
    echo OK - Extensiones cargadas
)
echo.

echo Verificando datos...
psql -h %HOST% -p %PORT% -U %USER% -d %DB% -c "SELECT 'Usuarios' as tabla, COUNT(*) as registros FROM usuarios UNION ALL SELECT 'Ingredientes', COUNT(*) FROM ingredientes UNION ALL SELECT 'Ejercicios', COUNT(*) FROM ejercicios UNION ALL SELECT 'Comidas', COUNT(*) FROM comidas UNION ALL SELECT 'Planes', COUNT(*) FROM planes UNION ALL SELECT 'Rutinas', COUNT(*) FROM rutinas ORDER BY tabla;"

echo.
echo ========================================
echo   PROCESO COMPLETADO
echo ========================================
echo.
pause

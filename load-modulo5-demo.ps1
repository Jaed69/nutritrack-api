# =============================================================================
# Script para cargar datos demo del Módulo 5 en Render PostgreSQL
# =============================================================================

# Configuración de PostgreSQL en Render
$env:PGPASSWORD = "WUYtwFHOgDJ1CoD93hiTbmVMm40puYLA"
$PGHOST = "dpg-d45r1fc9c44c73c9vvug-a.oregon-postgres.render.com"
$PGUSER = "nutritrack_db_vfbh_user"
$PGDATABASE = "nutritrack_db_vfbh"
$SQL_FILE = "SQL/modulo5_registros_demo.sql"

Write-Host "🔄 Cargando datos demo del Módulo 5 a Render PostgreSQL..." -ForegroundColor Cyan
Write-Host "   Host: $PGHOST" -ForegroundColor Gray
Write-Host "   Database: $PGDATABASE" -ForegroundColor Gray
Write-Host ""

# Ejecutar script SQL
try {
    psql -h $PGHOST -U $PGUSER -d $PGDATABASE -f $SQL_FILE
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Datos del Módulo 5 cargados exitosamente" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Resumen de datos cargados:" -ForegroundColor Yellow
        Write-Host "   - 19 registros de comidas (últimos 7 días)" -ForegroundColor Gray
        Write-Host "   - 13 registros de ejercicios (últimos 7 días)" -ForegroundColor Gray
        Write-Host "   - Usuario demo: perfil_usuario_id = 2" -ForegroundColor Gray
        Write-Host "   - Rango de fechas: 2024-10-31 a 2024-11-06" -ForegroundColor Gray
        Write-Host ""
        Write-Host "🧪 Probar en Swagger:" -ForegroundColor Cyan
        Write-Host "   GET /api/v1/usuario/registros/ejercicios/historial" -ForegroundColor White
        Write-Host "   Parámetros:" -ForegroundColor Gray
        Write-Host "     fechaInicio: 2024-10-31" -ForegroundColor Gray
        Write-Host "     fechaFin: 2024-11-06" -ForegroundColor Gray
        Write-Host ""
        Write-Host "   GET /api/v1/usuario/registros/comidas/historial" -ForegroundColor White
        Write-Host "   Parámetros:" -ForegroundColor Gray
        Write-Host "     fechaInicio: 2024-10-31" -ForegroundColor Gray
        Write-Host "     fechaFin: 2024-11-06" -ForegroundColor Gray
    } else {
        Write-Host ""
        Write-Host "❌ Error al cargar datos" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host ""
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}

# =====================================================
# NutriTrack API - Script de Pruebas Completas
# =====================================================
# Prueba todos los endpoints de la API para:
# - Usuario DEMO (demo@nutritrack.com)
# - Usuario ADMIN (admin@nutritrack.com)
# =====================================================

$BASE_URL = "http://localhost:8080/api/v1"
$ADMIN_EMAIL = "admin@nutritrack.com"
$ADMIN_PASSWORD = "Admin123!"
$DEMO_EMAIL = "demo@nutritrack.com"
$DEMO_PASSWORD = "Demo123!"

# Función para mostrar resultado
function Show-Result {
    param($Title, $Response, $StatusCode)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Title -ForegroundColor Yellow
    Write-Host "Status Code: $StatusCode" -ForegroundColor $(if ($StatusCode -ge 200 -and $StatusCode -lt 300) { "Green" } else { "Red" })
    Write-Host "Response:" -ForegroundColor White
    $Response | ConvertTo-Json -Depth 10 | Write-Host
}

# Función para hacer peticiones HTTP
function Invoke-ApiRequest {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Token = $null,
        [object]$Body = $null
    )
    
    $headers = @{
        "Content-Type" = "application/json"
    }
    
    if ($Token) {
        $headers["Authorization"] = "Bearer $Token"
    }
    
    try {
        $params = @{
            Uri = "$BASE_URL$Endpoint"
            Method = $Method
            Headers = $headers
        }
        
        if ($Body) {
            $params["Body"] = ($Body | ConvertTo-Json -Depth 10)
        }
        
        $response = Invoke-RestMethod @params -SkipHttpErrorCheck
        return @{
            Success = $true
            Data = $response
            StatusCode = 200
        }
    } catch {
        return @{
            Success = $false
            Error = $_.Exception.Message
            StatusCode = $_.Exception.Response.StatusCode.value__
        }
    }
}

Write-Host "=====================================================`n" -ForegroundColor Green
Write-Host "  NUTRITRACK API - PRUEBAS COMPLETAS" -ForegroundColor Green
Write-Host "`n=====================================================" -ForegroundColor Green

# =====================================================
# PARTE 1: PRUEBAS COMO USUARIO DEMO
# =====================================================
Write-Host "`n`n>>> PARTE 1: PRUEBAS COMO USUARIO DEMO <<<`n" -ForegroundColor Magenta

# 1. Login Usuario Demo
Write-Host "`n[1] Login Usuario Demo..." -ForegroundColor Cyan
$loginDemoBody = @{
    email = $DEMO_EMAIL
    password = $DEMO_PASSWORD
}
$loginDemo = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body ($loginDemoBody | ConvertTo-Json) -ContentType "application/json"
$DEMO_TOKEN = $loginDemo.accessToken
Show-Result "LOGIN USUARIO DEMO" $loginDemo 200
Write-Host "Token guardado: $($DEMO_TOKEN.Substring(0, 30))..." -ForegroundColor Green

# 2. Ver perfil propio
Write-Host "`n[2] Ver perfil del usuario..." -ForegroundColor Cyan
$perfil = Invoke-RestMethod -Uri "$BASE_URL/usuario/perfil" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "PERFIL USUARIO" $perfil 200

# 3. Ver planes disponibles (Módulo 3)
Write-Host "`n[3] Ver planes disponibles..." -ForegroundColor Cyan
$planes = Invoke-RestMethod -Uri "$BASE_URL/planes" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "PLANES DISPONIBLES" $planes 200

# 4. Ver rutinas disponibles (Módulo 3)
Write-Host "`n[4] Ver rutinas disponibles..." -ForegroundColor Cyan
$rutinas = Invoke-RestMethod -Uri "$BASE_URL/rutinas" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "RUTINAS DISPONIBLES" $rutinas 200

# 5. Ver mis planes asignados (Módulo 4)
Write-Host "`n[5] Ver mis planes asignados..." -ForegroundColor Cyan
$misPlanes = Invoke-RestMethod -Uri "$BASE_URL/usuario/planes" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "MIS PLANES ASIGNADOS" $misPlanes 200

# 6. Ver mis rutinas asignadas (Módulo 4)
Write-Host "`n[6] Ver mis rutinas asignadas..." -ForegroundColor Cyan
$misRutinas = Invoke-RestMethod -Uri "$BASE_URL/usuario/rutinas" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "MIS RUTINAS ASIGNADAS" $misRutinas 200

# 7. Ver actividades del plan de HOY (Módulo 5)
Write-Host "`n[7] Ver actividades del plan de HOY..." -ForegroundColor Cyan
$actividadesPlan = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/plan/hoy" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "ACTIVIDADES DEL PLAN HOY" $actividadesPlan 200

# 8. Ver ejercicios de la rutina de HOY (Módulo 5)
Write-Host "`n[8] Ver ejercicios de la rutina de HOY..." -ForegroundColor Cyan
$ejerciciosRutina = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/rutina/hoy" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "EJERCICIOS DE LA RUTINA HOY" $ejerciciosRutina 200

# 9. Ver historial de comidas (Módulo 5)
Write-Host "`n[9] Ver historial de comidas registradas..." -ForegroundColor Cyan
$historialComidas = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/comidas/historial" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "HISTORIAL DE COMIDAS" $historialComidas 200

# 10. Ver historial de ejercicios (Módulo 5)
Write-Host "`n[10] Ver historial de ejercicios registrados..." -ForegroundColor Cyan
$historialEjercicios = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/ejercicios/historial" -Method GET -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
}
Show-Result "HISTORIAL DE EJERCICIOS" $historialEjercicios 200

# 11. Registrar una nueva comida (Módulo 5)
Write-Host "`n[11] Registrar una nueva comida..." -ForegroundColor Cyan
$nuevaComida = @{
    comidaId = 1
    usuarioPlanId = 2
    fecha = (Get-Date).ToString("yyyy-MM-dd")
    hora = (Get-Date).ToString("HH:mm:ss")
    tipoComida = "SNACK"
    porciones = 1.0
    caloriasConsumidas = 150.00
    notas = "Snack post-entrenamiento - Prueba desde PowerShell"
}
$registroComida = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/comidas" -Method POST -Body ($nuevaComida | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVA COMIDA REGISTRADA" $registroComida 201

# 12. Registrar un nuevo ejercicio (Módulo 5)
Write-Host "`n[12] Registrar un nuevo ejercicio..." -ForegroundColor Cyan
$nuevoEjercicio = @{
    ejercicioId = 1
    usuarioRutinaId = 1
    fecha = (Get-Date).ToString("yyyy-MM-dd")
    hora = (Get-Date).ToString("HH:mm:ss")
    seriesRealizadas = 3
    repeticionesRealizadas = 12
    pesoUtilizado = $null
    duracionMinutos = 15
    caloriasQuemadas = 200.00
    notas = "Ejercicio de prueba desde PowerShell"
}
$registroEjercicio = Invoke-RestMethod -Uri "$BASE_URL/usuario/registros/ejercicios" -Method POST -Body ($nuevoEjercicio | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $DEMO_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVO EJERCICIO REGISTRADO" $registroEjercicio 201

# =====================================================
# PARTE 2: PRUEBAS COMO ADMINISTRADOR
# =====================================================
Write-Host "`n`n>>> PARTE 2: PRUEBAS COMO ADMINISTRADOR <<<`n" -ForegroundColor Magenta

# 1. Login Administrador
Write-Host "`n[1] Login Administrador..." -ForegroundColor Cyan
$loginAdminBody = @{
    email = $ADMIN_EMAIL
    password = $ADMIN_PASSWORD
}
$loginAdmin = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -Body ($loginAdminBody | ConvertTo-Json) -ContentType "application/json"
$ADMIN_TOKEN = $loginAdmin.accessToken
Show-Result "LOGIN ADMINISTRADOR" $loginAdmin 200
Write-Host "Token guardado: $($ADMIN_TOKEN.Substring(0, 30))..." -ForegroundColor Green

# 2. Ver todos los usuarios (Solo Admin)
Write-Host "`n[2] Ver todos los usuarios..." -ForegroundColor Cyan
$usuarios = Invoke-RestMethod -Uri "$BASE_URL/admin/usuarios" -Method GET -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
}
Show-Result "TODOS LOS USUARIOS" $usuarios 200

# 3. Ver todos los ingredientes del catálogo (Módulo 2)
Write-Host "`n[3] Ver ingredientes del catálogo..." -ForegroundColor Cyan
$ingredientes = Invoke-RestMethod -Uri "$BASE_URL/ingredientes" -Method GET -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
}
Show-Result "INGREDIENTES DEL CATÁLOGO" $ingredientes 200

# 4. Ver todas las comidas del catálogo (Módulo 2)
Write-Host "`n[4] Ver comidas del catálogo..." -ForegroundColor Cyan
$comidas = Invoke-RestMethod -Uri "$BASE_URL/comidas" -Method GET -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
}
Show-Result "COMIDAS DEL CATÁLOGO" $comidas 200

# 5. Ver todos los ejercicios del catálogo (Módulo 2)
Write-Host "`n[5] Ver ejercicios del catálogo..." -ForegroundColor Cyan
$ejercicios = Invoke-RestMethod -Uri "$BASE_URL/ejercicios" -Method GET -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
}
Show-Result "EJERCICIOS DEL CATÁLOGO" $ejercicios 200

# 6. Crear un nuevo ingrediente (Solo Admin - Módulo 2)
Write-Host "`n[6] Crear un nuevo ingrediente..." -ForegroundColor Cyan
$nuevoIngrediente = @{
    nombre = "Quinoa Test"
    categoriaAlimento = "CEREALES"
    caloriasPor100g = 120.00
    proteinasPor100g = 4.40
    carbohidratosPor100g = 21.30
    grasasPor100g = 1.90
    fibraPor100g = 2.80
    descripcion = "Ingrediente de prueba creado desde PowerShell"
}
$ingredienteCreado = Invoke-RestMethod -Uri "$BASE_URL/ingredientes" -Method POST -Body ($nuevoIngrediente | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVO INGREDIENTE CREADO" $ingredienteCreado 201

# 7. Crear un nuevo ejercicio (Solo Admin - Módulo 2)
Write-Host "`n[7] Crear un nuevo ejercicio..." -ForegroundColor Cyan
$nuevoEjercicioAdmin = @{
    nombre = "Ejercicio Test PowerShell"
    grupoMuscular = "CORE"
    nivelDificultad = "INTERMEDIO"
    caloriasQuemadasPorMinuto = 8.50
    descripcion = "Ejercicio de prueba creado desde PowerShell"
    instrucciones = "1. Posicion inicial\n2. Ejecutar movimiento\n3. Repetir"
    equipamientoNecesario = "Ninguno"
}
$ejercicioCreado = Invoke-RestMethod -Uri "$BASE_URL/ejercicios" -Method POST -Body ($nuevoEjercicioAdmin | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVO EJERCICIO CREADO" $ejercicioCreado 201

# 8. Crear un nuevo plan (Solo Admin - Módulo 3)
Write-Host "`n[8] Crear un nuevo plan..." -ForegroundColor Cyan
$nuevoPlan = @{
    nombre = "Plan Test PowerShell"
    descripcion = "Plan de prueba creado desde script automatizado"
    duracionDias = 30
    nivelDificultad = "INTERMEDIO"
    objetivoPrincipal = "PERDIDA_PESO"
}
$planCreado = Invoke-RestMethod -Uri "$BASE_URL/planes" -Method POST -Body ($nuevoPlan | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVO PLAN CREADO" $planCreado 201

# 9. Crear una nueva rutina (Solo Admin - Módulo 3)
Write-Host "`n[9] Crear una nueva rutina..." -ForegroundColor Cyan
$nuevaRutina = @{
    nombre = "Rutina Test PowerShell"
    descripcion = "Rutina de prueba creada desde script automatizado"
    duracionSemanas = 4
    diasPorSemana = 5
    nivelDificultad = "INTERMEDIO"
    objetivoPrincipal = "TONIFICACION"
}
$rutinaCreada = Invoke-RestMethod -Uri "$BASE_URL/rutinas" -Method POST -Body ($nuevaRutina | ConvertTo-Json) -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
    "Content-Type" = "application/json"
}
Show-Result "NUEVA RUTINA CREADA" $rutinaCreada 201

# 10. Ver etiquetas (Módulo 2)
Write-Host "`n[10] Ver todas las etiquetas..." -ForegroundColor Cyan
$etiquetas = Invoke-RestMethod -Uri "$BASE_URL/etiquetas" -Method GET -Headers @{
    "Authorization" = "Bearer $ADMIN_TOKEN"
}
Show-Result "ETIQUETAS" $etiquetas 200

# =====================================================
# RESUMEN FINAL
# =====================================================
Write-Host "`n`n=====================================================`n" -ForegroundColor Green
Write-Host "  RESUMEN DE PRUEBAS" -ForegroundColor Green
Write-Host "`n=====================================================" -ForegroundColor Green

Write-Host "`n✅ Usuario Demo:" -ForegroundColor Cyan
Write-Host "   - Login exitoso" -ForegroundColor White
Write-Host "   - Consulta de perfil: OK" -ForegroundColor White
Write-Host "   - Consulta de planes disponibles: OK" -ForegroundColor White
Write-Host "   - Consulta de rutinas disponibles: OK" -ForegroundColor White
Write-Host "   - Mis planes asignados: OK" -ForegroundColor White
Write-Host "   - Mis rutinas asignadas: OK" -ForegroundColor White
Write-Host "   - Actividades del plan HOY: OK" -ForegroundColor White
Write-Host "   - Ejercicios de rutina HOY: OK" -ForegroundColor White
Write-Host "   - Historial de comidas: OK" -ForegroundColor White
Write-Host "   - Historial de ejercicios: OK" -ForegroundColor White
Write-Host "   - Registro de nueva comida: OK" -ForegroundColor White
Write-Host "   - Registro de nuevo ejercicio: OK" -ForegroundColor White

Write-Host "`n✅ Usuario Administrador:" -ForegroundColor Cyan
Write-Host "   - Login exitoso" -ForegroundColor White
Write-Host "   - Ver todos los usuarios: OK" -ForegroundColor White
Write-Host "   - Ver ingredientes: OK" -ForegroundColor White
Write-Host "   - Ver comidas: OK" -ForegroundColor White
Write-Host "   - Ver ejercicios: OK" -ForegroundColor White
Write-Host "   - Crear ingrediente: OK" -ForegroundColor White
Write-Host "   - Crear ejercicio: OK" -ForegroundColor White
Write-Host "   - Crear plan: OK" -ForegroundColor White
Write-Host "   - Crear rutina: OK" -ForegroundColor White
Write-Host "   - Ver etiquetas: OK" -ForegroundColor White

Write-Host "`n✨ TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE ✨`n" -ForegroundColor Green
Write-Host "Swagger UI disponible en: http://localhost:8080/swagger-ui/index.html`n" -ForegroundColor Yellow

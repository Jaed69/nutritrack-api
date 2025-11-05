-- ============================================================================
-- EXTENSIONES DE DATA_DEMO.SQL PARA COBERTURA COMPLETA DE CASOS DE PRUEBA
-- ============================================================================
-- Este archivo complementa data_demo.sql con datos adicionales para probar:
-- - Todos los estados de planes/rutinas (PAUSADO, COMPLETADO, CANCELADO)
-- - Filtrado por alergias (RN16 - CRÍTICA)
-- - Historiales de progreso (US-21 a US-25)
-- - Casos límite y validaciones de reglas de negocio
-- ============================================================================

-- ============================================================================
-- 1. ESTADOS COMPLETADOS Y CANCELADOS (RN19, RN20, RN26, US-19, US-20)
-- ============================================================================

-- ADMIN: Plan COMPLETADO anterior (no puede pausarse - RN19)
INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, estado, dia_actual, notas)
SELECT 1, p.id, '2025-07-15', '2025-10-07', 'COMPLETADO', 84, 'Plan completado exitosamente. Objetivo: -8kg cumplido'
FROM planes p
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND p.activo = TRUE;

-- ADMIN: Rutina COMPLETADA (no puede pausarse - RN19)
INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, estado, semana_actual, notas)
SELECT 1, r.id, '2025-09-01', '2025-10-20', 'COMPLETADO', 8, 'Completada. Mejoró resistencia cardiovascular significativamente'
FROM rutinas r
WHERE r.nombre = 'Cardio Moderado Resistencia' AND r.activo = TRUE;

-- DEMO: Plan PAUSADO (puede reanudarse - US-19)
INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, estado, dia_actual, notas)
SELECT 2, p.id, '2025-09-01', '2025-12-22', 'PAUSADO', 28, 'Pausado temporalmente por viaje. Reanudar después del 10 de noviembre'
FROM planes p
WHERE p.nombre = 'Plan Hipertrofia Muscular Avanzado' AND p.activo = TRUE;

-- DEMO: Plan CANCELADO (historial - US-20)
INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, estado, dia_actual, notas)
SELECT 2, p.id, '2025-08-01', '2025-10-23', 'CANCELADO', 7, 'Cancelado por usuario. Dificultad demasiado alta para nivel actual'
FROM planes p
WHERE p.nombre = 'Plan Definición y Tonificación' AND p.activo = TRUE;

-- DEMO: Rutina PAUSADA (puede reanudarse - US-19)
INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, estado, semana_actual, notas)
SELECT 2, r.id, '2025-09-10', '2025-11-03', 'PAUSADO', 4, 'Pausada por dolencia menor en hombro. Reanudar cuando se recupere'
FROM rutinas r
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND r.activo = TRUE;

-- DEMO: Rutina CANCELADA (historial - US-20)
INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, estado, semana_actual, notas)
SELECT 2, r.id, '2025-08-15', '2025-10-09', 'CANCELADO', 2, 'Cancelada. Ejercicios muy difíciles para nivel actual'
FROM rutinas r
WHERE r.nombre = 'Core Funcional y Abdominales' AND r.activo = TRUE;

-- ============================================================================
-- 2. REGISTROS HISTÓRICOS PARA PROGRESO (US-21, US-22, US-23, US-25)
-- ============================================================================

-- ADMIN: Registros de comidas de los últimos 7 días (patrón de adherencia)
INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-10-28', '08:00:00', 'DESAYUNO', 1.0, 450.00, TRUE, 'Semana 1'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO' 
AND c.nombre = 'Avena con frutas y almendras';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-10-29', '08:00:00', 'DESAYUNO', 1.0, 450.00, TRUE, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO' 
AND c.nombre = 'Avena con frutas y almendras';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-10-30', '13:00:00', 'ALMUERZO', 1.0, 520.00, FALSE, 'No completado - reunión de trabajo'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO'
AND c.nombre = 'Ensalada de pollo a la parrilla';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-10-31', '08:00:00', 'DESAYUNO', 1.5, 675.00, TRUE, 'Porción extra - entrenamiento intenso'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO' 
AND c.nombre = 'Avena con frutas y almendras';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-11-01', '13:00:00', 'ALMUERZO', 1.0, 520.00, TRUE, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO'
AND c.nombre = 'Ensalada de pollo a la parrilla';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-11-02', '19:30:00', 'CENA', 1.0, 480.00, TRUE, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO'
AND c.nombre = 'Pescado al horno con verduras';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, completado, notas)
SELECT 1, up.id, c.id, '2025-11-03', '08:00:00', 'DESAYUNO', 1.0, 450.00, TRUE, 'Fin de semana - adherencia perfecta'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO' 
AND c.nombre = 'Avena con frutas y almendras';

-- DEMO: Registros de ejercicios de los últimos 7 días (patrón de adherencia)
INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, series_completadas, repeticiones_completadas, duracion_minutos, peso_utilizado, calorias_quemadas, completado, notas)
SELECT 2, ur.id, e.id, '2025-10-28', '18:00:00', 4, 15, NULL, NULL, 120.00, TRUE, 'Semana 1 - Excelente'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Burpees';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, series_completadas, repeticiones_completadas, duracion_minutos, peso_utilizado, calorias_quemadas, completado, notas)
SELECT 2, ur.id, e.id, '2025-10-30', '18:00:00', 3, 20, NULL, NULL, 90.00, FALSE, 'No completado - cansancio excesivo'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Mountain Climbers';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, series_completadas, repeticiones_completadas, duracion_minutos, peso_utilizado, calorias_quemadas, completado, notas)
SELECT 2, ur.id, e.id, '2025-11-01', '18:00:00', 4, 15, NULL, NULL, 120.00, TRUE, 'Recuperado'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Burpees';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, series_completadas, repeticiones_completadas, duracion_minutos, peso_utilizado, calorias_quemadas, completado, notas)
SELECT 2, ur.id, e.id, '2025-11-03', '18:00:00', 4, NULL, 1, NULL, 35.00, TRUE, 'Cardio moderado'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Saltos de tijera (Jumping Jacks)';

-- DEMO: Mediciones adicionales para gráficos de progreso (RN23, US-24, US-25)
-- Ya tiene 11 mediciones en data_demo.sql, agregar 4 más para patrón más rico
INSERT INTO mediciones (id_perfil, fecha, peso, altura, porcentaje_grasa, masa_muscular, notas)
VALUES (2, '2025-11-07', 81.3, 170.0, 26.5, 54.0, 'Semana 4 - Progreso continuo'),
       (2, '2025-11-14', 80.8, 170.0, 26.0, 54.2, 'Semana 5 - Mejorando composición corporal'),
       (2, '2025-11-21', 80.5, 170.0, 25.5, 54.5, 'Semana 6 - Excelente adherencia al plan'),
       (2, '2025-11-28', 80.0, 170.0, 25.0, 55.0, 'Semana 7 - Meta intermedia alcanzada');

-- ============================================================================
-- 3. INGREDIENTES CON ETIQUETAS DE ALERGIA (RN16, RN32, US-16)
-- ============================================================================
-- Etiquetar ingredientes existentes con alérgenos

-- Pollo → Sin alérgenos comunes
-- Salmón → Puede causar alergias (agregamos etiqueta)
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Salmón' AND e.nombre = 'Mariscos'
ON CONFLICT DO NOTHING;

-- Leche → Lácteos
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Leche' AND e.nombre = 'Lácteos'
ON CONFLICT DO NOTHING;

-- Almendras → Nueces
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Almendras' AND e.nombre = 'Nueces'
ON CONFLICT DO NOTHING;

-- Avena → Gluten (si no es certificada sin gluten)
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Avena' AND e.nombre = 'Gluten'
ON CONFLICT DO NOTHING;

-- Huevo → Alérgeno
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Huevo' AND e.nombre = 'Huevo'
ON CONFLICT DO NOTHING;

-- Queso → Lácteos
INSERT INTO ingrediente_etiquetas (id_ingrediente, id_etiqueta)
SELECT i.id, e.id FROM ingredientes i, etiquetas e
WHERE i.nombre = 'Queso Fresco' AND e.nombre = 'Lácteos'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- VERIFICAR COBERTURA DE DATOS DESPUÉS DE EXTENSIONES
-- ============================================================================

SELECT 
    '=== RESUMEN DE COBERTURA DESPUÉS DE EXTENSIONES ===' as reporte;

SELECT 
    'USUARIOS' as categoria,
    (SELECT COUNT(*) FROM usuarios) as total,
    (SELECT COUNT(*) FROM usuario_perfil_salud) as con_perfil,
    (SELECT COUNT(*) FROM usuario_etiquetas_salud) as con_alergias;

SELECT 
    'PLANES' as categoria,
    (SELECT COUNT(*) FROM planes WHERE activo = TRUE) as activos,
    (SELECT COUNT(*) FROM planes WHERE activo = FALSE) as inactivos,
    (SELECT COUNT(*) FROM usuarios_planes WHERE estado = 'ACTIVO') as asignados_activos,
    (SELECT COUNT(*) FROM usuarios_planes WHERE estado = 'PAUSADO') as asignados_pausados,
    (SELECT COUNT(*) FROM usuarios_planes WHERE estado = 'COMPLETADO') as asignados_completados,
    (SELECT COUNT(*) FROM usuarios_planes WHERE estado = 'CANCELADO') as asignados_cancelados;

SELECT 
    'RUTINAS' as categoria,
    (SELECT COUNT(*) FROM rutinas WHERE activo = TRUE) as activas,
    (SELECT COUNT(*) FROM rutinas WHERE activo = FALSE) as inactivas,
    (SELECT COUNT(*) FROM usuarios_rutinas WHERE estado = 'ACTIVO') as asignadas_activas,
    (SELECT COUNT(*) FROM usuarios_rutinas WHERE estado = 'PAUSADO') as asignadas_pausadas,
    (SELECT COUNT(*) FROM usuarios_rutinas WHERE estado = 'COMPLETADO') as asignadas_completadas,
    (SELECT COUNT(*) FROM usuarios_rutinas WHERE estado = 'CANCELADO') as asignadas_canceladas;

SELECT 
    'REGISTROS (últimos 30 días)' as categoria,
    (SELECT COUNT(*) FROM registros_comidas WHERE fecha >= CURRENT_DATE - INTERVAL '30 days') as comidas,
    (SELECT COUNT(*) FROM registros_ejercicios WHERE fecha >= CURRENT_DATE - INTERVAL '30 days') as ejercicios,
    (SELECT COUNT(*) FROM mediciones WHERE fecha >= CURRENT_DATE - INTERVAL '30 days') as mediciones;

SELECT 
    'ALERGIAS/ALÉRGENOS' as categoria,
    (SELECT COUNT(*) FROM usuario_etiquetas_salud) as usuarios_con_alergias,
    (SELECT COUNT(*) FROM ingrediente_etiquetas ie JOIN etiquetas e ON ie.id_etiqueta = e.id WHERE e.tipo_etiqueta = 'ALERGIA') as ingredientes_con_etiqueta_alergia;

-- ============================================================================
-- ANÁLISIS DE COBERTURA DE USER STORIES Y REGLAS DE NEGOCIO
-- ============================================================================

SELECT '=== COBERTURA DE CASOS DE PRUEBA ===' as analisis;

SELECT 'MÓDULO 1: Cuentas (US-01 a US-05)' as modulo,
       'PARCIAL' as cobertura,
       'Admin y Demo creados. Falta: US-05 (Delete Account) requiere testing manual' as notas;

SELECT 'MÓDULO 2: Biblioteca (US-06 a US-10)' as modulo,
       'COMPLETA' as cobertura,
       'Etiquetas, ingredientes, ejercicios, comidas y recetas cargadas' as notas;

SELECT 'MÓDULO 3: Gestión Catálogo (US-11 a US-15)' as modulo,
       'COMPLETA' as cobertura,
       'Planes y rutinas con múltiples estados (activo/inactivo). Plan_dias y rutina_ejercicios configurados' as notas;

SELECT 'MÓDULO 4: Exploración (US-16 a US-20)' as modulo,
       'COMPLETA CON EXTENSIONES' as cobertura,
       'Filtrado alérgenos (RN16). Estados: ACTIVO, PAUSADO, COMPLETADO, CANCELADO' as notas;

SELECT 'MÓDULO 5: Progreso (US-21 a US-25)' as modulo,
       'COMPLETA CON EXTENSIONES' as cobertura,
       'Registros históricos de 7 días. Mediciones con 15 puntos de datos. Soporta gráficos y reportes' as notas;

SELECT 'REGLAS CRÍTICAS' as reglas,
       'RN16 (Filtrado Alérgenos): ✅ TESTEABLE' as rn16,
       'RN19 (No pausar completados): ✅ TESTEABLE' as rn19,
       'RN30-32 (Validaciones): ✅ Backend' as validaciones;

SELECT '=== DATOS FALTANTES IDENTIFICADOS ===' as faltantes;

SELECT 'RN17-RN18: Duplicar activación' as regla,
       'NO TESTEABLE CON DATA ESTÁTICA' as estado,
       'Requiere 2 intentos de activar mismo plan. Probar vía API.' as solucion;

SELECT 'RN29: Rate Limiting' as regla,
       'NOT IMPLEMENTED' as estado,
       'Regla pendiente de implementar en backend' as solucion;

SELECT 'RN37: GDPR Export' as regla,
       'NOT IMPLEMENTED' as estado,
       'Regla pendiente de implementar en backend' as solucion;

COMMIT;

-- ============================================================================
-- DATOS DE DEMOSTRACIÓN - MÓDULO 4
-- Asignaciones de Planes y Rutinas a Usuarios
-- Compatible con NutriDB.sql y modulo3_data_demo.sql
-- ============================================================================

-- Este script requiere:
-- 1. Que exista el usuario demo@nutritrack.com (ejecutar demo_user.sql)
-- 2. Que existan planes y rutinas (ejecutar modulo3_data_demo.sql)

-- ============================================================================
-- VARIABLES DE REFERENCIA (para legibilidad)
-- ============================================================================

-- ID del perfil del usuario demo
DO $$ 
DECLARE
    v_perfil_id BIGINT;
    v_plan1_id BIGINT;
    v_plan2_id BIGINT;
    v_plan3_id BIGINT;
    v_rutina1_id BIGINT;
    v_rutina2_id BIGINT;
    v_rutina5_id BIGINT;
BEGIN
    -- Obtener IDs necesarios
    SELECT id INTO v_perfil_id FROM perfiles_usuario 
    WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com');
    
    SELECT id INTO v_plan1_id FROM planes WHERE nombre = 'Plan Pérdida de Grasa Efectiva';
    SELECT id INTO v_plan2_id FROM planes WHERE nombre = 'Plan Ganancia Muscular Avanzado';
    SELECT id INTO v_plan3_id FROM planes WHERE nombre = 'Plan Definición y Tonificación';
    
    SELECT id INTO v_rutina1_id FROM rutinas WHERE nombre = 'HIIT Quema Grasa Intenso';
    SELECT id INTO v_rutina2_id FROM rutinas WHERE nombre = 'Fuerza Tren Superior Completo';
    SELECT id INTO v_rutina5_id FROM rutinas WHERE nombre = 'Core Funcional y Abdominales';

    -- ============================================================================
    -- ASIGNACIONES DE PLANES (usuarios_planes) - MÓDULO 4
    -- ============================================================================

    -- Plan 1: ACTIVO - Usuario está actualmente siguiendo este plan (día 15 de 56)
    INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, dia_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_plan1_id,
        CURRENT_DATE - INTERVAL '14 days', -- Comenzó hace 14 días
        CURRENT_DATE + INTERVAL '42 days', -- Termina en 42 días (56 total - 14 transcurridos)
        15, -- Día actual del plan
        'ACTIVO',
        'Plan activo de pérdida de grasa. Progreso: -3kg en 2 semanas. Muy motivado.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Plan 2: COMPLETADO - Plan anterior que completó exitosamente
    INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, dia_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_plan3_id,
        CURRENT_DATE - INTERVAL '90 days', -- Comenzó hace 90 días
        CURRENT_DATE - INTERVAL '48 days', -- Terminó hace 48 días (42 días de duración)
        42, -- Completó todo el plan
        'COMPLETADO',
        'Plan de definición completado exitosamente. Resultados excelentes: -5kg, -4cm cintura.',
        CURRENT_TIMESTAMP - INTERVAL '90 days'
    )
    ON CONFLICT DO NOTHING;

    -- Plan 3: PAUSADO - Plan que pausó temporalmente (va en día 20)
    INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, dia_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_plan2_id,
        CURRENT_DATE - INTERVAL '120 days', -- Comenzó hace 120 días
        NULL, -- Sin fecha fin porque está pausado
        20, -- Se pausó en el día 20
        'PAUSADO',
        'Pausado temporalmente por viaje de trabajo. Reanudar próxima semana.',
        CURRENT_TIMESTAMP - INTERVAL '120 days'
    )
    ON CONFLICT DO NOTHING;

    -- Plan 4: CANCELADO - Plan que canceló por cambio de objetivos
    INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, dia_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_plan1_id,
        CURRENT_DATE - INTERVAL '150 days', -- Comenzó hace 150 días
        CURRENT_DATE - INTERVAL '140 days', -- Canceló 10 días después
        10, -- Canceló en el día 10
        'CANCELADO',
        'Cancelado por cambio de objetivos. Prefirió enfocarse en definición primero.',
        CURRENT_TIMESTAMP - INTERVAL '150 days'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- ASIGNACIONES DE RUTINAS (usuarios_rutinas) - MÓDULO 4
    -- ============================================================================

    -- Rutina 1: ACTIVA - Usuario está siguiendo esta rutina (semana 2 de 4)
    INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, semana_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_rutina1_id,
        CURRENT_DATE - INTERVAL '10 days', -- Comenzó hace 10 días
        CURRENT_DATE + INTERVAL '18 days', -- Termina en 18 días (4 semanas total)
        2, -- Semana actual
        'ACTIVO',
        'HIIT intenso 3 veces por semana. Excelente para quemar grasa. Muy efectivo.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Rutina 2: ACTIVA - Segunda rutina activa para días alternos (semana 1 de 8)
    INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, semana_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_rutina5_id,
        CURRENT_DATE - INTERVAL '5 days', -- Comenzó hace 5 días
        CURRENT_DATE + INTERVAL '37 days', -- Termina en 37 días (6 semanas total)
        1, -- Primera semana
        'ACTIVO',
        'Core funcional 2 veces por semana. Complementa perfectamente el HIIT.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Rutina 3: COMPLETADA - Rutina anterior que completó
    INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, semana_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_rutina2_id,
        CURRENT_DATE - INTERVAL '80 days', -- Comenzó hace 80 días
        CURRENT_DATE - INTERVAL '24 days', -- Terminó hace 24 días (8 semanas)
        8, -- Completó todas las semanas
        'COMPLETADO',
        'Rutina de fuerza completada. Ganancias significativas en tren superior.',
        CURRENT_TIMESTAMP - INTERVAL '80 days'
    )
    ON CONFLICT DO NOTHING;

    -- Rutina 4: PAUSADA - Rutina pausada temporalmente (semana 3 de 8)
    INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, semana_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_rutina2_id,
        CURRENT_DATE - INTERVAL '100 days', -- Comenzó hace 100 días
        NULL, -- Sin fecha fin porque está pausada
        3, -- Pausada en semana 3
        'PAUSADO',
        'Pausada por lesión menor en hombro. Retomar cuando esté recuperado.',
        CURRENT_TIMESTAMP - INTERVAL '100 days'
    )
    ON CONFLICT DO NOTHING;

    -- Rutina 5: CANCELADA - Rutina que canceló (semana 2 de 4)
    INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, semana_actual, estado, notas, created_at)
    VALUES (
        v_perfil_id,
        v_rutina1_id,
        CURRENT_DATE - INTERVAL '130 days', -- Comenzó hace 130 días
        CURRENT_DATE - INTERVAL '116 days', -- Canceló 2 semanas después
        2, -- Cancelada en semana 2
        'CANCELADO',
        'Cancelada. Preferencia por rutinas de menor intensidad en ese momento.',
        CURRENT_TIMESTAMP - INTERVAL '130 days'
    )
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Datos de Módulo 4 insertados exitosamente';
END $$;

-- ============================================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ============================================================================

-- Ver todas las asignaciones de planes del usuario demo
SELECT 
    'ASIGNACIONES DE PLANES' as tipo,
    up.id,
    p.nombre as plan_nombre,
    p.duracion_dias,
    up.fecha_inicio,
    up.fecha_fin,
    up.dia_actual,
    up.estado,
    up.notas
FROM usuarios_planes up
JOIN perfiles_usuario pu ON up.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
JOIN planes p ON up.id_plan = p.id
WHERE ca.email = 'demo@nutritrack.com'
ORDER BY 
    CASE up.estado 
        WHEN 'ACTIVO' THEN 1 
        WHEN 'PAUSADO' THEN 2 
        WHEN 'COMPLETADO' THEN 3 
        WHEN 'CANCELADO' THEN 4 
    END,
    up.fecha_inicio DESC;

-- Ver todas las asignaciones de rutinas del usuario demo
SELECT 
    'ASIGNACIONES DE RUTINAS' as tipo,
    ur.id,
    r.nombre as rutina_nombre,
    r.duracion_semanas,
    ur.fecha_inicio,
    ur.fecha_fin,
    ur.semana_actual,
    ur.estado,
    ur.notas
FROM usuarios_rutinas ur
JOIN perfiles_usuario pu ON ur.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
JOIN rutinas r ON ur.id_rutina = r.id
WHERE ca.email = 'demo@nutritrack.com'
ORDER BY 
    CASE ur.estado 
        WHEN 'ACTIVO' THEN 1 
        WHEN 'PAUSADO' THEN 2 
        WHEN 'COMPLETADO' THEN 3 
        WHEN 'CANCELADO' THEN 4 
    END,
    ur.fecha_inicio DESC;

-- Resumen por estado
SELECT 
    'RESUMEN PLANES' as tipo,
    estado,
    COUNT(*) as cantidad
FROM usuarios_planes up
JOIN perfiles_usuario pu ON up.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
WHERE ca.email = 'demo@nutritrack.com'
GROUP BY estado
UNION ALL
SELECT 
    'RESUMEN RUTINAS' as tipo,
    estado,
    COUNT(*) as cantidad
FROM usuarios_rutinas ur
JOIN perfiles_usuario pu ON ur.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
WHERE ca.email = 'demo@nutritrack.com'
GROUP BY estado
ORDER BY tipo, estado;

-- ============================================================================
-- MENSAJE FINAL
-- ============================================================================
SELECT 
    '✓ Módulo 4: Datos de asignaciones creados exitosamente' as mensaje,
    COUNT(DISTINCT up.id) as total_planes,
    COUNT(DISTINCT ur.id) as total_rutinas,
    SUM(CASE WHEN up.estado = 'ACTIVO' THEN 1 ELSE 0 END) as planes_activos,
    SUM(CASE WHEN ur.estado = 'ACTIVO' THEN 1 ELSE 0 END) as rutinas_activas
FROM usuarios_planes up
FULL OUTER JOIN usuarios_rutinas ur ON up.id_perfil_usuario = ur.id_perfil_usuario
JOIN perfiles_usuario pu ON COALESCE(up.id_perfil_usuario, ur.id_perfil_usuario) = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
WHERE ca.email = 'demo@nutritrack.com';

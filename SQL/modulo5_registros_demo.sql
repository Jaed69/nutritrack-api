-- ============================================================================
-- DATOS DE DEMOSTRACIÓN - MÓDULO 5
-- Registros de Actividades (Comidas y Ejercicios Realizados)
-- Compatible con NutriDB.sql, modulo3_data_demo.sql y modulo4_asignaciones_demo.sql
-- ============================================================================

-- Este script requiere:
-- 1. Que exista el usuario demo@nutritrack.com (ejecutar demo_user.sql)
-- 2. Que existan planes y rutinas (ejecutar modulo3_data_demo.sql)
-- 3. Que existan asignaciones activas (ejecutar modulo4_asignaciones_demo.sql)
-- 4. Que existan comidas y ejercicios en el catálogo

-- ============================================================================
-- REGISTROS DE COMIDAS (registros_comidas) - MÓDULO 5
-- ============================================================================

DO $$ 
DECLARE
    v_perfil_id BIGINT;
    v_usuario_plan_id BIGINT;
    v_comida1_id BIGINT;
    v_comida2_id BIGINT;
    v_comida3_id BIGINT;
    v_comida4_id BIGINT;
    v_comida5_id BIGINT;
BEGIN
    -- Obtener IDs necesarios
    SELECT id INTO v_perfil_id FROM perfiles_usuario 
    WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com');
    
    -- Obtener plan activo del usuario
    SELECT id INTO v_usuario_plan_id FROM usuarios_planes 
    WHERE id_perfil_usuario = v_perfil_id AND estado = 'ACTIVO' 
    ORDER BY fecha_inicio DESC LIMIT 1;
    
    -- Obtener IDs de comidas del catálogo
    SELECT id INTO v_comida1_id FROM comidas WHERE nombre = 'Avena con frutas y almendras' LIMIT 1;
    SELECT id INTO v_comida2_id FROM comidas WHERE nombre = 'Ensalada de pollo a la parrilla' LIMIT 1;
    SELECT id INTO v_comida3_id FROM comidas WHERE nombre = 'Pescado al horno con verduras' LIMIT 1;
    SELECT id INTO v_comida4_id FROM comidas WHERE nombre = 'Yogur griego con nueces' LIMIT 1;
    SELECT id INTO v_comida5_id FROM comidas WHERE nombre = 'Arroz integral con pollo y vegetales' LIMIT 1;

    -- ============================================================================
    -- REGISTROS DE HOY - Comidas ya completadas
    -- ============================================================================

    -- Desayuno de hoy (07:30)
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan, 
        fecha, hora, tipo_comida, porciones, calorias_consumidas, 
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida1_id,
        v_usuario_plan_id,
        CURRENT_DATE,
        '07:30:00',
        'DESAYUNO',
        1.0,
        450.00,
        'Desayuno completo. Me sentí satisfecho hasta el almuerzo.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Almuerzo de hoy (13:00)
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida2_id,
        v_usuario_plan_id,
        CURRENT_DATE,
        '13:00:00',
        'ALMUERZO',
        1.5,
        520.00,
        'Almuerzo post-entrenamiento. Porción extra de proteína.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Snack de hoy (16:00)
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida4_id,
        v_usuario_plan_id,
        CURRENT_DATE,
        '16:00:00',
        'SNACK',
        1.0,
        280.00,
        'Snack saludable. Perfecto para controlar el hambre antes de la cena.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE AYER - Día completo
    -- ============================================================================

    -- Desayuno de ayer
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida1_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '1 day',
        '07:00:00',
        'DESAYUNO',
        1.0,
        450.00,
        'Desayuno energético. Buen inicio del día.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- Almuerzo de ayer
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida5_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '1 day',
        '12:45:00',
        'ALMUERZO',
        1.0,
        580.00,
        'Almuerzo balanceado. Buenas proporciones de macros.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- Snack de ayer
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida4_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '1 day',
        '16:30:00',
        'SNACK',
        1.0,
        280.00,
        'Snack de media tarde.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- Cena de ayer
    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida3_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '1 day',
        '20:00:00',
        'CENA',
        1.0,
        480.00,
        'Cena ligera pero nutritiva. Me acosté sin sensación de pesadez.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE HACE 2 DÍAS
    -- ============================================================================

    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida1_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '2 days',
        '08:00:00',
        'DESAYUNO',
        1.0,
        450.00,
        'Desayuno completo.',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida2_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '2 days',
        '13:30:00',
        'ALMUERZO',
        1.0,
        520.00,
        'Almuerzo saludable.',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida3_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '2 days',
        '19:45:00',
        'CENA',
        1.0,
        480.00,
        'Cena nutritiva.',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE HACE 3 DÍAS
    -- ============================================================================

    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida1_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '3 days',
        '07:15:00',
        'DESAYUNO',
        1.0,
        450.00,
        'Desayuno energizante.',
        CURRENT_TIMESTAMP - INTERVAL '3 days'
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO registros_comidas (
        id_perfil_usuario, id_comida, id_usuario_plan,
        fecha, hora, tipo_comida, porciones, calorias_consumidas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_comida5_id,
        v_usuario_plan_id,
        CURRENT_DATE - INTERVAL '3 days',
        '12:30:00',
        'ALMUERZO',
        1.5,
        580.00,
        'Almuerzo con porción extra.',
        CURRENT_TIMESTAMP - INTERVAL '3 days'
    )
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Registros de comidas insertados exitosamente';
END $$;

-- ============================================================================
-- REGISTROS DE EJERCICIOS (registros_ejercicios) - MÓDULO 5
-- ============================================================================

DO $$ 
DECLARE
    v_perfil_id BIGINT;
    v_usuario_rutina_id BIGINT;
    v_ejercicio1_id BIGINT;
    v_ejercicio2_id BIGINT;
    v_ejercicio3_id BIGINT;
    v_ejercicio4_id BIGINT;
    v_ejercicio5_id BIGINT;
BEGIN
    -- Obtener IDs necesarios
    SELECT id INTO v_perfil_id FROM perfiles_usuario 
    WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com');
    
    -- Obtener rutina activa del usuario
    SELECT id INTO v_usuario_rutina_id FROM usuarios_rutinas 
    WHERE id_perfil_usuario = v_perfil_id AND estado = 'ACTIVO' 
    ORDER BY fecha_inicio DESC LIMIT 1;
    
    -- Obtener IDs de ejercicios del catálogo
    SELECT id INTO v_ejercicio1_id FROM ejercicios WHERE nombre = 'Burpees' LIMIT 1;
    SELECT id INTO v_ejercicio2_id FROM ejercicios WHERE nombre = 'Mountain Climbers' LIMIT 1;
    SELECT id INTO v_ejercicio3_id FROM ejercicios WHERE nombre = 'Plancha (Plank)' LIMIT 1;
    SELECT id INTO v_ejercicio4_id FROM ejercicios WHERE nombre = 'Sentadillas (Squats)' LIMIT 1;
    SELECT id INTO v_ejercicio5_id FROM ejercicios WHERE nombre = 'Flexiones de pecho (Push-ups)' LIMIT 1;

    -- ============================================================================
    -- REGISTROS DE HOY - Ejercicios ya completados
    -- ============================================================================

    -- Ejercicio 1 de hoy (06:30 - Entrenamiento matutino)
    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio1_id,
        v_usuario_rutina_id,
        CURRENT_DATE,
        '06:30:00',
        4,
        15,
        NULL,
        12,
        180.00,
        'Excelente sesión de HIIT matutino. Me siento con mucha energía.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- Ejercicio 2 de hoy (06:45 - Mismo entrenamiento)
    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio2_id,
        v_usuario_rutina_id,
        CURRENT_DATE,
        '06:45:00',
        4,
        20,
        NULL,
        10,
        150.00,
        'Buen ritmo. Sudé mucho.',
        CURRENT_TIMESTAMP
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE AYER - Sesión completa de entrenamiento
    -- ============================================================================

    -- Ejercicio 1 de ayer
    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio5_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '1 day',
        '18:00:00',
        4,
        12,
        NULL,
        10,
        120.00,
        'Flexiones con buena forma. Sentí trabajo en pecho y tríceps.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- Ejercicio 2 de ayer
    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio3_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '1 day',
        '18:15:00',
        4,
        0, -- Plancha se mide por tiempo, no por repeticiones
        NULL,
        8,
        100.00,
        'Plancha de 1 minuto por serie. Buen trabajo de core.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- Ejercicio 3 de ayer
    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio2_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '1 day',
        '18:25:00',
        3,
        25,
        NULL,
        8,
        140.00,
        'Finalizador intenso. Gran sudoración.',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE HACE 2 DÍAS
    -- ============================================================================

    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio1_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '2 days',
        '06:45:00',
        4,
        12,
        NULL,
        10,
        165.00,
        'Burpees matutinos. Intensidad alta.',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio4_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '2 days',
        '07:00:00',
        4,
        15,
        NULL,
        12,
        140.00,
        'Sentadillas con peso corporal. Buena profundidad.',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE HACE 3 DÍAS
    -- ============================================================================

    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio3_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '3 days',
        '19:00:00',
        4,
        0,
        NULL,
        10,
        110.00,
        'Sesión de core. Plancha isométrica 1 min x 4 series.',
        CURRENT_TIMESTAMP - INTERVAL '3 days'
    )
    ON CONFLICT DO NOTHING;

    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio5_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '3 days',
        '19:12:00',
        3,
        15,
        NULL,
        8,
        130.00,
        'Flexiones inclinadas. Mantuve buena técnica.',
        CURRENT_TIMESTAMP - INTERVAL '3 days'
    )
    ON CONFLICT DO NOTHING;

    -- ============================================================================
    -- REGISTROS DE HACE 5 DÍAS
    -- ============================================================================

    INSERT INTO registros_ejercicios (
        id_perfil_usuario, id_ejercicio, id_usuario_rutina,
        fecha, hora, series_realizadas, repeticiones_realizadas,
        peso_utilizado, duracion_minutos, calorias_quemadas,
        notas, created_at
    )
    VALUES (
        v_perfil_id,
        v_ejercicio1_id,
        v_usuario_rutina_id,
        CURRENT_DATE - INTERVAL '5 days',
        '06:30:00',
        5,
        10,
        NULL,
        15,
        200.00,
        'Sesión intensa de HIIT. 5 series con buen descanso.',
        CURRENT_TIMESTAMP - INTERVAL '5 days'
    )
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Registros de ejercicios insertados exitosamente';
END $$;

-- ============================================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ============================================================================

-- Ver registros de comidas del usuario demo (últimos 7 días)
SELECT 
    'REGISTROS DE COMIDAS' as tipo,
    rc.id,
    rc.fecha,
    rc.hora,
    rc.tipo_comida,
    c.nombre as comida,
    rc.porciones,
    rc.calorias_consumidas,
    rc.notas
FROM registros_comidas rc
JOIN perfiles_usuario pu ON rc.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
JOIN comidas c ON rc.id_comida = c.id
WHERE ca.email = 'demo@nutritrack.com'
    AND rc.fecha >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY rc.fecha DESC, rc.hora DESC;

-- Ver registros de ejercicios del usuario demo (últimos 7 días)
SELECT 
    'REGISTROS DE EJERCICIOS' as tipo,
    re.id,
    re.fecha,
    re.hora,
    e.nombre as ejercicio,
    re.series_realizadas,
    re.repeticiones_realizadas,
    re.duracion_minutos,
    re.calorias_quemadas,
    re.notas
FROM registros_ejercicios re
JOIN perfiles_usuario pu ON re.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
JOIN ejercicios e ON re.id_ejercicio = e.id
WHERE ca.email = 'demo@nutritrack.com'
    AND re.fecha >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY re.fecha DESC, re.hora DESC;

-- Resumen de calorías por día (últimos 7 días)
SELECT 
    rc.fecha,
    COUNT(DISTINCT rc.id) as comidas_registradas,
    ROUND(SUM(rc.calorias_consumidas), 2) as total_calorias_consumidas,
    COUNT(DISTINCT re.id) as ejercicios_registrados,
    ROUND(SUM(re.calorias_quemadas), 2) as total_calorias_quemadas,
    ROUND(SUM(rc.calorias_consumidas) - COALESCE(SUM(re.calorias_quemadas), 0), 2) as balance_calorico
FROM registros_comidas rc
LEFT JOIN registros_ejercicios re ON rc.id_perfil_usuario = re.id_perfil_usuario 
    AND rc.fecha = re.fecha
JOIN perfiles_usuario pu ON rc.id_perfil_usuario = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
WHERE ca.email = 'demo@nutritrack.com'
    AND rc.fecha >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY rc.fecha
ORDER BY rc.fecha DESC;

-- ============================================================================
-- MENSAJE FINAL
-- ============================================================================
SELECT 
    '✓ Módulo 5: Datos de registros creados exitosamente' as mensaje,
    COUNT(DISTINCT rc.id) as total_comidas_registradas,
    COUNT(DISTINCT re.id) as total_ejercicios_registrados,
    ROUND(SUM(rc.calorias_consumidas), 2) as total_calorias_consumidas,
    ROUND(SUM(re.calorias_quemadas), 2) as total_calorias_quemadas,
    COUNT(DISTINCT rc.fecha) as dias_con_registros_comida,
    COUNT(DISTINCT re.fecha) as dias_con_registros_ejercicio
FROM registros_comidas rc
FULL OUTER JOIN registros_ejercicios re 
    ON rc.id_perfil_usuario = re.id_perfil_usuario
JOIN perfiles_usuario pu ON COALESCE(rc.id_perfil_usuario, re.id_perfil_usuario) = pu.id
JOIN cuentas_auth ca ON pu.id_usuario = ca.id
WHERE ca.email = 'demo@nutritrack.com';

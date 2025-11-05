-- ============================================================================
-- MODULO 5: Registros Simplificados (sin acentos problematicos)
-- ============================================================================

DO $$ 
DECLARE
    v_perfil_id BIGINT;
    v_usuario_plan_id BIGINT;
    v_usuario_rutina_id BIGINT;
BEGIN
    SELECT id INTO v_perfil_id FROM perfiles_usuario 
    WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com');
    
    SELECT id INTO v_usuario_plan_id FROM usuarios_planes 
    WHERE id_perfil_usuario = v_perfil_id AND estado = 'ACTIVO' 
    ORDER BY fecha_inicio DESC LIMIT 1;
    
    SELECT id INTO v_usuario_rutina_id FROM usuarios_rutinas 
    WHERE id_perfil_usuario = v_perfil_id AND estado = 'ACTIVO' 
    ORDER BY fecha_inicio DESC LIMIT 1;

    -- HOY: Desayuno
    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE, '07:30:00', 'DESAYUNO', 1.0, 450.00, 'Desayuno energetico'
    FROM comidas WHERE nombre = 'Avena con frutas y almendras' LIMIT 1;

    -- HOY: Almuerzo
    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE, '13:00:00', 'ALMUERZO', 1.5, 520.00, 'Post-entrenamiento'
    FROM comidas WHERE nombre = 'Ensalada de pollo a la parrilla' LIMIT 1;

    -- HOY: Snack
    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE, '16:00:00', 'SNACK', 1.0, 280.00, 'Snack saludable'
    FROM comidas WHERE nombre = 'Yogur griego con nueces' LIMIT 1;

    -- AYER: Dia completo
    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE - 1, '07:00:00', 'DESAYUNO', 1.0, 450.00, 'Buen inicio'
    FROM comidas WHERE nombre = 'Avena con frutas y almendras' LIMIT 1;

    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE - 1, '12:45:00', 'ALMUERZO', 1.0, 580.00, 'Balanceado'
    FROM comidas WHERE nombre = 'Arroz integral con pollo y vegetales' LIMIT 1;

    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE - 1, '20:00:00', 'CENA', 1.0, 480.00, 'Cena ligera'
    FROM comidas WHERE nombre = 'Pescado al horno con verduras' LIMIT 1;

    -- HACE 2 DIAS
    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE - 2, '08:00:00', 'DESAYUNO', 1.0, 450.00, 'Completo'
    FROM comidas WHERE nombre = 'Avena con frutas y almendras' LIMIT 1;

    INSERT INTO registros_comidas (id_perfil_usuario, id_comida, id_usuario_plan, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
    SELECT v_perfil_id, id, v_usuario_plan_id, CURRENT_DATE - 2, '13:30:00', 'ALMUERZO', 1.0, 520.00, 'Saludable'
    FROM comidas WHERE nombre = 'Ensalada de pollo a la parrilla' LIMIT 1;

    -- HOY: Ejercicios
    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE, '06:30:00', 4, 15, 12, 180.00, 'HIIT matutino'
    FROM ejercicios WHERE nombre = 'Burpees' LIMIT 1;

    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE, '06:45:00', 4, 20, 10, 150.00, 'Buen ritmo'
    FROM ejercicios WHERE nombre = 'Mountain Climbers' LIMIT 1;

    -- AYER: Ejercicios
    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE - 1, '18:00:00', 4, 12, 10, 120.00, 'Buena forma'
    FROM ejercicios WHERE nombre = 'Flexiones de pecho (Push-ups)' LIMIT 1;

    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE - 1, '18:15:00', 4, 0, 8, 100.00, 'Core fuerte'
    FROM ejercicios WHERE nombre = 'Plancha (Plank)' LIMIT 1;

    -- HACE 2 DIAS
    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE - 2, '06:45:00', 4, 12, 10, 165.00, 'Alta intensidad'
    FROM ejercicios WHERE nombre = 'Burpees' LIMIT 1;

    INSERT INTO registros_ejercicios (id_perfil_usuario, id_ejercicio, id_usuario_rutina, fecha, hora, series_realizadas, repeticiones_realizadas, duracion_minutos, calorias_quemadas, notas)
    SELECT v_perfil_id, id, v_usuario_rutina_id, CURRENT_DATE - 2, '07:00:00', 4, 15, 12, 140.00, 'Buena profundidad'
    FROM ejercicios WHERE nombre = 'Sentadillas (Squats)' LIMIT 1;

    RAISE NOTICE 'Modulo 5: Registros insertados exitosamente';
END $$;

-- Verificacion
SELECT 
    'Registros Modulo 5' as mensaje,
    (SELECT COUNT(*) FROM registros_comidas WHERE id_perfil_usuario IN (
        SELECT id FROM perfiles_usuario WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com')
    )) as comidas,
    (SELECT COUNT(*) FROM registros_ejercicios WHERE id_perfil_usuario IN (
        SELECT id FROM perfiles_usuario WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com')
    )) as ejercicios;

-- Resumen de ultimos 7 dias
SELECT 
    rc.fecha,
    COUNT(DISTINCT rc.id) as comidas_dia,
    ROUND(SUM(rc.calorias_consumidas), 0) as calorias_comidas,
    COUNT(DISTINCT re.id) as ejercicios_dia,
    ROUND(SUM(re.calorias_quemadas), 0) as calorias_ejercicios
FROM registros_comidas rc
LEFT JOIN registros_ejercicios re ON rc.id_perfil_usuario = re.id_perfil_usuario AND rc.fecha = re.fecha
WHERE rc.id_perfil_usuario IN (
    SELECT id FROM perfiles_usuario WHERE id_usuario = (SELECT id FROM cuentas_auth WHERE email = 'demo@nutritrack.com')
)
AND rc.fecha >= CURRENT_DATE - 7
GROUP BY rc.fecha
ORDER BY rc.fecha DESC;

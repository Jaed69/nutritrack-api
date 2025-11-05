-- ============================================================================
-- SCRIPT DE DATOS DE DEMOSTRACIÓN - NutriTrack API
-- Módulos 1-5: Datos completos para pruebas del sistema
-- Compatible con schema actualizado (NutriDB.sql Nov 5, 2025)
-- ============================================================================

-- ============================================================================
-- MÓDULO 2: PERFILES DE SALUD Y MEDICIONES
-- ============================================================================
-- Nota: Los usuarios admin (ID=1) y demo (ID=2) ya están creados por la app
-- ============================================================================

-- ============================================================================
-- PERFIL DE SALUD - ADMIN
-- ============================================================================
INSERT INTO usuario_perfil_salud (id_perfil, objetivo_actual, nivel_actividad_actual, fecha_actualizacion) 
VALUES (1, 'MANTENER_FORMA', 'ALTO', '2025-11-05')
ON CONFLICT (id_perfil) DO UPDATE 
SET objetivo_actual = 'MANTENER_FORMA', 
    nivel_actividad_actual = 'ALTO',
    fecha_actualizacion = '2025-11-05';

-- ============================================================================
-- HISTORIAL DE MEDIDAS - ADMIN
-- ============================================================================
DELETE FROM usuario_historial_medidas WHERE id_cliente = 1;

INSERT INTO usuario_historial_medidas (id_cliente, fecha_medicion, peso, altura) VALUES
(1, '2025-09-01', 70.0, 175),
(1, '2025-09-08', 70.2, 175),
(1, '2025-09-15', 69.8, 175),
(1, '2025-09-22', 70.1, 175),
(1, '2025-09-29', 70.0, 175),
(1, '2025-10-06', 70.3, 175),
(1, '2025-10-13', 70.0, 175),
(1, '2025-10-20', 70.2, 175),
(1, '2025-10-27', 70.4, 175),
(1, '2025-11-03', 70.5, 175),
(1, '2025-11-04', 70.5, 175);

-- ============================================================================
-- PERFIL DE SALUD - DEMO
-- ============================================================================
INSERT INTO usuario_perfil_salud (id_perfil, objetivo_actual, nivel_actividad_actual, fecha_actualizacion) 
VALUES (2, 'PERDER_PESO', 'MODERADO', '2025-11-05')
ON CONFLICT (id_perfil) DO UPDATE 
SET objetivo_actual = 'PERDER_PESO', 
    nivel_actividad_actual = 'MODERADO',
    fecha_actualizacion = '2025-11-05';

-- ============================================================================
-- HISTORIAL DE MEDIDAS - DEMO
-- ============================================================================
DELETE FROM usuario_historial_medidas WHERE id_cliente = 2;

INSERT INTO usuario_historial_medidas (id_cliente, fecha_medicion, peso, altura) VALUES
(2, '2025-09-01', 78.0, 168),
(2, '2025-09-08', 77.5, 168),
(2, '2025-09-15', 77.0, 168),
(2, '2025-09-22', 76.8, 168),
(2, '2025-09-29', 76.2, 168),
(2, '2025-10-05', 75.5, 168),
(2, '2025-10-12', 75.0, 168),
(2, '2025-10-19', 74.5, 168),
(2, '2025-10-26', 73.8, 168),
(2, '2025-11-02', 73.0, 168),
(2, '2025-11-04', 72.5, 168);

-- ============================================================================
-- MÓDULO 3: ETIQUETAS (para clasificación de planes y rutinas)
-- ============================================================================
-- Cubre: US-06 (Gestionar Etiquetas), RN04 (Etiquetas maestras), RN16 (Alérgenos)
-- ============================================================================

INSERT INTO etiquetas (nombre, tipo_etiqueta, descripcion) VALUES
-- OBJETIVOS (para perfiles de salud y filtrado de planes)
('Pérdida de Peso', 'OBJETIVO', 'Objetivo de reducir masa corporal'),
('Ganancia Muscular', 'OBJETIVO', 'Objetivo de aumentar masa muscular'),
('Definición', 'OBJETIVO', 'Objetivo de tonificar y definir músculos'),
('Resistencia', 'OBJETIVO', 'Mejorar capacidad cardiovascular'),
('Fuerza', 'OBJETIVO', 'Aumentar fuerza muscular'),
('Mantenimiento', 'OBJETIVO', 'Mantener condición física actual'),

-- ALERGIAS (para seguridad de salud - RN16 CRÍTICA)
('Nueces', 'ALERGIA', 'Alergia a frutos secos - nueces'),
('Lácteos', 'ALERGIA', 'Intolerancia a lactosa o proteína de leche'),
('Gluten', 'ALERGIA', 'Celiaquía o sensibilidad al gluten'),
('Mariscos', 'ALERGIA', 'Alergia a mariscos y pescados'),
('Huevo', 'ALERGIA', 'Alergia a proteína del huevo'),
('Soya', 'ALERGIA', 'Alergia a soya y derivados'),

-- CONDICIONES MÉDICAS (para filtrado de planes)
('Diabetes', 'CONDICION_MEDICA', 'Requiere control de carbohidratos'),
('Hipertensión', 'CONDICION_MEDICA', 'Requiere bajo sodio'),
('Colesterol Alto', 'CONDICION_MEDICA', 'Requiere control de grasas'),

-- DIETAS (para clasificar planes nutricionales)
('Vegano', 'DIETA', 'Sin productos de origen animal'),
('Vegetariano', 'DIETA', 'Sin carne ni pescado'),
('Keto', 'DIETA', 'Bajo carbohidratos, alto grasa'),
('Paleo', 'DIETA', 'Basado en alimentos naturales'),

-- TIPOS DE EJERCICIO
('HIIT', 'TIPO_EJERCICIO', 'Entrenamiento de intervalos de alta intensidad'),
('Cardio', 'TIPO_EJERCICIO', 'Ejercicios cardiovasculares'),
('Fuerza', 'TIPO_EJERCICIO', 'Entrenamiento de fuerza'),
('Funcional', 'TIPO_EJERCICIO', 'Ejercicios funcionales'),
('Yoga', 'TIPO_EJERCICIO', 'Ejercicios de flexibilidad y equilibrio'),

-- DIFICULTAD
('Principiante', 'DIFICULTAD', 'Nivel básico'),
('Intermedio', 'DIFICULTAD', 'Nivel medio'),
('Avanzado', 'DIFICULTAD', 'Nivel avanzado')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- ASIGNAR ETIQUETAS DE ALERGIA/CONDICIÓN A USUARIOS (US-04, RN16)
-- ============================================================================
-- ADMIN: Sin alergias (puede ver todos los planes)
-- DEMO: Alérgico a Nueces (para probar filtrado RN16)

INSERT INTO usuario_etiquetas_salud (id_perfil, id_etiqueta)
SELECT 2, e.id FROM etiquetas e WHERE e.nombre = 'Nueces'
ON CONFLICT DO NOTHING;

-- Para probar que DEMO NO ve planes con nueces en ingredientes

-- ============================================================================
-- MÓDULO 3: PLANES NUTRICIONALES
-- ============================================================================

INSERT INTO planes (nombre, descripcion, duracion_dias, activo) VALUES
('Plan Pérdida de Grasa Efectiva', 
 'Programa completo de 8 semanas con déficit calórico controlado. Combina comidas balanceadas ricas en proteína con carbohidratos complejos para maximizar la quema de grasa mientras preservas masa muscular.',
 56, true),
 
('Plan Hipertrofia Muscular Avanzado',
 'Programa intensivo de 12 semanas con superávit calórico. Diseñado para maximizar ganancia de masa muscular magra con alto contenido proteico y carbohidratos estratégicos post-entrenamiento.',
 84, true),
 
('Plan Definición y Tonificación',
 'Programa de 6 semanas para definir y tonificar. Balance perfecto entre déficit calórico moderado y nutrición estratégica para reducir grasa corporal manteniendo músculo.',
 42, true),
 
('Plan Mantenimiento Básico',
 'Programa de 4 semanas para mantener la forma física actual. Alimentación equilibrada de mantenimiento calórico.',
 28, false)
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- OBJETIVOS NUTRICIONALES DE LOS PLANES (1-to-1)
-- ============================================================================

INSERT INTO plan_objetivos (id_plan, calorias_objetivo, proteinas_objetivo, carbohidratos_objetivo, grasas_objetivo, descripcion)
SELECT id, 1800.00, 150.00, 150.00, 60.00, 'Déficit moderado para pérdida de grasa sostenible'
FROM planes WHERE nombre = 'Plan Pérdida de Grasa Efectiva'
ON CONFLICT (id_plan) DO NOTHING;

INSERT INTO plan_objetivos (id_plan, calorias_objetivo, proteinas_objetivo, carbohidratos_objetivo, grasas_objetivo, descripcion)
SELECT id, 3000.00, 200.00, 350.00, 100.00, 'Superávit para ganancia muscular'
FROM planes WHERE nombre = 'Plan Hipertrofia Muscular Avanzado'
ON CONFLICT (id_plan) DO NOTHING;

INSERT INTO plan_objetivos (id_plan, calorias_objetivo, proteinas_objetivo, carbohidratos_objetivo, grasas_objetivo, descripcion)
SELECT id, 2000.00, 160.00, 180.00, 65.00, 'Balance para definición'
FROM planes WHERE nombre = 'Plan Definición y Tonificación'
ON CONFLICT (id_plan) DO NOTHING;

-- ============================================================================
-- ETIQUETAS DE PLANES (many-to-many)
-- ============================================================================

-- Plan 1: Pérdida de Grasa → Etiquetas
INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND e.nombre = 'Pérdida de Peso'
ON CONFLICT DO NOTHING;

INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND e.nombre = 'Resistencia'
ON CONFLICT DO NOTHING;

-- Plan 2: Hipertrofia → Etiquetas
INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Hipertrofia Muscular Avanzado' AND e.nombre = 'Ganancia Muscular'
ON CONFLICT DO NOTHING;

INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Hipertrofia Muscular Avanzado' AND e.nombre = 'Fuerza'
ON CONFLICT DO NOTHING;

-- Plan 3: Definición → Etiquetas
INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Definición y Tonificación' AND e.nombre = 'Definición'
ON CONFLICT DO NOTHING;

INSERT INTO plan_etiquetas (id_plan, id_etiqueta)
SELECT p.id, e.id FROM planes p, etiquetas e 
WHERE p.nombre = 'Plan Definición y Tonificación' AND e.nombre = 'Pérdida de Peso'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- DÍAS DE LOS PLANES CON COMIDAS ASIGNADAS
-- ============================================================================
-- IMPORTANTE: plan_dias vincula COMIDAS (no rutinas)
-- Cada plan tiene un menú diario de comidas
-- ============================================================================

-- Plan 1: Pérdida de Grasa (Semana 1 - 7 días)
INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 1, 'DESAYUNO', 'Inicio del día con energía', c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Avena con frutas y almendras';

INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 1, 'ALMUERZO', 'Comida principal rica en proteína', c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Ensalada de pollo a la parrilla';

INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 1, 'CENA', 'Cena ligera con omega-3', c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Pescado al horno con verduras';

INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 1, 'SNACK', 'Snack entre comidas', c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Yogur griego con nueces';

-- Día 2
INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 2, 'DESAYUNO', NULL, c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Huevos revueltos con pan integral';

INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 2, 'ALMUERZO', NULL, c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Arroz integral con pollo y vegetales';

INSERT INTO plan_dias (id_plan, numero_dia, tipo_comida, notas, id_comida)
SELECT p.id, 2, 'CENA', NULL, c.id
FROM planes p, comidas c
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva' AND c.nombre = 'Ensalada verde ligera';

-- ============================================================================
-- MÓDULO 3: RUTINAS DE EJERCICIO
-- ============================================================================

INSERT INTO rutinas (nombre, descripcion, duracion_semanas, nivel_dificultad, activo) VALUES
('HIIT Quema Grasa Intenso',
 'Entrenamiento de intervalos de alta intensidad diseñado para maximizar la quema de calorías en 30 minutos. Alterna períodos cortos de esfuerzo máximo con descansos activos.',
 8, 'INTERMEDIO', true),
 
('Fuerza Tren Superior Completo',
 'Rutina de hipertrofia enfocada en pecho, espalda, hombros y brazos. Utiliza ejercicios compuestos para maximizar la ganancia muscular del tren superior.',
 12, 'AVANZADO', true),
 
('Fuerza Tren Inferior Potencia',
 'Entrenamiento intenso para piernas y glúteos. Combina ejercicios de fuerza con trabajo de potencia para desarrollo muscular completo del tren inferior.',
 12, 'AVANZADO', true),
 
('Cardio Moderado Resistencia',
 'Sesión cardiovascular de intensidad moderada para mejorar la resistencia aeróbica y quemar calorías de forma sostenida durante 40 minutos.',
 8, 'PRINCIPIANTE', true),
 
('Core Funcional y Abdominales',
 'Rutina especializada en fortalecimiento del core, abdominales y zona lumbar. Esencial para estabilidad corporal y prevención de lesiones.',
 6, 'INTERMEDIO', true),
 
('Movilidad y Flexibilidad',
 'Sesión de estiramientos y movilidad articular para recuperación.',
 4, 'PRINCIPIANTE', false)
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- ETIQUETAS DE RUTINAS (many-to-many)
-- ============================================================================

-- Rutina 1: HIIT → Etiquetas
INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Pérdida de Peso'
ON CONFLICT DO NOTHING;

INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Resistencia'
ON CONFLICT DO NOTHING;

-- Rutina 2: Tren Superior → Etiquetas
INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Ganancia Muscular'
ON CONFLICT DO NOTHING;

INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Fuerza'
ON CONFLICT DO NOTHING;

-- Rutina 3: Tren Inferior → Etiquetas
INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Fuerza Tren Inferior Potencia' AND e.nombre = 'Ganancia Muscular'
ON CONFLICT DO NOTHING;

INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Fuerza Tren Inferior Potencia' AND e.nombre = 'Fuerza'
ON CONFLICT DO NOTHING;

-- Rutina 4: Cardio → Etiquetas
INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Cardio Moderado Resistencia' AND e.nombre = 'Resistencia'
ON CONFLICT DO NOTHING;

INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Cardio Moderado Resistencia' AND e.nombre = 'Pérdida de Peso'
ON CONFLICT DO NOTHING;

-- Rutina 5: Core → Etiquetas
INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Definición'
ON CONFLICT DO NOTHING;

INSERT INTO rutina_etiquetas (id_rutina, id_etiqueta)
SELECT r.id, e.id FROM rutinas r, etiquetas e 
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Fuerza'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- EJERCICIOS EN RUTINAS (con configuración detallada)
-- ============================================================================

-- RUTINA 1: HIIT QUEMA GRASA (30 min)
INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 1, 1, 30, 5, NULL, 0, 'Calentamiento dinámico - 5 minutos'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Saltos de tijera (Jumping Jacks)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 2, 4, 15, NULL, NULL, 15, '30 seg trabajo / 15 seg descanso'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Burpees';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 3, 4, 20, NULL, NULL, 15, '30 seg trabajo / 15 seg descanso'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Mountain Climbers';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 4, 4, NULL, 1, NULL, 15, '45 seg trabajo / 15 seg descanso'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Saltos de tijera (Jumping Jacks)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 5, 3, 12, NULL, NULL, 30, 'Cada lado - Explosivo'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Zancadas (Lunges)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 6, 1, NULL, 5, NULL, 0, 'Estiramiento suave - 5 minutos'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'HIIT Quema Grasa Intenso' AND e.nombre = 'Plancha (Plank)';

-- RUTINA 2: FUERZA TREN SUPERIOR (60 min)
INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 1, 4, 8, NULL, NULL, 90, 'Peso corporal - Forma estricta'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Flexiones de pecho (Push-ups)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 2, 4, 10, NULL, NULL, 120, 'Agarre ancho - Contracción completa'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Dominadas (Pull-ups)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 3, 3, 12, NULL, 15.0, 60, 'Por brazo - Control total'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Curl de bíceps con mancuernas';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 4, 3, 15, NULL, NULL, 60, 'Brazos extendidos - Sin balanceo'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Superior Completo' AND e.nombre = 'Fondos en banco (Dips)';

-- RUTINA 3: FUERZA TREN INFERIOR (55 min)
INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 1, 5, 10, NULL, 60.0, 180, 'Profundidad completa - Barra libre'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Inferior Potencia' AND e.nombre = 'Sentadillas (Squats)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 2, 4, 12, NULL, 40.0, 90, 'Cada pierna - Paso amplio'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Inferior Potencia' AND e.nombre = 'Zancadas (Lunges)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 3, 3, 20, NULL, NULL, 90, 'Explosivo - Máxima altura'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Fuerza Tren Inferior Potencia' AND e.nombre = 'Sentadilla con salto (Jump Squats)';

-- RUTINA 4: CARDIO MODERADO (40 min)
INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 1, 1, NULL, 10, NULL, 0, 'Calentamiento progresivo'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Cardio Moderado Resistencia' AND e.nombre = 'Saltos de tijera (Jumping Jacks)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 2, 3, NULL, 10, NULL, 60, '10 min por serie - Ritmo constante'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Cardio Moderado Resistencia' AND e.nombre = 'Trote en el lugar (Jogging in Place)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 3, 2, 30, NULL, NULL, 30, 'Ritmo moderado - 2 series'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Cardio Moderado Resistencia' AND e.nombre = 'Mountain Climbers';

-- RUTINA 5: CORE Y ABDOMINALES (25 min)
INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 1, 4, NULL, 1, NULL, 30, 'Forma perfecta - 1 minuto hold'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Plancha (Plank)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 2, 3, 20, NULL, NULL, 45, 'Contracción completa - Sin impulso'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Abdominales (Crunches)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 3, 3, 15, NULL, NULL, 45, 'Cada lado - Rotación controlada'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Giros rusos (Russian Twists)';

INSERT INTO rutina_ejercicios (id_rutina, id_ejercicio, orden, series, repeticiones, duracion_minutos, peso, descanso_segundos, notas)
SELECT r.id, e.id, 4, 3, 15, NULL, NULL, 45, 'Elevación controlada - Sin balanceo'
FROM rutinas r, ejercicios e
WHERE r.nombre = 'Core Funcional y Abdominales' AND e.nombre = 'Elevación de piernas';

-- ============================================================================
-- MÓDULO 4: ASIGNACIÓN DE PLANES Y RUTINAS A USUARIOS
-- ============================================================================

-- ADMIN: Asignar "Plan Definición" (activo desde hace 14 días)
INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, estado, dia_actual, notas)
SELECT 1, p.id, '2025-10-22', '2025-12-03', 'ACTIVO', 14, 'Plan para mantener definición muscular'
FROM planes p
WHERE p.nombre = 'Plan Definición y Tonificación';

-- ADMIN: Asignar "Rutina Core" (activa desde hace 2 semanas)
INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, estado, semana_actual, notas)
SELECT 1, r.id, '2025-10-22', '2025-11-26', 'ACTIVO', 2, 'Fortalecimiento de core 3 veces por semana'
FROM rutinas r
WHERE r.nombre = 'Core Funcional y Abdominales';

-- DEMO: Asignar "Plan Pérdida de Grasa" (activo desde hace 21 días)
INSERT INTO usuarios_planes (id_perfil_usuario, id_plan, fecha_inicio, fecha_fin, estado, dia_actual, notas)
SELECT 2, p.id, '2025-10-15', '2025-12-10', 'ACTIVO', 21, 'Progreso excelente: -5.5kg en 7 semanas'
FROM planes p
WHERE p.nombre = 'Plan Pérdida de Grasa Efectiva';

-- DEMO: Asignar "Rutina HIIT" (activa desde hace 3 semanas)
INSERT INTO usuarios_rutinas (id_perfil_usuario, id_rutina, fecha_inicio, fecha_fin, estado, semana_actual, notas)
SELECT 2, r.id, '2025-10-15', '2025-12-10', 'ACTIVO', 3, 'HIIT 3 veces por semana - Excelente adherencia'
FROM rutinas r
WHERE r.nombre = 'HIIT Quema Grasa Intenso';

-- ============================================================================
-- MÓDULO 5: REGISTROS DE COMIDAS (últimos 7 días)
-- ============================================================================

-- ADMIN: Registros de comidas (cumpliendo su plan)
INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 1, up.id, c.id, '2025-11-04', '08:00:00', 'DESAYUNO', 1.0, 450.00, 'Día 14 del plan'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO' 
AND c.nombre = 'Avena con frutas y almendras';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 1, up.id, c.id, '2025-11-04', '13:00:00', 'ALMUERZO', 1.0, 520.00, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO'
AND c.nombre = 'Ensalada de pollo a la parrilla';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 1, up.id, c.id, '2025-11-04', '19:30:00', 'CENA', 1.0, 480.00, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 1 AND up.estado = 'ACTIVO'
AND c.nombre = 'Pescado al horno con verduras';

-- DEMO: Registros de comidas (siguiendo plan de pérdida)
INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 2, up.id, c.id, '2025-11-04', '07:30:00', 'DESAYUNO', 1.0, 420.00, 'Día 21 - Excelente progreso'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 2 AND up.estado = 'ACTIVO'
AND c.nombre = 'Huevos revueltos con pan integral';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 2, up.id, c.id, '2025-11-04', '12:30:00', 'ALMUERZO', 1.0, 550.00, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 2 AND up.estado = 'ACTIVO'
AND c.nombre = 'Arroz integral con pollo y vegetales';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 2, up.id, c.id, '2025-11-04', '18:00:00', 'SNACK', 1.0, 180.00, 'Snack pre-entrenamiento'
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 2 AND up.estado = 'ACTIVO'
AND c.nombre = 'Batido de proteína con plátano';

INSERT INTO registros_comidas (id_perfil_usuario, id_usuario_plan, id_comida, fecha, hora, tipo_comida, porciones, calorias_consumidas, notas)
SELECT 2, up.id, c.id, '2025-11-04', '20:00:00', 'CENA', 1.0, 320.00, NULL
FROM usuarios_planes up, comidas c
WHERE up.id_perfil_usuario = 2 AND up.estado = 'ACTIVO'
AND c.nombre = 'Ensalada verde ligera';

-- ============================================================================
-- MÓDULO 5: REGISTROS DE EJERCICIOS (últimos 7 días)
-- ============================================================================

-- ADMIN: Sesión de Core (Nov 4)
INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 1, ur.id, e.id, '2025-11-04', '18:00:00', 1, 4, NULL, NULL, 20.00, 'Plancha 60 segundos x4'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 1 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Plancha (Plank)';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 1, ur.id, e.id, '2025-11-04', '18:05:00', 8, 3, 20, NULL, 32.00, 'Serie completa'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 1 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Abdominales (Crunches)';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 1, ur.id, e.id, '2025-11-04', '18:15:00', 7, 3, 15, NULL, 35.00, 'Cada lado'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 1 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Giros rusos (Russian Twists)';

-- DEMO: Sesión HIIT (Nov 4)
INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 2, ur.id, e.id, '2025-11-04', '18:30:00', 5, 1, 30, NULL, 40.00, 'Calentamiento'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Saltos de tijera (Jumping Jacks)';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 2, ur.id, e.id, '2025-11-04', '18:35:00', 8, 4, 15, NULL, 100.00, 'Intensidad máxima'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Burpees';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 2, ur.id, e.id, '2025-11-04', '18:45:00', 7, 4, 20, NULL, 70.00, 'Mantener ritmo'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Mountain Climbers';

INSERT INTO registros_ejercicios (id_perfil_usuario, id_usuario_rutina, id_ejercicio, fecha, hora, duracion_minutos, series_realizadas, repeticiones_realizadas, peso_utilizado, calorias_quemadas, notas)
SELECT 2, ur.id, e.id, '2025-11-04', '18:55:00', 5, 3, 12, NULL, 45.00, 'Piernas fatigadas pero completado'
FROM usuarios_rutinas ur, ejercicios e
WHERE ur.id_perfil_usuario = 2 AND ur.estado = 'ACTIVO'
AND e.nombre = 'Zancadas (Lunges)';

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

SELECT 
    'DATOS DEMO CARGADOS EXITOSAMENTE' as mensaje,
    (SELECT COUNT(*) FROM usuario_perfil_salud) as perfiles_salud,
    (SELECT COUNT(*) FROM usuario_historial_medidas) as mediciones,
    (SELECT COUNT(*) FROM etiquetas) as etiquetas,
    (SELECT COUNT(*) FROM planes) as planes,
    (SELECT COUNT(*) FROM plan_objetivos) as objetivos_planes,
    (SELECT COUNT(*) FROM plan_dias) as dias_planes,
    (SELECT COUNT(*) FROM rutinas) as rutinas,
    (SELECT COUNT(*) FROM rutina_ejercicios) as ejercicios_rutinas,
    (SELECT COUNT(*) FROM usuarios_planes) as asignaciones_planes,
    (SELECT COUNT(*) FROM usuarios_rutinas) as asignaciones_rutinas,
    (SELECT COUNT(*) FROM registros_comidas) as registros_comidas,
    (SELECT COUNT(*) FROM registros_ejercicios) as registros_ejercicios;

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

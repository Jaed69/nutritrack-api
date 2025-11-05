-- ============================================================================
-- CATÁLOGO BÁSICO - Compatible con NutriDB.sql
-- Datos mínimos para pruebas de Módulos 4 y 5
-- ============================================================================

-- ============================================================================
-- INGREDIENTES BÁSICOS
-- ============================================================================

INSERT INTO ingredientes (nombre, energia, proteinas, carbohidratos, grasas, grupo_alimenticio, categoria_alimento) VALUES
('Pollo', 165.00, 31.00, 0.00, 3.60, 'PROTEINAS_ANIMALES', 'PROTEINAS'),
('Arroz integral', 370.00, 7.90, 77.20, 2.90, 'CEREALES', 'CEREALES'),
('Avena', 389.00, 16.90, 66.30, 6.90, 'CEREALES', 'CEREALES'),
('Plátano', 89.00, 1.10, 22.80, 0.30, 'FRUTAS', 'FRUTAS'),
('Almendras', 579.00, 21.20, 21.60, 49.90, 'FRUTOS_SECOS', 'FRUTOS_SECOS'),
('Yogur', 59.00, 3.50, 4.70, 3.30, 'LACTEOS', 'LACTEOS'),
('Pescado', 206.00, 22.00, 0.00, 12.00, 'PROTEINAS_ANIMALES', 'PROTEINAS'),
('Verduras mix', 25.00, 2.00, 5.00, 0.20, 'VERDURAS', 'VERDURAS'),
('Huevos', 155.00, 13.00, 1.10, 11.00, 'PROTEINAS_ANIMALES', 'PROTEINAS'),
('Pan integral', 247.00, 13.00, 41.00, 3.50, 'CEREALES', 'CEREALES'),
('Nueces', 654.00, 15.20, 13.70, 65.20, 'FRUTOS_SECOS', 'FRUTOS_SECOS'),
('Proteína en polvo', 120.00, 25.00, 3.00, 1.50, 'PROTEINAS_VEGETALES', 'PROTEINAS')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- COMIDAS BÁSICAS
-- ============================================================================

INSERT INTO comidas (nombre, tipo_comida, tiempo_elaboracion) VALUES
('Avena con frutas y almendras', 'DESAYUNO', 10),
('Ensalada de pollo a la parrilla', 'ALMUERZO', 20),
('Pescado al horno con verduras', 'CENA', 30),
('Yogur griego con nueces', 'SNACK', 5),
('Huevos revueltos con pan integral', 'DESAYUNO', 15),
('Arroz integral con pollo y vegetales', 'ALMUERZO', 25),
('Batido de proteína con plátano', 'PRE_ENTRENAMIENTO', 5),
('Ensalada verde ligera', 'CENA', 10),
('Frutos secos mix', 'COLACION', 2),
('Wrap de pollo', 'ALMUERZO', 15)
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- RECETAS (Asociar ingredientes a comidas)
-- ============================================================================

-- Avena con frutas y almendras
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 50.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Avena con frutas y almendras' AND i.nombre = 'Avena'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 100.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Avena con frutas y almendras' AND i.nombre = 'Plátano'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 20.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Avena con frutas y almendras' AND i.nombre = 'Almendras'
ON CONFLICT DO NOTHING;

-- Ensalada de pollo a la parrilla
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 150.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Ensalada de pollo a la parrilla' AND i.nombre = 'Pollo'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 200.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Ensalada de pollo a la parrilla' AND i.nombre = 'Verduras mix'
ON CONFLICT DO NOTHING;

-- Pescado al horno con verduras
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 180.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Pescado al horno con verduras' AND i.nombre = 'Pescado'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 150.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Pescado al horno con verduras' AND i.nombre = 'Verduras mix'
ON CONFLICT DO NOTHING;

-- Yogur griego con nueces
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 150.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Yogur griego con nueces' AND i.nombre = 'Yogur'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 30.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Yogur griego con nueces' AND i.nombre = 'Nueces'
ON CONFLICT DO NOTHING;

-- Arroz integral con pollo y vegetales
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 80.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Arroz integral con pollo y vegetales' AND i.nombre = 'Arroz integral'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 150.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Arroz integral con pollo y vegetales' AND i.nombre = 'Pollo'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 100.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Arroz integral con pollo y vegetales' AND i.nombre = 'Verduras mix'
ON CONFLICT DO NOTHING;

-- Batido de proteína con plátano
INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 30.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Batido de proteína con plátano' AND i.nombre = 'Proteína en polvo'
ON CONFLICT DO NOTHING;

INSERT INTO recetas (id_comida, id_ingrediente, cantidad_ingrediente)
SELECT c.id, i.id, 120.00
FROM comidas c, ingredientes i
WHERE c.nombre = 'Batido de proteína con plátano' AND i.nombre = 'Plátano'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- EJERCICIOS BÁSICOS
-- ============================================================================

INSERT INTO ejercicios (nombre, descripcion, tipo_ejercicio, dificultad, grupo_muscular, nivel_dificultad) VALUES
('Burpees', 'Ejercicio completo de cuerpo que combina sentadilla, plancha y salto', 'CARDIO', 'INTERMEDIO', 'CUERPO_COMPLETO', 'INTERMEDIO'),
('Mountain Climbers', 'Ejercicio cardiovascular que trabaja core y piernas', 'CARDIO', 'INTERMEDIO', 'CORE', 'INTERMEDIO'),
('Plancha (Plank)', 'Ejercicio isométrico para fortalecer el core', 'FUERZA', 'PRINCIPIANTE', 'CORE', 'PRINCIPIANTE'),
('Sentadillas (Squats)', 'Ejercicio fundamental para piernas y glúteos', 'FUERZA', 'PRINCIPIANTE', 'PIERNAS', 'PRINCIPIANTE'),
('Flexiones de pecho (Push-ups)', 'Ejercicio para pecho, hombros y tríceps', 'FUERZA', 'PRINCIPIANTE', 'PECHO', 'PRINCIPIANTE'),
('Dominadas (Pull-ups)', 'Ejercicio para espalda y bíceps', 'FUERZA', 'AVANZADO', 'ESPALDA', 'AVANZADO'),
('Zancadas (Lunges)', 'Ejercicio para piernas y equilibrio', 'FUERZA', 'PRINCIPIANTE', 'PIERNAS', 'PRINCIPIANTE'),
('Saltos de tijera (Jumping Jacks)', 'Ejercicio cardiovascular básico', 'CARDIO', 'PRINCIPIANTE', 'CARDIO', 'PRINCIPIANTE'),
('Abdominales (Crunches)', 'Ejercicio para abdomen', 'FUERZA', 'PRINCIPIANTE', 'ABDOMINALES', 'PRINCIPIANTE'),
('Trote en el lugar (Jogging in Place)', 'Cardio de bajo impacto', 'CARDIO', 'PRINCIPIANTE', 'CARDIO', 'PRINCIPIANTE'),
('Curl de bíceps con mancuernas', 'Ejercicio de aislamiento para bíceps', 'FUERZA', 'PRINCIPIANTE', 'BICEPS', 'PRINCIPIANTE'),
('Fondos en banco (Dips)', 'Ejercicio para tríceps y pecho', 'FUERZA', 'INTERMEDIO', 'TRICEPS', 'INTERMEDIO'),
('Sentadilla con salto (Jump Squats)', 'Ejercicio pliométrico para piernas', 'FUNCIONAL', 'INTERMEDIO', 'PIERNAS', 'INTERMEDIO'),
('Giros rusos (Russian Twists)', 'Ejercicio para oblicuos', 'FUERZA', 'INTERMEDIO', 'ABDOMINALES', 'INTERMEDIO'),
('Elevación de piernas', 'Ejercicio para abdomen bajo', 'FUERZA', 'INTERMEDIO', 'ABDOMINALES', 'INTERMEDIO')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- VERIFICACIÓN
-- ============================================================================

SELECT 
    'Catálogo Básico Cargado' as mensaje,
    (SELECT COUNT(*) FROM ingredientes) as ingredientes,
    (SELECT COUNT(*) FROM comidas) as comidas,
    (SELECT COUNT(*) FROM ejercicios) as ejercicios,
    (SELECT COUNT(*) FROM recetas) as recetas;

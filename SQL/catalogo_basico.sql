-- ============================================================================
-- CATÁLOGO BÁSICO - Compatible con NutriDB.sql
-- Datos mínimos para pruebas de Módulos 4 y 5
-- ============================================================================

-- ============================================================================
-- INGREDIENTES BÁSICOS
-- ============================================================================

INSERT INTO ingredientes (nombre, proteinas, carbohidratos, grasas, energia, fibra, categoria_alimento, descripcion) VALUES
('Pollo', 31.00, 0.00, 3.60, 165.00, 0.00, 'PROTEINAS', 'Pechuga de pollo sin piel, fuente magra de proteína'),
('Arroz integral', 7.90, 77.20, 2.90, 370.00, 3.50, 'CEREALES', 'Arroz integral cocido, carbohidrato complejo'),
('Avena', 16.90, 66.30, 6.90, 389.00, 10.60, 'CEREALES', 'Avena en hojuelas, rica en fibra'),
('Plátano', 1.10, 22.80, 0.30, 89.00, 2.60, 'FRUTAS', 'Plátano maduro, fuente de potasio'),
('Almendras', 21.20, 21.60, 49.90, 579.00, 12.50, 'FRUTOS_SECOS', 'Almendras naturales, grasas saludables'),
('Yogur', 3.50, 4.70, 3.30, 59.00, 0.00, 'LACTEOS', 'Yogur griego natural sin azúcar'),
('Pescado', 22.00, 0.00, 12.00, 206.00, 0.00, 'PROTEINAS', 'Salmón fresco, rico en omega-3'),
('Verduras mix', 2.00, 5.00, 0.20, 25.00, 2.80, 'VERDURAS', 'Mezcla de verduras frescas variadas'),
('Huevos', 13.00, 1.10, 11.00, 155.00, 0.00, 'PROTEINAS', 'Huevos enteros frescos'),
('Pan integral', 13.00, 41.00, 3.50, 247.00, 7.00, 'CEREALES', 'Pan de trigo integral'),
('Nueces', 15.20, 13.70, 65.20, 654.00, 6.70, 'FRUTOS_SECOS', 'Nueces sin sal, grasas omega-3'),
('Proteína en polvo', 25.00, 3.00, 1.50, 120.00, 0.00, 'PROTEINAS', 'Proteína whey aislada')
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

INSERT INTO ejercicios (nombre, descripcion, tipo_ejercicio, grupo_muscular, nivel_dificultad, calorias_quemadas_por_minuto, duracion_estimada_minutos, equipo_necesario) VALUES
('Burpees', 'Ejercicio completo de cuerpo que combina sentadilla, plancha y salto vertical', 'CARDIO', 'CUERPO_COMPLETO', 'INTERMEDIO', 12.50, 15, 'Ninguno'),
('Mountain Climbers', 'Ejercicio cardiovascular que trabaja core y piernas en posición de plancha', 'CARDIO', 'CORE', 'INTERMEDIO', 10.00, 10, 'Ninguno'),
('Plancha (Plank)', 'Ejercicio isométrico para fortalecer el core y estabilidad', 'FUERZA', 'CORE', 'PRINCIPIANTE', 5.00, 5, 'Colchoneta'),
('Sentadillas (Squats)', 'Ejercicio fundamental para piernas y glúteos, fortalece tren inferior', 'FUERZA', 'PIERNAS', 'PRINCIPIANTE', 8.00, 15, 'Barra y discos (opcional)'),
('Flexiones de pecho (Push-ups)', 'Ejercicio para pecho, hombros y tríceps usando peso corporal', 'FUERZA', 'PECHO', 'PRINCIPIANTE', 7.00, 10, 'Ninguno'),
('Dominadas (Pull-ups)', 'Ejercicio para espalda y bíceps colgando de barra', 'FUERZA', 'ESPALDA', 'AVANZADO', 10.00, 10, 'Barra de dominadas'),
('Zancadas (Lunges)', 'Ejercicio para piernas y equilibrio con paso adelante', 'FUERZA', 'PIERNAS', 'PRINCIPIANTE', 6.00, 12, 'Mancuernas (opcional)'),
('Saltos de tijera (Jumping Jacks)', 'Ejercicio cardiovascular básico con coordinación', 'CARDIO', 'CARDIO', 'PRINCIPIANTE', 8.00, 10, 'Ninguno'),
('Abdominales (Crunches)', 'Ejercicio para abdomen superior con flexión de tronco', 'FUERZA', 'ABDOMINALES', 'PRINCIPIANTE', 4.00, 10, 'Colchoneta'),
('Trote en el lugar (Jogging in Place)', 'Cardio de bajo impacto elevando rodillas', 'CARDIO', 'CARDIO', 'PRINCIPIANTE', 7.00, 20, 'Ninguno'),
('Curl de bíceps con mancuernas', 'Ejercicio de aislamiento para bíceps con flexión de codo', 'FUERZA', 'BICEPS', 'PRINCIPIANTE', 4.00, 10, 'Mancuernas'),
('Fondos en banco (Dips)', 'Ejercicio para tríceps y pecho usando banco', 'FUERZA', 'TRICEPS', 'INTERMEDIO', 6.00, 10, 'Banco o silla'),
('Sentadilla con salto (Jump Squats)', 'Ejercicio pliométrico para piernas con explosividad', 'FUNCIONAL', 'PIERNAS', 'INTERMEDIO', 10.00, 12, 'Ninguno'),
('Giros rusos (Russian Twists)', 'Ejercicio para oblicuos con rotación de torso', 'FUERZA', 'ABDOMINALES', 'INTERMEDIO', 5.00, 10, 'Disco o mancuerna'),
('Elevación de piernas', 'Ejercicio para abdomen bajo elevando piernas', 'FUERZA', 'ABDOMINALES', 'INTERMEDIO', 4.50, 10, 'Colchoneta')
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

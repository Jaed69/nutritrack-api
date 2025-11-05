-- Migration: Agregar columna nivel_dificultad a tabla rutinas
-- Fecha: 2025-11-05
-- Descripción: Agrega la columna nivel_dificultad que faltaba en la tabla rutinas

ALTER TABLE rutinas 
ADD COLUMN nivel_dificultad VARCHAR(50);

-- Actualizar valores existentes con un valor por defecto
UPDATE rutinas 
SET nivel_dificultad = 'INTERMEDIO' 
WHERE nivel_dificultad IS NULL;

-- Comentario en la columna
COMMENT ON COLUMN rutinas.nivel_dificultad IS 'Nivel de dificultad de la rutina (PRINCIPIANTE, INTERMEDIO, AVANZADO)';

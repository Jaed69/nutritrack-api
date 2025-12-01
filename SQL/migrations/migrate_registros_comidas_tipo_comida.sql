-- Migration: Actualizar registros_comidas para usar tipos_comida dinámicos
-- Fecha: 2025-01-XX
-- Descripción: Migra la columna tipo_comida de VARCHAR a referencia FK a tipos_comida

-- Paso 1: Agregar la nueva columna id_tipo_comida
ALTER TABLE registros_comidas 
ADD COLUMN id_tipo_comida BIGINT;

-- Paso 2: Migrar datos existentes basándose en los nombres
UPDATE registros_comidas rc
SET id_tipo_comida = tc.id
FROM tipos_comida tc
WHERE UPPER(rc.tipo_comida) = UPPER(tc.nombre);

-- Paso 3: Para cualquier valor que no coincida, intentar coincidencia parcial
UPDATE registros_comidas rc
SET id_tipo_comida = (
    SELECT tc.id FROM tipos_comida tc 
    WHERE UPPER(tc.nombre) LIKE '%' || UPPER(rc.tipo_comida) || '%'
    LIMIT 1
)
WHERE rc.id_tipo_comida IS NULL AND rc.tipo_comida IS NOT NULL;

-- Paso 4: Si aún hay registros sin migrar, asignar a "Otro" o crear el tipo
INSERT INTO tipos_comida (nombre, descripcion, orden, activo, created_at)
SELECT DISTINCT rc.tipo_comida, 'Migrado automáticamente', 99, true, NOW()
FROM registros_comidas rc
WHERE rc.id_tipo_comida IS NULL 
  AND rc.tipo_comida IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM tipos_comida tc WHERE UPPER(tc.nombre) = UPPER(rc.tipo_comida)
  );

-- Actualizar los registros que faltan después de crear los tipos
UPDATE registros_comidas rc
SET id_tipo_comida = tc.id
FROM tipos_comida tc
WHERE rc.id_tipo_comida IS NULL 
  AND rc.tipo_comida IS NOT NULL
  AND UPPER(rc.tipo_comida) = UPPER(tc.nombre);

-- Paso 5: Eliminar el CHECK constraint antiguo
ALTER TABLE registros_comidas 
DROP CONSTRAINT IF EXISTS registros_comidas_tipo_comida_check;

-- Paso 6: Eliminar la columna tipo_comida antigua
ALTER TABLE registros_comidas 
DROP COLUMN IF EXISTS tipo_comida;

-- Paso 7: Agregar la FK constraint
ALTER TABLE registros_comidas 
ADD CONSTRAINT fk_registros_comidas_tipo_comida 
FOREIGN KEY (id_tipo_comida) REFERENCES tipos_comida(id);

-- Paso 8: Crear índice para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_registros_comidas_tipo_comida 
ON registros_comidas(id_tipo_comida);

-- Comentario en la columna
COMMENT ON COLUMN registros_comidas.id_tipo_comida IS 'Referencia al tipo de comida dinámico';

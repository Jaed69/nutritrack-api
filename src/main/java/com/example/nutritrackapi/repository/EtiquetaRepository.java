package com.example.nutritrackapi.repository;

import com.example.nutritrackapi.model.Etiqueta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EtiquetaRepository extends JpaRepository<Etiqueta, Long> {

    /**
     * Buscar etiqueta por nombre (nombre es único)
     */
    Optional<Etiqueta> findByNombre(String nombre);

    /**
     * Verificar si existe una etiqueta con el nombre dado
     */
    boolean existsByNombre(String nombre);

    /**
     * Buscar etiquetas por tipo
     */
    List<Etiqueta> findByTipoEtiqueta(Etiqueta.TipoEtiqueta tipoEtiqueta);

    /**
     * Verificar si una etiqueta está en uso en alguna tabla relacionada
     * Usado para validar RN08: No eliminar etiquetas en uso
     */
    @Query("""
        SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END
        FROM Etiqueta e
        WHERE e.id = :etiquetaId
        AND EXISTS (
            SELECT 1 FROM UsuarioEtiquetasSalud ues WHERE ues.etiqueta.id = :etiquetaId
        )
        """)
    boolean isEtiquetaEnUso(Long etiquetaId);
}

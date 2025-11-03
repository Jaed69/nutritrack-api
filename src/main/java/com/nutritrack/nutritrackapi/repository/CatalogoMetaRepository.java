package com.nutritrack.nutritrackapi.repository;

import com.nutritrack.nutritrackapi.model.CatalogoMeta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CatalogoMetaRepository extends JpaRepository<CatalogoMeta, Long> {

    // RN11: Validar que no existan metas duplicadas por nombre
    Optional<CatalogoMeta> findByNombreIgnoreCase(String nombre);

    // RN14: Verificar si una meta tiene usuarios activos antes de eliminarla
    @Query("""
        SELECT COUNT(u) > 0 
        FROM UsuarioMetaAsignada u 
        WHERE u.catalogoMeta.id = :idMeta 
        AND u.estado = com.nutritrack.nutritrackapi.model.enums.EstadoMeta.ACTIVO
    """)
    boolean existsMetaConUsuariosActivos(Long idMeta);
}

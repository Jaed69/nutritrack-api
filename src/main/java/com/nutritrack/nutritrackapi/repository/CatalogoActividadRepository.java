package com.nutritrack.nutritrackapi.repository;

import com.nutritrack.nutritrackapi.model.CatalogoActividad;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CatalogoActividadRepository extends JpaRepository<CatalogoActividad, Long> {

    // Obtener todas las actividades de una meta específica
    List<CatalogoActividad> findByCatalogoMeta_Id(Long idCatalogoMeta);

    // Validar si existen actividades asociadas a una meta
    @Query("""
        SELECT COUNT(a) > 0 
        FROM CatalogoActividad a 
        WHERE a.catalogoMeta.id = :idCatalogoMeta
    """)
    boolean existsByCatalogoMeta(Long idCatalogoMeta);
}

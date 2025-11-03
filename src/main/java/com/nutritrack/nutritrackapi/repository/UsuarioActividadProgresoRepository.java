package com.nutritrack.nutritrackapi.repository;

import com.nutritrack.nutritrackapi.model.UsuarioActividadProgreso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioActividadProgresoRepository extends JpaRepository<UsuarioActividadProgreso, Long> {

    // RN20: Obtener las actividades completadas por una meta asignada
    @Query("""
        SELECT u 
        FROM UsuarioActividadProgreso u 
        WHERE u.metaAsignada.id = :idMetaAsignada 
        AND u.actividadAcabada = true
    """)
    List<UsuarioActividadProgreso> findActividadesCompletadas(Long idMetaAsignada);

    // RN21 (Soporte): Contar actividades completadas de una meta
    @Query("""
        SELECT COUNT(u) 
        FROM UsuarioActividadProgreso u 
        WHERE u.metaAsignada.id = :idMetaAsignada
        AND u.actividadAcabada = true
    """)
    long countActividadesCompletadas(Long idMetaAsignada);
}

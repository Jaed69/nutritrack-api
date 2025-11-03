package com.nutritrack.nutritrackapi.repository;

import com.nutritrack.nutritrackapi.model.UsuarioMetaAsignada;
import com.nutritrack.nutritrackapi.model.enums.EstadoMeta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UsuarioMetaAsignadaRepository extends JpaRepository<UsuarioMetaAsignada, Long> {

    // RN17: Validar si un cliente ya tiene una meta activa
    @Query("""
        SELECT COUNT(m) > 0 
        FROM UsuarioMetaAsignada m 
        WHERE m.idCliente = :idCliente 
        AND m.estado = com.nutritrack.nutritrackapi.model.enums.EstadoMeta.ACTIVO
    """)
    boolean existsMetaActivaByCliente(UUID idCliente);

    // Obtener todas las metas activas o no activas de un cliente
    List<UsuarioMetaAsignada> findByIdCliente(UUID idCliente);

    Optional<UsuarioMetaAsignada> findByIdClienteAndEstado(UUID idCliente, EstadoMeta estado);
}

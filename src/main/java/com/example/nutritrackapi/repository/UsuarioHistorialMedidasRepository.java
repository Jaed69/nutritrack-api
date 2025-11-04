package com.example.nutritrackapi.repository;

import com.example.nutritrackapi.model.UsuarioHistorialMedidas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioHistorialMedidasRepository extends JpaRepository<UsuarioHistorialMedidas, Long> {

    /**
     * Buscar historial de medidas de un usuario ordenado por fecha descendente
     */
    List<UsuarioHistorialMedidas> findByPerfilUsuarioIdOrderByFechaMedicionDesc(Long perfilUsuarioId);

    /**
     * Buscar historial de medidas de un usuario ordenado por fecha ascendente
     */
    List<UsuarioHistorialMedidas> findByPerfilUsuarioIdOrderByFechaMedicionAsc(Long perfilUsuarioId);

    /**
     * Buscar la medida más reciente de un usuario
     */
    Optional<UsuarioHistorialMedidas> findFirstByPerfilUsuarioIdOrderByFechaMedicionDesc(Long perfilUsuarioId);

    /**
     * Buscar medidas en un rango de fechas
     */
    List<UsuarioHistorialMedidas> findByPerfilUsuarioIdAndFechaMedicionBetween(
        Long perfilUsuarioId, 
        LocalDate fechaInicio, 
        LocalDate fechaFin
    );

    /**
     * Contar mediciones de un usuario (para RN23: gráfico requiere 2+ registros)
     */
    long countByPerfilUsuarioId(Long perfilUsuarioId);

    /**
     * Verificar si existe medición para un usuario en una fecha específica
     */
    boolean existsByPerfilUsuarioIdAndFechaMedicion(Long perfilUsuarioId, LocalDate fechaMedicion);

    /**
     * Obtener peso promedio de un usuario en un período
     */
    @Query("""
        SELECT AVG(m.peso)
        FROM UsuarioHistorialMedidas m
        WHERE m.perfilUsuario.id = :perfilUsuarioId
        AND m.fechaMedicion BETWEEN :fechaInicio AND :fechaFin
        """)
    Double calcularPesoPromedio(Long perfilUsuarioId, LocalDate fechaInicio, LocalDate fechaFin);
}

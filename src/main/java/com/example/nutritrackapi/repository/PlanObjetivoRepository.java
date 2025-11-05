package com.example.nutritrackapi.repository;

import com.example.nutritrackapi.model.PlanObjetivo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repositorio para la entidad PlanObjetivo
 * US-11: Crear Meta del Catálogo
 * US-12: Gestionar Meta
 */
@Repository
public interface PlanObjetivoRepository extends JpaRepository<PlanObjetivo, Long> {

    /**
     * Busca objetivo por plan
     */
    Optional<PlanObjetivo> findByPlanId(Long planId);

    /**
     * Verifica si un plan ya tiene objetivos
     */
    boolean existsByPlanId(Long planId);
}

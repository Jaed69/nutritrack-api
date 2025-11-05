package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Entidad PlanObjetivo - Objetivos nutricionales DIARIOS del plan
 * Relación 1-to-1 con Plan
 * 
 * Define las metas diarias de macronutrientes y calorías.
 * US-11: Crear Meta del Catálogo
 * US-12: Gestionar Meta
 */
@Entity
@Table(name = "plan_objetivos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlanObjetivo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Objetivo diario de calorías
     */
    @Column(name = "calorias_objetivo", precision = 8, scale = 2)
    private BigDecimal caloriasObjetivo;

    /**
     * Objetivo diario de proteínas en gramos
     */
    @Column(name = "proteinas_objetivo", precision = 6, scale = 2)
    private BigDecimal proteinasObjetivo;

    /**
     * Objetivo diario de carbohidratos en gramos
     */
    @Column(name = "carbohidratos_objetivo", precision = 6, scale = 2)
    private BigDecimal carbohidratosObjetivo;

    /**
     * Objetivo diario de grasas en gramos
     */
    @Column(name = "grasas_objetivo", precision = 6, scale = 2)
    private BigDecimal grasasObjetivo;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    /**
     * Relación 1-to-1 con Plan
     */
    @OneToOne
    @JoinColumn(name = "id_plan", nullable = false, unique = true)
    private Plan plan;

    @Override
    public String toString() {
        return "PlanObjetivo{id=" + id + 
               ", calorias=" + caloriasObjetivo + 
               ", proteinas=" + proteinasObjetivo + 
               ", carbohidratos=" + carbohidratosObjetivo + 
               ", grasas=" + grasasObjetivo + "}";
    }
}

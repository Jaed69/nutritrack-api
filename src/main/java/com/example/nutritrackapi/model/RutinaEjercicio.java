package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Entidad RutinaEjercicio - Ejercicios programados en una rutina
 * Define QUÉ EJERCICIOS HACER con configuración específica (series, reps, peso)
 * 
 * US-12: Gestionar Meta (configurar ejercicios)
 * US-15: Ensamblar Rutinas
 * RN13: Series y repeticiones deben ser valores numéricos positivos
 */
@Entity
@Table(name = "rutina_ejercicios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RutinaEjercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Orden de ejecución del ejercicio (1, 2, 3...)
     */
    @Column(nullable = false)
    private Integer orden;

    /**
     * RN13: Número de series (valor positivo)
     */
    @Column(nullable = false)
    private Integer series;

    /**
     * RN13: Número de repeticiones por serie (valor positivo)
     */
    @Column(nullable = false)
    private Integer repeticiones;

    /**
     * Peso sugerido en kg o lbs (opcional)
     */
    @Column(precision = 6, scale = 2)
    private BigDecimal peso;

    /**
     * Duración total del ejercicio en minutos
     */
    @Column(name = "duracion_minutos")
    private Integer duracionMinutos;

    /**
     * Tiempo de descanso entre series en segundos
     */
    @Column(name = "descanso_segundos")
    private Integer descansoSegundos;

    /**
     * Notas adicionales (ej: "Bajar hasta 90 grados", "Descanso 90 segundos")
     */
    @Column(columnDefinition = "TEXT")
    private String notas;

    /**
     * Relación many-to-1 con Ejercicio
     * Qué ejercicio del catálogo se debe realizar
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ejercicio", nullable = false)
    private Ejercicio ejercicio;

    /**
     * Relación many-to-1 con Rutina
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_rutina", nullable = false)
    private Rutina rutina;

    @Override
    public String toString() {
        return "RutinaEjercicio{id=" + id + 
               ", orden=" + orden + 
               ", series=" + series + 
               ", reps=" + repeticiones + 
               ", ejercicio=" + (ejercicio != null ? ejercicio.getNombre() : "null") + "}";
    }
}

package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entidad Etiqueta - Tabla maestra de categorización del sistema
 * Soporta 7 tipos diferentes de clasificación:
 * - ALERGIA: Gluten, Lactosa, Maní
 * - CONDICION_MEDICA: Diabetes, Hipertensión, Celíaco
 * - OBJETIVO: Pérdida de peso, Ganancia muscular
 * - DIETA: Vegana, Vegetariana, Keto, Paleo
 * - DIFICULTAD: Principiante, Intermedio, Avanzado
 * - GRUPO_MUSCULAR: Pecho, Espalda, Piernas
 * - TIPO_EJERCICIO: Cardio, Fuerza, HIIT, Yoga
 */
@Entity
@Table(name = "etiquetas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Etiqueta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String nombre;

    @Column(name = "tipo_etiqueta", nullable = false, length = 50)
    @Enumerated(EnumType.STRING)
    private TipoEtiqueta tipoEtiqueta;

    @Column(length = 500)
    private String descripcion;

    /**
     * Enum de tipos de etiqueta según arquitectura del sistema
     */
    public enum TipoEtiqueta {
        ALERGIA,           // Alergias alimentarias
        CONDICION_MEDICA,  // Condiciones médicas del usuario
        OBJETIVO,          // Objetivos de salud/fitness
        DIETA,             // Tipos de dieta
        DIFICULTAD,        // Nivel de dificultad
        GRUPO_MUSCULAR,    // Grupos musculares trabajados
        TIPO_EJERCICIO     // Tipo de ejercicio
    }
}

package com.example.nutritrackapi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO de respuesta para ejercicios del día de la rutina.
 * Módulo 5: US-21 - Ver Actividades de mi Plan
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EjerciciosDiaResponse {

    private java.time.LocalDate fecha;
    private Integer diaSemana;        // 1=Lunes, 7=Domingo
    private String nombreDia;          // "Lunes", "Martes", etc.
    private Integer semanaActual;      // Semana desde el inicio de la rutina
    private Integer semanaBase;        // Semana del patrón (1, 2, etc.)
    private List<EjercicioDiaInfo> ejercicios;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EjercicioDiaInfo {
        private Long ejercicioId;
        private String nombre;
        private Integer seriesObjetivo;
        private Integer repeticionesObjetivo;
        private java.math.BigDecimal pesoSugerido;
        private Integer duracionMinutos;
        private Integer descansoSegundos;  // Tiempo de descanso entre series
        private String notas;              // Notas del ejercicio
        private boolean registrado;
        private Long registroId; // ID del registro si ya fue marcado
    }
}

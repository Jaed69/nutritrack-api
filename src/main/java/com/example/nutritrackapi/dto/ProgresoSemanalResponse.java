package com.example.nutritrackapi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO de respuesta para el progreso semanal de ejercicios.
 * Proporciona estadísticas detalladas de la actividad física semanal.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgresoSemanalResponse {

    private LocalDate inicioSemana;
    private LocalDate finSemana;
    
    // Estadísticas generales de la semana
    private int ejerciciosCompletados;
    private int ejerciciosProgramados;
    private double porcentajeCumplimiento;
    private BigDecimal caloriasQuemadasTotal;
    private int tiempoTotalMinutos;
    
    // Detalle por día
    private List<DiaSemanaInfo> diasSemana;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaSemanaInfo {
        private LocalDate fecha;
        private String diaSemana;
        private int ejerciciosCompletados;
        private BigDecimal caloriasQuemadas;
        private int tiempoMinutos;
    }
}

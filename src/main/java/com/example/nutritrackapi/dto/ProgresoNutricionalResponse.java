package com.example.nutritrackapi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO para progreso nutricional semanal.
 * Muestra estadísticas de consumo vs objetivos.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgresoNutricionalResponse {
    
    private LocalDate inicioSemana;
    private LocalDate finSemana;
    private String nombrePlan;
    
    // Objetivos semanales (objetivo diario × 7)
    private BigDecimal caloriasObjetivoSemanal;
    private BigDecimal proteinasObjetivoSemanal;
    private BigDecimal carbohidratosObjetivoSemanal;
    private BigDecimal grasasObjetivoSemanal;
    
    // Consumo real de la semana
    private BigDecimal caloriasConsumidasSemanal;
    private BigDecimal proteinasConsumidasSemanal;
    private BigDecimal carbohidratosConsumidosSemanal;
    private BigDecimal grasasConsumidasSemanal;
    
    // Porcentajes de cumplimiento
    private BigDecimal porcentajeCaloriasCumplido;
    private BigDecimal porcentajeProteinasCumplido;
    private BigDecimal porcentajeCarbohidratosCumplido;
    private BigDecimal porcentajeGrasasCumplido;
    
    // Promedios diarios
    private BigDecimal caloriasPromedioDiario;
    private BigDecimal proteinasPromedioDiario;
    private BigDecimal carbohidratosPromedioDiario;
    private BigDecimal grasasPromedioDiario;
    
    // Estadísticas de cumplimiento
    private Integer diasConRegistro;
    private Integer comidasRegistradas;
    private Integer comidasProgramadas;
    private BigDecimal porcentajeComidasCumplido;
    
    // Desglose por día
    private List<DiaNutricional> diasSemana;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaNutricional {
        private LocalDate fecha;
        private String nombreDia;
        private Integer diaSemana;
        
        // Objetivos del día
        private BigDecimal caloriasObjetivo;
        private BigDecimal proteinasObjetivo;
        private BigDecimal carbohidratosObjetivo;
        private BigDecimal grasasObjetivo;
        
        // Consumo del día
        private BigDecimal caloriasConsumidas;
        private BigDecimal proteinasConsumidas;
        private BigDecimal carbohidratosConsumidos;
        private BigDecimal grasasConsumidas;
        
        // Cumplimiento
        private Integer comidasRegistradas;
        private Integer comidasProgramadas;
        private boolean diaCompleto;
    }
}

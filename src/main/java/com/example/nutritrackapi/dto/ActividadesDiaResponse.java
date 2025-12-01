package com.example.nutritrackapi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO de respuesta para actividades del día del plan.
 * Módulo 5: US-21 - Ver Actividades de mi Plan
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActividadesDiaResponse {

    private LocalDate fecha;
    private Integer diaSemana;        // 1=Lunes, 7=Domingo
    private String nombreDia;          // "Lunes", "Martes", etc.
    private Integer diaActual;         // Día desde el inicio del plan (puede ser > duracionDias)
    private Integer diaPlan;           // Día del plan (1 a duracionDias, cíclico)
    private Integer duracionDias;      // Duración total del plan
    private String nombrePlan;         // Nombre del plan activo
    
    // Objetivos del día
    private BigDecimal caloriasObjetivo;
    private BigDecimal proteinasObjetivo;
    private BigDecimal carbohidratosObjetivo;
    private BigDecimal grasasObjetivo;
    
    // Consumo del día (lo que ya ha registrado)
    private BigDecimal caloriasConsumidas;
    private BigDecimal proteinasConsumidas;
    private BigDecimal carbohidratosConsumidos;
    private BigDecimal grasasConsumidas;
    
    // Totales del plan para el día (suma de todas las comidas programadas)
    private BigDecimal caloriasPlanificadas;
    private BigDecimal proteinasPlanificadas;
    private BigDecimal carbohidratosPlanificados;
    private BigDecimal grasasPlanificadas;
    
    private List<ComidaDiaInfo> comidas;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ComidaDiaInfo {
        private Long comidaId;
        private String nombre;
        private String tipoComida;
        private Long tipoComidaId;
        
        // Información nutricional de la comida
        private BigDecimal calorias;
        private BigDecimal proteinas;
        private BigDecimal carbohidratos;
        private BigDecimal grasas;
        
        // Información adicional
        private String descripcion;
        private Integer tiempoPreparacionMinutos;
        private Integer porciones;
        private String notas;          // Notas de la comida del plan
        
        // Estado de registro
        private boolean registrada;
        private Long registroId;       // ID del registro si ya fue marcada
        
        // Ingredientes de la comida
        private List<IngredienteInfo> ingredientes;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class IngredienteInfo {
        private Long ingredienteId;
        private String nombre;
        private BigDecimal cantidadGramos;
        private BigDecimal calorias;
        private BigDecimal proteinas;
        private BigDecimal carbohidratos;
        private BigDecimal grasas;
        private String notas;
    }
}

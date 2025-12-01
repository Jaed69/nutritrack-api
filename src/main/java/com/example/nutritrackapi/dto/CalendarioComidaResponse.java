package com.example.nutritrackapi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO para vista de calendario de comidas.
 * Muestra un rango de días con sus comidas y estado de cumplimiento.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalendarioComidaResponse {
    
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String nombrePlan;
    private Integer duracionPlanDias;
    
    // Estadísticas generales del período
    private Integer diasConRegistros;
    private Integer totalComidasProgramadas;
    private Integer totalComidasCompletadas;
    private BigDecimal porcentajeCumplimiento;
    
    // Totales de nutrición del período
    private BigDecimal caloriasConsumidasTotal;
    private BigDecimal proteinasConsumidasTotal;
    private BigDecimal carbohidratosConsumidosTotal;
    private BigDecimal grasasConsumidasTotal;
    
    // Lista de días con sus comidas
    private List<DiaCalendario> dias;
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaCalendario {
        private LocalDate fecha;
        private Integer diaSemana;          // 1=Lunes, 7=Domingo
        private String nombreDia;
        private Integer diaPlan;            // Día dentro del ciclo del plan
        
        // Estadísticas del día
        private Integer comidasProgramadas;
        private Integer comidasCompletadas;
        private boolean diaCompleto;        // true si todas las comidas fueron registradas
        
        // Nutrición del día
        private BigDecimal caloriasObjetivo;
        private BigDecimal caloriasConsumidas;
        private BigDecimal proteinasConsumidas;
        private BigDecimal carbohidratosConsumidos;
        private BigDecimal grasasConsumidas;
        
        // Lista de comidas del día (resumen)
        private List<ComidaResumen> comidas;
    }
    
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ComidaResumen {
        private Long comidaId;
        private String nombre;
        private String tipoComida;
        private Long tipoComidaId;
        private BigDecimal calorias;
        private boolean registrada;
        private Long registroId;
    }
}

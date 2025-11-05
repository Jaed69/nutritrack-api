package com.example.nutritrackapi.dto;

import com.example.nutritrackapi.model.Plan;
import com.example.nutritrackapi.model.PlanObjetivo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * DTO de respuesta para planes nutricionales
 * US-11: Crear Meta del Catálogo
 * US-13: Ver Catálogo de Metas
 * US-17: Ver Detalle de Meta
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Información completa de un plan nutricional")
public class PlanResponse {

    @Schema(description = "ID del plan", example = "1")
    private Long id;

    @Schema(description = "Nombre del plan", example = "Plan Pérdida de Peso 30 días")
    private String nombre;

    @Schema(description = "Descripción del plan")
    private String descripcion;

    @Schema(description = "Duración en días", example = "30")
    private Integer duracionDias;

    @Schema(description = "Si el plan está activo (RN28: soft delete)", example = "true")
    private Boolean activo;

    @Schema(description = "Objetivos nutricionales diarios")
    private PlanObjetivoResponse objetivo;

    @Schema(description = "Etiquetas del plan")
    private Set<EtiquetaResponse> etiquetas;

    @Schema(description = "Fecha de creación")
    private LocalDateTime createdAt;

    @Schema(description = "Fecha de última actualización")
    private LocalDateTime updatedAt;

    @Schema(description = "Número total de días programados")
    private Integer totalDiasProgramados;

    /**
     * Convierte una entidad Plan a DTO
     */
    public static PlanResponse fromEntity(Plan plan) {
        PlanResponseBuilder builder = PlanResponse.builder()
                .id(plan.getId())
                .nombre(plan.getNombre())
                .descripcion(plan.getDescripcion())
                .duracionDias(plan.getDuracionDias())
                .activo(plan.getActivo())
                .etiquetas(plan.getEtiquetas().stream()
                        .map(EtiquetaResponse::fromEntity)
                        .collect(Collectors.toSet()))
                .createdAt(plan.getCreatedAt())
                .updatedAt(plan.getUpdatedAt());

        // Agregar objetivo si existe
        if (plan.getObjetivo() != null) {
            builder.objetivo(PlanObjetivoResponse.fromEntity(plan.getObjetivo()));
        }

        // Contar días programados
        if (plan.getDias() != null) {
            builder.totalDiasProgramados(plan.getDias().size());
        }

        return builder.build();
    }

    /**
     * DTO para objetivos del plan
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Objetivos nutricionales diarios del plan")
    public static class PlanObjetivoResponse {
        @Schema(description = "Calorías diarias objetivo", example = "1500.0")
        private BigDecimal caloriasObjetivo;

        @Schema(description = "Proteínas diarias objetivo (g)", example = "120.0")
        private BigDecimal proteinasObjetivo;

        @Schema(description = "Carbohidratos diarios objetivo (g)", example = "150.0")
        private BigDecimal carbohidratosObjetivo;

        @Schema(description = "Grasas diarias objetivo (g)", example = "50.0")
        private BigDecimal grasasObjetivo;

        @Schema(description = "Descripción de los objetivos")
        private String descripcion;

        public static PlanObjetivoResponse fromEntity(PlanObjetivo objetivo) {
            return PlanObjetivoResponse.builder()
                    .caloriasObjetivo(objetivo.getCaloriasObjetivo())
                    .proteinasObjetivo(objetivo.getProteinasObjetivo())
                    .carbohidratosObjetivo(objetivo.getCarbohidratosObjetivo())
                    .grasasObjetivo(objetivo.getGrasasObjetivo())
                    .descripcion(objetivo.getDescripcion())
                    .build();
        }
    }
}

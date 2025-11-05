package com.example.nutritrackapi.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Set;

/**
 * DTO para crear o actualizar un plan nutricional
 * US-11: Crear Meta del Catálogo (Plan)
 * US-12: Gestionar Meta
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Datos para crear o actualizar un plan nutricional")
public class PlanRequest {

    @NotBlank(message = "El nombre es obligatorio")
    @Size(min = 3, max = 255, message = "El nombre debe tener entre 3 y 255 caracteres")
    @Schema(description = "Nombre del plan (RN11: debe ser único)", 
            example = "Plan Pérdida de Peso 30 días", required = true)
    private String nombre;

    @Size(max = 2000, message = "La descripción no puede exceder 2000 caracteres")
    @Schema(description = "Descripción del plan", 
            example = "Plan nutricional diseñado para perder peso de forma saludable")
    private String descripcion;

    @NotNull(message = "La duración en días es obligatoria")
    @Min(value = 1, message = "La duración debe ser al menos 1 día")
    @Max(value = 365, message = "La duración no puede exceder 365 días")
    @Schema(description = "Duración del plan en días", example = "30", required = true)
    private Integer duracionDias;

    @Valid
    @NotNull(message = "Los objetivos nutricionales son obligatorios")
    @Schema(description = "Objetivos nutricionales diarios del plan", required = true)
    private PlanObjetivoRequest objetivo;

    @Schema(description = "IDs de etiquetas para clasificar el plan (RN12: solo etiquetas existentes)", 
            example = "[1, 2, 3]")
    private Set<Long> etiquetaIds;

    /**
     * DTO anidado para los objetivos del plan
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Objetivos nutricionales DIARIOS del plan")
    public static class PlanObjetivoRequest {

        @NotNull(message = "Las calorías objetivo son obligatorias")
        @DecimalMin(value = "500.0", message = "Las calorías deben ser al menos 500")
        @DecimalMax(value = "10000.0", message = "Las calorías no pueden exceder 10000")
        @Schema(description = "Objetivo diario de calorías", example = "1500.0", required = true)
        private BigDecimal caloriasObjetivo;

        @DecimalMin(value = "0.0", message = "Las proteínas no pueden ser negativas")
        @DecimalMax(value = "500.0", message = "Las proteínas no pueden exceder 500g")
        @Schema(description = "Objetivo diario de proteínas en gramos", example = "120.0")
        private BigDecimal proteinasObjetivo;

        @DecimalMin(value = "0.0", message = "Los carbohidratos no pueden ser negativos")
        @DecimalMax(value = "1000.0", message = "Los carbohidratos no pueden exceder 1000g")
        @Schema(description = "Objetivo diario de carbohidratos en gramos", example = "150.0")
        private BigDecimal carbohidratosObjetivo;

        @DecimalMin(value = "0.0", message = "Las grasas no pueden ser negativas")
        @DecimalMax(value = "300.0", message = "Las grasas no pueden exceder 300g")
        @Schema(description = "Objetivo diario de grasas en gramos", example = "50.0")
        private BigDecimal grasasObjetivo;

        @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
        @Schema(description = "Descripción de los objetivos", 
                example = "Déficit calórico moderado con alta proteína")
        private String descripcion;
    }
}

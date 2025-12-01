package com.example.nutritrackapi.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * DTO de request para registrar una comida.
 * Módulo 5: US-22 - Marcar Actividad como Completada
 * 
 * Nota: tipoComida puede enviarse como ID o como nombre (String)
 * para mayor flexibilidad con el frontend.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Registrar una comida consumida")
public class RegistroComidaRequest {

    @NotNull(message = "El ID de la comida es obligatorio")
    @Schema(description = "ID de la comida del catálogo (Ensalada de pollo)", example = "5", required = true)
    private Long comidaId;

    @Schema(description = "ID del plan activo (opcional)", example = "1")
    private Long usuarioPlanId;

    @NotNull(message = "La fecha es obligatoria")
    @Schema(description = "Fecha de la comida (YYYY-MM-DD)", example = "2025-11-05", required = true)
    private LocalDate fecha;

    @Schema(description = "Hora de la comida (HH:mm:ss)", example = "13:30:00")
    private LocalTime hora;

    @Schema(description = "ID del tipo de comida (opcional si se envía tipoComidaNombre)", example = "2")
    private Long tipoComidaId;

    @Schema(description = "Nombre del tipo de comida (DESAYUNO, ALMUERZO, etc.)", example = "ALMUERZO")
    private String tipoComidaNombre;

    @DecimalMin(value = "0.1", message = "Las porciones deben ser al menos 0.1")
    @Schema(description = "Número de porciones consumidas (mínimo 0.1)", example = "1.0")
    private BigDecimal porciones;

    @Size(max = 500, message = "Las notas no pueden exceder 500 caracteres")
    @Schema(description = "Notas adicionales", example = "Comida completa, muy sabrosa")
    private String notas;
}

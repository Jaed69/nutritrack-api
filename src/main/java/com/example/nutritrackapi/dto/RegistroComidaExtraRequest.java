package com.example.nutritrackapi.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * DTO para registrar comidas extra (no del plan).
 * Permite al usuario registrar comidas que no estaban programadas.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegistroComidaExtraRequest {
    
    // Opción 1: Comida del catálogo
    private Long comidaId;
    
    // Opción 2: Comida manual (si no existe en catálogo)
    private String nombreComida;
    private String descripcion;
    
    // Información nutricional manual (si comidaId es null)
    private BigDecimal calorias;
    private BigDecimal proteinas;
    private BigDecimal carbohidratos;
    private BigDecimal grasas;
    
    // Tipo de comida (requerido)
    private Long tipoComidaId;
    private String tipoComidaNombre;  // Alternativa: buscar por nombre
    
    // Fecha y hora
    private LocalDate fecha;          // Por defecto: hoy
    private LocalTime hora;           // Por defecto: ahora
    
    // Detalles adicionales
    @PositiveOrZero
    private BigDecimal porciones;     // Por defecto: 1
    
    private String notas;
}

package com.nutritrack.nutritrackapi.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record UsuarioMetaAsignadaRequestDTO(
        @NotNull(message = "El id del catálogo de meta es obligatorio")
        @Positive(message = "El id del catálogo de meta debe ser positivo")
        Long catalogGoalId
) {}

package com.nutritrack.nutritrackapi.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record EtiquetaMetaRequestDTO(
        @NotNull(message = "El id de la etiqueta es obligatorio")
        @Positive(message = "El id de la etiqueta debe ser positivo")
        Long tagId
) {}

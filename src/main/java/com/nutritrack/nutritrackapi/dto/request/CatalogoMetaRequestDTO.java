package com.nutritrack.nutritrackapi.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CatalogoMetaRequestDTO(
        @NotBlank(message = "El nombre de la meta es obligatorio")
        @Size(max = 255, message = "El nombre no debe superar los 255 caracteres")
        String nombre,

        @Size(max = 300, message = "La descripción no debe superar los 300 caracteres")
        String descripcion
) {}

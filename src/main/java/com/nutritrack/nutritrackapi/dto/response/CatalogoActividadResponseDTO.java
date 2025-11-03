package com.nutritrack.nutritrackapi.dto.response;

public record CatalogoActividadResponseDTO(
        Long idActividad,
        String nombre,
        boolean isCompleted
) {}

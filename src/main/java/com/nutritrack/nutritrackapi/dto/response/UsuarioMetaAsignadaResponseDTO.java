package com.nutritrack.nutritrackapi.dto.response;

import java.time.LocalDate;

public record UsuarioMetaAsignadaResponseDTO(
        Long idAsignacion,
        String estado,
        Long metaId,
        LocalDate fechaInicio,
        LocalDate fechaFin
) {}

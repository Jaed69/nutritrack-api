package com.nutritrack.nutritrackapi.controller;

import com.nutritrack.nutritrackapi.dto.response.UsuarioActividadProgresoResponseDTO;
import com.nutritrack.nutritrackapi.service.UsuarioActividadProgresoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v2/app/my-plan/activities")
@RequiredArgsConstructor
public class UsuarioActividadProgresoController {

    private final UsuarioActividadProgresoService usuarioActividadProgresoService;

    // ✅ Marcar Actividad como Completada
    @PostMapping("/{idActividad}/complete")
    public ResponseEntity<UsuarioActividadProgresoResponseDTO> completarActividad(
            @RequestParam Long idMetaAsignada,
            @PathVariable Long idActividad) {

        UsuarioActividadProgresoResponseDTO response =
                usuarioActividadProgresoService.completarActividad(idMetaAsignada, idActividad);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
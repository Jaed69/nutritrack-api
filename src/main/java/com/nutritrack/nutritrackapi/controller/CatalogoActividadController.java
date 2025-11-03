package com.nutritrack.nutritrackapi.controller;

import com.nutritrack.nutritrackapi.dto.response.CatalogoActividadResponseDTO;
import com.nutritrack.nutritrackapi.service.CatalogoActividadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v2/app/my-plan/activities")
@RequiredArgsConstructor
public class CatalogoActividadController {

    private final CatalogoActividadService catalogoActividadService;

    // ✅ Ver Actividades de Mi Plan
    @GetMapping
    public ResponseEntity<List<CatalogoActividadResponseDTO>> obtenerActividades(
            @RequestParam UUID idCliente) {

        List<CatalogoActividadResponseDTO> response =
                catalogoActividadService.obtenerActividadesPlan(idCliente);

        return ResponseEntity.ok(response);
    }
}

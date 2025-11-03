package com.nutritrack.nutritrackapi.controller;

import com.nutritrack.nutritrackapi.dto.request.UsuarioMetaAsignadaRequestDTO;
import com.nutritrack.nutritrackapi.dto.response.UsuarioMetaAsignadaResponseDTO;
import com.nutritrack.nutritrackapi.service.UsuarioMetaAsignadaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v2/app/my-plan")
@RequiredArgsConstructor
public class UsuarioMetaAsignadaController {

    private final UsuarioMetaAsignadaService usuarioMetaAsignadaService;

    // ✅ Activar Mi Plan
    @PostMapping
    public ResponseEntity<UsuarioMetaAsignadaResponseDTO> activarMiPlan(
            @RequestParam UUID idCliente,
            @Valid @RequestBody UsuarioMetaAsignadaRequestDTO request) {

        UsuarioMetaAsignadaResponseDTO response =
                usuarioMetaAsignadaService.activarMeta(idCliente, request);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}

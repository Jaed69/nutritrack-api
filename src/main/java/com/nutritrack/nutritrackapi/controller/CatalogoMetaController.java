package com.nutritrack.nutritrackapi.controller;

import com.nutritrack.nutritrackapi.dto.request.CatalogoMetaRequestDTO;
import com.nutritrack.nutritrackapi.dto.response.CatalogoMetaResponseDTO;
import com.nutritrack.nutritrackapi.dto.response.MessageResponseDTO;
import com.nutritrack.nutritrackapi.service.CatalogoMetaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v2")
@RequiredArgsConstructor
public class CatalogoMetaController {

    private final CatalogoMetaService catalogoMetaService;

    // ✅ Crear Meta Catálogo
    @PostMapping("/admin/catalog/goals")
    public ResponseEntity<CatalogoMetaResponseDTO> crearMetaCatalogo(
            @Valid @RequestBody CatalogoMetaRequestDTO request) {

        CatalogoMetaResponseDTO response = catalogoMetaService.crearMetaCatalogo(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // ✅ Eliminar Meta Catálogo
    @DeleteMapping("/admin/catalog/goals/{id}")
    public ResponseEntity<MessageResponseDTO> eliminarMetaCatalogo(@PathVariable Long id) {
        MessageResponseDTO response = catalogoMetaService.eliminarMeta(id);
        return ResponseEntity.ok(response);
    }

    // ✅ Ver Catálogo de Metas (cliente)
    @GetMapping("/app/catalog/goals")
    public ResponseEntity<List<CatalogoMetaResponseDTO>> listarMetas() {
        List<CatalogoMetaResponseDTO> response = catalogoMetaService.listarMetas();
        return ResponseEntity.ok(response);
    }
}

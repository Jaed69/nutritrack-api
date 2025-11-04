package com.example.nutritrackapi.controller;

import com.example.nutritrackapi.dto.*;
import com.example.nutritrackapi.service.PerfilService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/perfil")
@RequiredArgsConstructor
@Tag(name = "Módulo 1: Autenticación y Perfil - Gestión de Perfil", description = "Gestión del perfil de usuario y mediciones (US-03, US-04, US-05) - Leonel Alzamora")
public class PerfilController {

    private final PerfilService perfilService;

    /**
     * US-03: Actualizar unidades de medida
     * RN03: La unidad aplica a todas las vistas
     */
    @PatchMapping("/unidades")
    @Operation(summary = "Actualizar unidades de medida", 
               description = "Cambia entre KG y LBS para el peso del usuario")
    public ResponseEntity<ApiResponse<Void>> actualizarUnidades(
            Authentication authentication,
            @Valid @RequestBody UpdateUnidadesMedidaRequest request) {
        try {
            // TEMPORAL: Si no hay autenticación, usar admin
            String email = (authentication != null) ? authentication.getName() : "admin@nutritrack.com";
            perfilService.actualizarUnidadesMedida(email, request);
            return ResponseEntity.ok(ApiResponse.success(null, "Unidades actualizadas exitosamente"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * US-04: Editar perfil de salud
     * RN04: Usar etiquetas maestras
     */
    @PutMapping("/salud")
    @Operation(summary = "Actualizar perfil de salud", 
               description = "Configura objetivos, nivel de actividad, alergias y condiciones médicas")
    public ResponseEntity<ApiResponse<PerfilSaludResponse>> actualizarPerfilSalud(
            Authentication authentication,
            @Valid @RequestBody PerfilSaludRequest request) {
        try {
            // TEMPORAL: Si no hay autenticación, usar admin
            String email = (authentication != null) ? authentication.getName() : "admin@nutritrack.com";
            PerfilSaludResponse response = perfilService.actualizarPerfilSalud(email, request);
            return ResponseEntity.ok(ApiResponse.success(response, "Perfil de salud actualizado"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * Obtener perfil de salud actual
     */
    @GetMapping("/salud")
    @Operation(summary = "Obtener perfil de salud", 
               description = "Retorna el perfil de salud del usuario con sus etiquetas")
    public ResponseEntity<ApiResponse<PerfilSaludResponse>> obtenerPerfilSalud(
            Authentication authentication) {
        try {
            // TEMPORAL: Si no hay autenticación, usar admin
            String email = (authentication != null) ? authentication.getName() : "admin@nutritrack.com";
            PerfilSaludResponse response = perfilService.obtenerPerfilSalud(email);
            if (response == null) {
                return ResponseEntity.ok(ApiResponse.success(null, "Usuario no tiene perfil de salud configurado"));
            }
            return ResponseEntity.ok(ApiResponse.success(response, "Perfil de salud obtenido"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * US-24: Registrar medición corporal
     * RN22: Validar mediciones en rango
     */
    @PostMapping("/mediciones")
    @Operation(summary = "Registrar medición corporal", 
               description = "Registra peso, altura y otras mediciones del usuario")
    public ResponseEntity<ApiResponse<HistorialMedidasResponse>> registrarMedicion(
            Authentication authentication,
            @Valid @RequestBody HistorialMedidasRequest request) {
        try {
            // TEMPORAL: Si no hay autenticación, usar admin
            String email = (authentication != null) ? authentication.getName() : "admin@nutritrack.com";
            HistorialMedidasResponse response = perfilService.registrarMedicion(email, request);
            return ResponseEntity.ok(ApiResponse.success(response, "Medición registrada exitosamente"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * US-24: Obtener historial de mediciones
     */
    @GetMapping("/mediciones")
    @Operation(summary = "Obtener historial de mediciones", 
               description = "Retorna todas las mediciones del usuario ordenadas por fecha")
    public ResponseEntity<ApiResponse<List<HistorialMedidasResponse>>> obtenerHistorial(
            Authentication authentication) {
        try {
            // TEMPORAL: Si no hay autenticación, usar admin
            String email = (authentication != null) ? authentication.getName() : "admin@nutritrack.com";
            List<HistorialMedidasResponse> historial = perfilService.obtenerHistorialMediciones(email);
            return ResponseEntity.ok(ApiResponse.success(historial, "Historial obtenido"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}

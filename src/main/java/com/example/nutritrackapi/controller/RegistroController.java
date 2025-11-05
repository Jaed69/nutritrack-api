package com.example.nutritrackapi.controller;

import com.example.nutritrackapi.dto.*;
import com.example.nutritrackapi.model.CuentaAuth;
import com.example.nutritrackapi.repository.CuentaAuthRepository;
import com.example.nutritrackapi.repository.PerfilUsuarioRepository;
import com.example.nutritrackapi.service.RegistroService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * Controlador para gestión de registros de actividades.
 * Módulo 5: US-21, US-22, US-23
 */
@RestController
@RequestMapping("/api/v1/usuario/registros")
@RequiredArgsConstructor
@Tag(name = "Módulo 5: Tracking de Actividades", description = "👤 USER - Registro y seguimiento de comidas y ejercicios diarios (US-21, US-22, US-23). SOLO USUARIOS REGULARES.")
@SecurityRequirement(name = "bearerAuth")
public class RegistroController {

    private final RegistroService registroService;
    private final CuentaAuthRepository cuentaAuthRepository;
    private final PerfilUsuarioRepository perfilUsuarioRepository;

    // ============================================================
    // US-22: Registrar Comidas y Ejercicios
    // ============================================================

    @PostMapping("/comidas")
    @Operation(summary = "👤 USER - Registrar comida consumida", description = "US-22: Marcar comida como completada. SOLO USUARIOS REGULARES.")
    public ResponseEntity<RegistroComidaResponse> registrarComida(
            @Valid @RequestBody RegistroComidaRequest request,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        RegistroComidaResponse response = registroService.registrarComida(perfilUsuarioId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/ejercicios")
    @Operation(summary = "👤 USER - Registrar ejercicio realizado", description = "US-22: Marcar ejercicio como completado. SOLO USUARIOS REGULARES.")
    public ResponseEntity<RegistroEjercicioResponse> registrarEjercicio(
            @Valid @RequestBody RegistroEjercicioRequest request,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        RegistroEjercicioResponse response = registroService.registrarEjercicio(perfilUsuarioId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // ============================================================
    // US-21: Ver Actividades del Día
    // ============================================================

    @GetMapping("/plan/hoy")
    @Operation(summary = "👤 USER - Ver actividades del plan de hoy", description = "US-21: Obtener comidas programadas y su estado. SOLO USUARIOS REGULARES.")
    public ResponseEntity<ActividadesDiaResponse> obtenerActividadesHoy(Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        ActividadesDiaResponse response = registroService.obtenerActividadesDia(perfilUsuarioId, LocalDate.now());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/plan/dia")
    @Operation(summary = "👤 USER - Ver actividades del plan en una fecha", description = "US-21: Obtener comidas de un día específico. SOLO USUARIOS REGULARES.")
    public ResponseEntity<ActividadesDiaResponse> obtenerActividadesDia(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        ActividadesDiaResponse response = registroService.obtenerActividadesDia(perfilUsuarioId, fecha);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/rutina/hoy")
    @Operation(summary = "👤 USER - Ver ejercicios de la rutina de hoy", description = "US-21: Obtener ejercicios programados y su estado. SOLO USUARIOS REGULARES.")
    public ResponseEntity<EjerciciosDiaResponse> obtenerEjerciciosHoy(Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        EjerciciosDiaResponse response = registroService.obtenerEjerciciosDia(perfilUsuarioId, LocalDate.now());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/rutina/dia")
    @Operation(summary = "👤 USER - Ver ejercicios de la rutina en una fecha", description = "US-21: Obtener ejercicios de un día específico. SOLO USUARIOS REGULARES.")
    public ResponseEntity<EjerciciosDiaResponse> obtenerEjerciciosDia(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        EjerciciosDiaResponse response = registroService.obtenerEjerciciosDia(perfilUsuarioId, fecha);
        return ResponseEntity.ok(response);
    }

    // ============================================================
    // US-23: Eliminar Registros
    // ============================================================

    @DeleteMapping("/comidas/{registroId}")
    @Operation(summary = "👤 USER - Eliminar registro de comida", description = "US-23: Desmarcar comida completada. SOLO USUARIOS REGULARES.")
    public ResponseEntity<Void> eliminarRegistroComida(
            @PathVariable Long registroId,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        registroService.eliminarRegistroComida(perfilUsuarioId, registroId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/ejercicios/{registroId}")
    @Operation(summary = "👤 USER - Eliminar registro de ejercicio", description = "US-23: Desmarcar ejercicio completado. SOLO USUARIOS REGULARES.")
    public ResponseEntity<Void> eliminarRegistroEjercicio(
            @PathVariable Long registroId,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        registroService.eliminarRegistroEjercicio(perfilUsuarioId, registroId);
        return ResponseEntity.noContent().build();
    }

    // ============================================================
    // Consultas Históricas
    // ============================================================

    @GetMapping("/comidas/historial")
    @Operation(summary = "Obtener historial de comidas", description = "Consultar registros de comidas en un rango de fechas")
    public ResponseEntity<List<RegistroComidaResponse>> obtenerHistorialComidas(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        List<RegistroComidaResponse> historial = registroService.obtenerHistorialComidas(
                perfilUsuarioId, fechaInicio, fechaFin);
        return ResponseEntity.ok(historial);
    }

    @GetMapping("/ejercicios/historial")
    @Operation(summary = "Obtener historial de ejercicios", description = "Consultar registros de ejercicios en un rango de fechas")
    public ResponseEntity<List<RegistroEjercicioResponse>> obtenerHistorialEjercicios(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        List<RegistroEjercicioResponse> historial = registroService.obtenerHistorialEjercicios(
                perfilUsuarioId, fechaInicio, fechaFin);
        return ResponseEntity.ok(historial);
    }

    @GetMapping("/comidas/{registroId}")
    @Operation(summary = "Obtener detalle de registro de comida", description = "Consultar información completa de un registro específico")
    public ResponseEntity<RegistroComidaResponse> obtenerRegistroComida(
            @PathVariable Long registroId,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        RegistroComidaResponse response = registroService.obtenerRegistroComida(perfilUsuarioId, registroId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/ejercicios/{registroId}")
    @Operation(summary = "Obtener detalle de registro de ejercicio", description = "Consultar información completa de un registro específico")
    public ResponseEntity<RegistroEjercicioResponse> obtenerRegistroEjercicio(
            @PathVariable Long registroId,
            Authentication authentication) {
        Long perfilUsuarioId = obtenerPerfilUsuarioId(authentication);
        RegistroEjercicioResponse response = registroService.obtenerRegistroEjercicio(perfilUsuarioId, registroId);
        return ResponseEntity.ok(response);
    }

    // ============================================================
    // Utilidades
    // ============================================================

    private Long obtenerPerfilUsuarioId(Authentication authentication) {
        String email = authentication.getName();
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return perfilUsuarioRepository.findByCuentaId(cuenta.getId())
                .orElseThrow(() -> new RuntimeException("Perfil no encontrado"))
                .getId();
    }
}

package com.example.nutritrackapi.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/health")
@Tag(name = "Health Check", description = "🔓 PÚBLICO - Verificación de estado del servidor. ACCESO PÚBLICO (sin autenticación).")
public class HealthController {

    @GetMapping
    @Operation(summary = "🔓 PÚBLICO - Estado del servidor", description = "Verifica que el servidor esté operativo. ACCESO PÚBLICO.")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "NutriTrack API");
        response.put("timestamp", LocalDateTime.now());
        response.put("version", "1.0.0");
        response.put("environment", "development");
        
        return ResponseEntity.ok(response);
    }

    @GetMapping("/ping")
    @Operation(summary = "🔓 PÚBLICO - Ping", description = "Responde con 'pong' para verificar conectividad. ACCESO PÚBLICO.")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("pong");
    }
}

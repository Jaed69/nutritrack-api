package com.example.nutritrackapi.controller;

import com.example.nutritrackapi.dto.*;
import com.example.nutritrackapi.service.PlanService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador REST para gestión de planes nutricionales.
 * US-11: Crear Meta del Catálogo (Plan)
 * US-12: Gestionar Meta (configurar días)
 * US-13: Ver Catálogo de Metas (Admin)
 * US-14: Eliminar Meta
 * Solo accesible por administradores (ROLE_ADMIN)
 */
@RestController
@RequestMapping("/api/admin/planes")
@RequiredArgsConstructor
@Tag(name = "Módulo 3: Gestor de Catálogo - Planes Nutricionales", 
     description = "Gestión de planes nutricionales (US-11 a US-14) - Jhamil Peña")
@SecurityRequirement(name = "bearerAuth")
public class PlanController {

    private final PlanService planService;

    /**
     * US-11: Crear plan nutricional
     * RN11: Nombre único
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear plan nutricional", 
               description = "Crea un nuevo plan nutricional con objetivos diarios. RN11: Nombre debe ser único.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Plan creado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Datos inválidos o nombre duplicado (RN11)"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "No autenticado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "No autorizado - requiere rol ADMIN")
    })
    public ResponseEntity<ApiResponse<PlanResponse>> crearPlan(
            @Valid @RequestBody PlanRequest request
    ) {
        PlanResponse plan = planService.crearPlan(request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(plan, "Plan creado exitosamente"));
    }

    /**
     * US-17: Obtener plan por ID (para ver detalle)
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener plan por ID", 
               description = "Obtiene los detalles completos de un plan incluyendo objetivos nutricionales")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Plan encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Plan no encontrado")
    })
    public ResponseEntity<ApiResponse<PlanResponse>> obtenerPlan(
            @Parameter(description = "ID del plan") @PathVariable Long id
    ) {
        PlanResponse plan = planService.obtenerPlanPorId(id);
        return ResponseEntity.ok(ApiResponse.success(plan, "Plan encontrado"));
    }

    /**
     * US-13: Listar todos los planes (incluye inactivos para admin)
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Listar todos los planes (Admin)", 
               description = "Obtiene lista paginada de todos los planes incluyendo inactivos. Solo ADMIN.")
    public ResponseEntity<ApiResponse<Page<PlanResponse>>> listarPlanesAdmin(
            @PageableDefault(size = 20, sort = "id") Pageable pageable
    ) {
        Page<PlanResponse> planes = planService.listarPlanesAdmin(pageable);
        return ResponseEntity.ok(ApiResponse.success(planes, "Planes listados exitosamente"));
    }

    /**
     * Listar planes activos (para catálogo de clientes)
     * US-16: Ver Catálogo (se usará en módulo 4)
     */
    @GetMapping("/activos")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Listar planes activos", 
               description = "Obtiene solo los planes activos disponibles para asignar. RN28: Solo activo=true")
    public ResponseEntity<ApiResponse<Page<PlanResponse>>> listarPlanesActivos(
            @PageableDefault(size = 20, sort = "id") Pageable pageable
    ) {
        Page<PlanResponse> planes = planService.listarPlanesActivos(pageable);
        return ResponseEntity.ok(ApiResponse.success(planes, "Planes activos listados"));
    }

    /**
     * Buscar planes por nombre
     */
    @GetMapping("/buscar")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Buscar planes por nombre", 
               description = "Busca planes que contengan el texto especificado (case-insensitive)")
    public ResponseEntity<ApiResponse<Page<PlanResponse>>> buscarPorNombre(
            @Parameter(description = "Texto a buscar en el nombre") @RequestParam String nombre,
            @PageableDefault(size = 20) Pageable pageable
    ) {
        Page<PlanResponse> planes = planService.buscarPorNombre(nombre, pageable);
        return ResponseEntity.ok(ApiResponse.success(planes, "Búsqueda completada"));
    }

    /**
     * US-12: Actualizar plan
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar plan", 
               description = "Actualiza un plan existente. RN11: Nombre debe ser único.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Plan actualizado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Datos inválidos o nombre duplicado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Plan no encontrado")
    })
    public ResponseEntity<ApiResponse<PlanResponse>> actualizarPlan(
            @Parameter(description = "ID del plan") @PathVariable Long id,
            @Valid @RequestBody PlanRequest request
    ) {
        PlanResponse plan = planService.actualizarPlan(id, request);
        return ResponseEntity.ok(ApiResponse.success(plan, "Plan actualizado exitosamente"));
    }

    /**
     * US-14: Eliminar plan (soft delete)
     * RN14: No eliminar si tiene usuarios activos
     * RN28: Soft delete - marca como inactivo
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar plan (soft delete)", 
               description = "Marca el plan como inactivo. RN14: No permite eliminar si tiene usuarios activos. RN28: Soft delete.")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Plan eliminado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Plan no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "No se puede eliminar - tiene usuarios activos (RN14)")
    })
    public ResponseEntity<ApiResponse<Void>> eliminarPlan(
            @Parameter(description = "ID del plan") @PathVariable Long id
    ) {
        planService.eliminarPlan(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Plan eliminado exitosamente"));
    }

    // ========== GESTIÓN DE DÍAS DEL PLAN (US-12) ==========

    /**
     * US-12: Agregar actividad diaria al plan
     */
    @PostMapping("/{id}/dias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Agregar día al plan", 
               description = "Programa una comida específica para un día del plan")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Día agregado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Datos inválidos o día excede duración"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Plan o comida no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Ya existe comida para ese día y tipo")
    })
    public ResponseEntity<ApiResponse<PlanDiaResponse>> agregarDiaAPlan(
            @Parameter(description = "ID del plan") @PathVariable Long id,
            @Valid @RequestBody PlanDiaRequest request
    ) {
        PlanDiaResponse dia = planService.agregarDiaAPlan(id, request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(dia, "Actividad agregada al plan"));
    }

    /**
     * US-17: Obtener todas las actividades del plan
     */
    @GetMapping("/{id}/dias")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener días del plan", 
               description = "Lista todas las actividades programadas del plan ordenadas por día y tipo")
    public ResponseEntity<ApiResponse<List<PlanDiaResponse>>> obtenerDiasDePlan(
            @Parameter(description = "ID del plan") @PathVariable Long id
    ) {
        List<PlanDiaResponse> dias = planService.obtenerDiasDePlan(id);
        return ResponseEntity.ok(ApiResponse.success(dias, "Días del plan obtenidos"));
    }

    /**
     * US-21: Obtener actividades de un día específico
     */
    @GetMapping("/{id}/dias/{numeroDia}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Obtener actividades de un día", 
               description = "Lista las comidas programadas para un día específico del plan")
    public ResponseEntity<ApiResponse<List<PlanDiaResponse>>> obtenerActividadesDia(
            @Parameter(description = "ID del plan") @PathVariable Long id,
            @Parameter(description = "Número de día (1, 2, 3...)") @PathVariable Integer numeroDia
    ) {
        List<PlanDiaResponse> actividades = planService.obtenerActividadesDia(id, numeroDia);
        return ResponseEntity.ok(ApiResponse.success(actividades, "Actividades del día obtenidas"));
    }

    /**
     * Eliminar actividad del plan
     */
    @DeleteMapping("/{planId}/dias/{diaId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar actividad del plan", 
               description = "Elimina una comida programada de un día específico")
    public ResponseEntity<ApiResponse<Void>> eliminarDiaDePlan(
            @Parameter(description = "ID del plan") @PathVariable Long planId,
            @Parameter(description = "ID de la actividad") @PathVariable Long diaId
    ) {
        planService.eliminarDiaDePlan(planId, diaId);
        return ResponseEntity.ok(ApiResponse.success(null, "Actividad eliminada del plan"));
    }
}

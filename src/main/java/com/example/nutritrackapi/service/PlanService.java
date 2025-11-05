package com.example.nutritrackapi.service;

import com.example.nutritrackapi.dto.*;
import com.example.nutritrackapi.model.*;
import com.example.nutritrackapi.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Servicio para gestión de planes nutricionales.
 * Implementa US-11: Crear Meta del Catálogo (Plan)
 * Implementa US-12: Gestionar Meta (configurar días)
 * Implementa US-13: Ver Catálogo de Metas (Admin)
 * Implementa US-14: Eliminar Meta
 * RN11: Nombres únicos
 * RN14: No eliminar si tiene usuarios activos
 * RN28: Soft delete
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PlanService {

    private final PlanRepository planRepository;
    private final PlanObjetivoRepository planObjetivoRepository;
    private final PlanDiaRepository planDiaRepository;
    private final EtiquetaRepository etiquetaRepository;
    private final ComidaRepository comidaRepository;

    /**
     * US-11: Crea un nuevo plan nutricional.
     * RN11: Valida que el nombre sea único.
     */
    @Transactional
    public PlanResponse crearPlan(PlanRequest request) {
        // RN11: Validar nombre único
        if (planRepository.existsByNombre(request.getNombre())) {
            throw new IllegalArgumentException(
                "Ya existe un plan con el nombre: " + request.getNombre()
            );
        }

        // Crear plan
        Plan plan = Plan.builder()
                .nombre(request.getNombre())
                .descripcion(request.getDescripcion())
                .duracionDias(request.getDuracionDias())
                .activo(true)
                .build();

        // Asociar etiquetas
        if (request.getEtiquetaIds() != null && !request.getEtiquetaIds().isEmpty()) {
            Set<Etiqueta> etiquetas = new HashSet<>(
                etiquetaRepository.findAllById(request.getEtiquetaIds())
            );
            if (etiquetas.size() != request.getEtiquetaIds().size()) {
                throw new EntityNotFoundException("Una o más etiquetas no fueron encontradas");
            }
            plan.setEtiquetas(etiquetas);
        }

        Plan guardado = planRepository.save(plan);

        // Crear objetivos del plan
        if (request.getObjetivo() != null) {
            PlanObjetivo objetivo = PlanObjetivo.builder()
                    .plan(guardado)
                    .caloriasObjetivo(request.getObjetivo().getCaloriasObjetivo())
                    .proteinasObjetivo(request.getObjetivo().getProteinasObjetivo())
                    .carbohidratosObjetivo(request.getObjetivo().getCarbohidratosObjetivo())
                    .grasasObjetivo(request.getObjetivo().getGrasasObjetivo())
                    .descripcion(request.getObjetivo().getDescripcion())
                    .build();
            planObjetivoRepository.save(objetivo);
            guardado.setObjetivo(objetivo);
        }

        return PlanResponse.fromEntity(guardado);
    }

    /**
     * US-17: Obtiene un plan por su ID.
     */
    public PlanResponse obtenerPlanPorId(Long id) {
        Plan plan = planRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Plan no encontrado con ID: " + id
            ));
        return PlanResponse.fromEntity(plan);
    }

    /**
     * US-13: Lista todos los planes (admin - incluye inactivos).
     */
    public Page<PlanResponse> listarPlanesAdmin(Pageable pageable) {
        return planRepository.findAll(pageable)
            .map(PlanResponse::fromEntity);
    }

    /**
     * US-16: Lista planes activos (catálogo para clientes).
     * RN28: Solo planes activos.
     */
    public Page<PlanResponse> listarPlanesActivos(Pageable pageable) {
        return planRepository.findByActivoTrue(pageable)
            .map(PlanResponse::fromEntity);
    }

    /**
     * Busca planes por nombre (parcial, case-insensitive).
     */
    public Page<PlanResponse> buscarPorNombre(String nombre, Pageable pageable) {
        return planRepository.findByNombreContainingIgnoreCaseAndActivoTrue(nombre, pageable)
            .map(PlanResponse::fromEntity);
    }

    /**
     * US-12: Actualiza un plan existente.
     * RN11: Valida nombre único (excluyendo el plan actual).
     */
    @Transactional
    public PlanResponse actualizarPlan(Long id, PlanRequest request) {
        Plan plan = planRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Plan no encontrado con ID: " + id
            ));

        // RN11: Validar nombre único (excluyendo el plan actual)
        if (planRepository.existsByNombreAndIdNot(request.getNombre(), id)) {
            throw new IllegalArgumentException(
                "Ya existe otro plan con el nombre: " + request.getNombre()
            );
        }

        plan.setNombre(request.getNombre());
        plan.setDescripcion(request.getDescripcion());
        plan.setDuracionDias(request.getDuracionDias());

        // Actualizar etiquetas
        if (request.getEtiquetaIds() != null) {
            Set<Etiqueta> etiquetas = new HashSet<>(
                etiquetaRepository.findAllById(request.getEtiquetaIds())
            );
            if (etiquetas.size() != request.getEtiquetaIds().size()) {
                throw new EntityNotFoundException("Una o más etiquetas no fueron encontradas");
            }
            plan.setEtiquetas(etiquetas);
        }

        // Actualizar objetivos
        if (request.getObjetivo() != null) {
            PlanObjetivo objetivo = plan.getObjetivo();
            if (objetivo == null) {
                objetivo = new PlanObjetivo();
                objetivo.setPlan(plan);
            }
            objetivo.setCaloriasObjetivo(request.getObjetivo().getCaloriasObjetivo());
            objetivo.setProteinasObjetivo(request.getObjetivo().getProteinasObjetivo());
            objetivo.setCarbohidratosObjetivo(request.getObjetivo().getCarbohidratosObjetivo());
            objetivo.setGrasasObjetivo(request.getObjetivo().getGrasasObjetivo());
            objetivo.setDescripcion(request.getObjetivo().getDescripcion());
            planObjetivoRepository.save(objetivo);
            plan.setObjetivo(objetivo);
        }

        return PlanResponse.fromEntity(planRepository.save(plan));
    }

    /**
     * US-14: Elimina un plan (soft delete).
     * RN14: No permite eliminar si tiene usuarios activos.
     * RN28: Marca como inactivo en lugar de eliminar físicamente.
     */
    @Transactional
    public void eliminarPlan(Long id) {
        Plan plan = planRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Plan no encontrado con ID: " + id
            ));

        // RN14: Verificar que no tenga usuarios activos
        // TODO: Descomentar cuando se implemente UsuarioPlan
        /*
        if (planRepository.tieneUsuariosActivos(id)) {
            throw new IllegalStateException(
                "No se puede eliminar el plan porque tiene usuarios activos asignados. " +
                "Espere a que los usuarios completen o cancelen el plan."
            );
        }
        */

        // RN28: Soft delete - marcar como inactivo
        plan.setActivo(false);
        planRepository.save(plan);
    }

    /**
     * US-12: Agrega una actividad diaria al plan.
     */
    @Transactional
    public PlanDiaResponse agregarDiaAPlan(Long planId, PlanDiaRequest request) {
        Plan plan = planRepository.findById(planId)
            .orElseThrow(() -> new EntityNotFoundException(
                "Plan no encontrado con ID: " + planId
            ));

        // Validar que el número de día no exceda la duración del plan
        if (request.getNumeroDia() > plan.getDuracionDias()) {
            throw new IllegalArgumentException(
                "El número de día (" + request.getNumeroDia() +
                ") no puede exceder la duración del plan (" + plan.getDuracionDias() + " días)"
            );
        }

        // Verificar que la comida existe
        Comida comida = comidaRepository.findById(request.getComidaId())
            .orElseThrow(() -> new EntityNotFoundException(
                "Comida no encontrada con ID: " + request.getComidaId()
            ));

        // Verificar si ya existe una comida para este día y tipo
        if (planDiaRepository.existsByPlanIdAndNumeroDiaAndTipoComida(
                planId, request.getNumeroDia(), request.getTipoComida())) {
            throw new IllegalStateException(
                "Ya existe una comida de tipo " + request.getTipoComida() +
                " programada para el día " + request.getNumeroDia()
            );
        }

        PlanDia planDia = PlanDia.builder()
                .plan(plan)
                .numeroDia(request.getNumeroDia())
                .tipoComida(request.getTipoComida())
                .comida(comida)
                .notas(request.getNotas())
                .build();

        PlanDia guardado = planDiaRepository.save(planDia);
        return PlanDiaResponse.fromEntity(guardado);
    }

    /**
     * US-17: Obtiene todas las actividades de un plan.
     */
    public List<PlanDiaResponse> obtenerDiasDePlan(Long planId) {
        if (!planRepository.existsById(planId)) {
            throw new EntityNotFoundException("Plan no encontrado con ID: " + planId);
        }

        return planDiaRepository.findByPlanIdOrderByNumeroDiaAscTipoComidaAsc(planId)
            .stream()
            .map(PlanDiaResponse::fromEntity)
            .collect(Collectors.toList());
    }

    /**
     * US-21: Obtiene actividades de un día específico del plan.
     */
    public List<PlanDiaResponse> obtenerActividadesDia(Long planId, Integer numeroDia) {
        if (!planRepository.existsById(planId)) {
            throw new EntityNotFoundException("Plan no encontrado con ID: " + planId);
        }

        return planDiaRepository.findByPlanIdAndNumeroDia(planId, numeroDia)
            .stream()
            .map(PlanDiaResponse::fromEntity)
            .collect(Collectors.toList());
    }

    /**
     * Elimina una actividad diaria del plan.
     */
    @Transactional
    public void eliminarDiaDePlan(Long planId, Long diaId) {
        PlanDia planDia = planDiaRepository.findById(diaId)
            .orElseThrow(() -> new EntityNotFoundException(
                "Actividad no encontrada con ID: " + diaId
            ));

        if (!planDia.getPlan().getId().equals(planId)) {
            throw new IllegalArgumentException(
                "La actividad no pertenece al plan especificado"
            );
        }

        planDiaRepository.delete(planDia);
    }
}

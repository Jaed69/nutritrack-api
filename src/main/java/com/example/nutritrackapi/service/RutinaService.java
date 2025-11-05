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
 * Servicio para gestión de rutinas de ejercicio.
 * Implementa US-11: Crear Meta del Catálogo (Rutina)
 * Implementa US-12: Gestionar Meta (configurar ejercicios)
 * Implementa US-13: Ver Catálogo de Metas (Admin)
 * Implementa US-14: Eliminar Meta
 * Implementa US-15: Ensamblar Rutinas
 * RN11: Nombres únicos
 * RN13: Series y repeticiones positivas
 * RN14: No eliminar si tiene usuarios activos
 * RN28: Soft delete
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RutinaService {

    private final RutinaRepository rutinaRepository;
    private final RutinaEjercicioRepository rutinaEjercicioRepository;
    private final EtiquetaRepository etiquetaRepository;
    private final EjercicioRepository ejercicioRepository;

    /**
     * US-11: Crea una nueva rutina de ejercicio.
     * RN11: Valida que el nombre sea único.
     */
    @Transactional
    public RutinaResponse crearRutina(RutinaRequest request) {
        // RN11: Validar nombre único
        if (rutinaRepository.existsByNombre(request.getNombre())) {
            throw new IllegalArgumentException(
                "Ya existe una rutina con el nombre: " + request.getNombre()
            );
        }

        // Crear rutina
        Rutina rutina = Rutina.builder()
                .nombre(request.getNombre())
                .descripcion(request.getDescripcion())
                .duracionSemanas(request.getDuracionSemanas())
                .nivelDificultad(request.getNivelDificultad())
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
            rutina.setEtiquetas(etiquetas);
        }

        Rutina guardada = rutinaRepository.save(rutina);
        return RutinaResponse.fromEntity(guardada);
    }

    /**
     * US-17: Obtiene una rutina por su ID.
     */
    public RutinaResponse obtenerRutinaPorId(Long id) {
        Rutina rutina = rutinaRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Rutina no encontrada con ID: " + id
            ));
        return RutinaResponse.fromEntity(rutina);
    }

    /**
     * US-13: Lista todas las rutinas (admin - incluye inactivas).
     */
    public Page<RutinaResponse> listarRutinasAdmin(Pageable pageable) {
        return rutinaRepository.findAll(pageable)
            .map(RutinaResponse::fromEntity);
    }

    /**
     * US-16: Lista rutinas activas (catálogo para clientes).
     * RN28: Solo rutinas activas.
     */
    public Page<RutinaResponse> listarRutinasActivas(Pageable pageable) {
        return rutinaRepository.findByActivoTrue(pageable)
            .map(RutinaResponse::fromEntity);
    }

    /**
     * Busca rutinas por nombre (parcial, case-insensitive).
     */
    public Page<RutinaResponse> buscarPorNombre(String nombre, Pageable pageable) {
        return rutinaRepository.findByNombreContainingIgnoreCaseAndActivoTrue(nombre, pageable)
            .map(RutinaResponse::fromEntity);
    }

    /**
     * US-12: Actualiza una rutina existente.
     * RN11: Valida nombre único (excluyendo la rutina actual).
     */
    @Transactional
    public RutinaResponse actualizarRutina(Long id, RutinaRequest request) {
        Rutina rutina = rutinaRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Rutina no encontrada con ID: " + id
            ));

        // RN11: Validar nombre único (excluyendo la rutina actual)
        if (rutinaRepository.existsByNombreAndIdNot(request.getNombre(), id)) {
            throw new IllegalArgumentException(
                "Ya existe otra rutina con el nombre: " + request.getNombre()
            );
        }

        rutina.setNombre(request.getNombre());
        rutina.setDescripcion(request.getDescripcion());
        rutina.setDuracionSemanas(request.getDuracionSemanas());
        rutina.setNivelDificultad(request.getNivelDificultad());

        // Actualizar etiquetas
        if (request.getEtiquetaIds() != null) {
            Set<Etiqueta> etiquetas = new HashSet<>(
                etiquetaRepository.findAllById(request.getEtiquetaIds())
            );
            if (etiquetas.size() != request.getEtiquetaIds().size()) {
                throw new EntityNotFoundException("Una o más etiquetas no fueron encontradas");
            }
            rutina.setEtiquetas(etiquetas);
        }

        return RutinaResponse.fromEntity(rutinaRepository.save(rutina));
    }

    /**
     * US-14: Elimina una rutina (soft delete).
     * RN14: No permite eliminar si tiene usuarios activos.
     * RN28: Marca como inactivo en lugar de eliminar físicamente.
     */
    @Transactional
    public void eliminarRutina(Long id) {
        Rutina rutina = rutinaRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException(
                "Rutina no encontrada con ID: " + id
            ));

        // RN14: Verificar que no tenga usuarios activos
        // TODO: Descomentar cuando se implemente UsuarioRutina
        /*
        if (rutinaRepository.tieneUsuariosActivos(id)) {
            throw new IllegalStateException(
                "No se puede eliminar la rutina porque tiene usuarios activos asignados. " +
                "Espere a que los usuarios completen o cancelen la rutina."
            );
        }
        */

        // RN28: Soft delete - marcar como inactivo
        rutina.setActivo(false);
        rutinaRepository.save(rutina);
    }

    /**
     * US-12, US-15: Agrega un ejercicio a la rutina.
     * RN13: Valida que series y repeticiones sean positivas (ya validado en DTO).
     */
    @Transactional
    public RutinaEjercicioResponse agregarEjercicioARutina(Long rutinaId, RutinaEjercicioRequest request) {
        Rutina rutina = rutinaRepository.findById(rutinaId)
            .orElseThrow(() -> new EntityNotFoundException(
                "Rutina no encontrada con ID: " + rutinaId
            ));

        // Verificar que el ejercicio existe
        Ejercicio ejercicio = ejercicioRepository.findById(request.getEjercicioId())
            .orElseThrow(() -> new EntityNotFoundException(
                "Ejercicio no encontrado con ID: " + request.getEjercicioId()
            ));

        // Verificar si ya existe un ejercicio en ese orden
        if (rutinaEjercicioRepository.existsByRutinaIdAndOrden(rutinaId, request.getOrden())) {
            throw new IllegalStateException(
                "Ya existe un ejercicio en el orden " + request.getOrden() +
                ". Por favor, elija otro orden o modifique el ejercicio existente."
            );
        }

        RutinaEjercicio rutinaEjercicio = RutinaEjercicio.builder()
                .rutina(rutina)
                .ejercicio(ejercicio)
                .orden(request.getOrden())
                .series(request.getSeries())
                .repeticiones(request.getRepeticiones())
                .peso(request.getPeso())
                .duracionMinutos(request.getDuracionMinutos())
                .descansoSegundos(request.getDescansoSegundos())
                .notas(request.getNotas())
                .build();

        RutinaEjercicio guardado = rutinaEjercicioRepository.save(rutinaEjercicio);
        return RutinaEjercicioResponse.fromEntity(guardado);
    }

    /**
     * US-17: Obtiene todos los ejercicios de una rutina.
     */
    public List<RutinaEjercicioResponse> obtenerEjerciciosDeRutina(Long rutinaId) {
        if (!rutinaRepository.existsById(rutinaId)) {
            throw new EntityNotFoundException("Rutina no encontrada con ID: " + rutinaId);
        }

        return rutinaEjercicioRepository.findByRutinaIdOrderByOrdenAsc(rutinaId)
            .stream()
            .map(RutinaEjercicioResponse::fromEntity)
            .collect(Collectors.toList());
    }

    /**
     * US-15: Actualiza un ejercicio de la rutina.
     * RN13: Valida series y repeticiones positivas.
     */
    @Transactional
    public RutinaEjercicioResponse actualizarEjercicioDeRutina(
            Long rutinaId,
            Long ejercicioId,
            RutinaEjercicioRequest request) {
        
        RutinaEjercicio rutinaEjercicio = rutinaEjercicioRepository.findById(ejercicioId)
            .orElseThrow(() -> new EntityNotFoundException(
                "Ejercicio de rutina no encontrado con ID: " + ejercicioId
            ));

        if (!rutinaEjercicio.getRutina().getId().equals(rutinaId)) {
            throw new IllegalArgumentException(
                "El ejercicio no pertenece a la rutina especificada"
            );
        }

        // Si se cambia el orden, verificar que no exista otro ejercicio en ese orden
        if (!rutinaEjercicio.getOrden().equals(request.getOrden())) {
            if (rutinaEjercicioRepository.existsByRutinaIdAndOrden(rutinaId, request.getOrden())) {
                throw new IllegalStateException(
                    "Ya existe un ejercicio en el orden " + request.getOrden()
                );
            }
        }

        // Si se cambia el ejercicio, verificar que existe
        if (request.getEjercicioId() != null && 
            !rutinaEjercicio.getEjercicio().getId().equals(request.getEjercicioId())) {
            Ejercicio nuevoEjercicio = ejercicioRepository.findById(request.getEjercicioId())
                .orElseThrow(() -> new EntityNotFoundException(
                    "Ejercicio no encontrado con ID: " + request.getEjercicioId()
                ));
            rutinaEjercicio.setEjercicio(nuevoEjercicio);
        }

        rutinaEjercicio.setOrden(request.getOrden());
        rutinaEjercicio.setSeries(request.getSeries());
        rutinaEjercicio.setRepeticiones(request.getRepeticiones());
        rutinaEjercicio.setPeso(request.getPeso());
        rutinaEjercicio.setDuracionMinutos(request.getDuracionMinutos());
        rutinaEjercicio.setDescansoSegundos(request.getDescansoSegundos());
        rutinaEjercicio.setNotas(request.getNotas());

        return RutinaEjercicioResponse.fromEntity(rutinaEjercicioRepository.save(rutinaEjercicio));
    }

    /**
     * Elimina un ejercicio de la rutina.
     */
    @Transactional
    public void eliminarEjercicioDeRutina(Long rutinaId, Long ejercicioId) {
        RutinaEjercicio rutinaEjercicio = rutinaEjercicioRepository.findById(ejercicioId)
            .orElseThrow(() -> new EntityNotFoundException(
                "Ejercicio de rutina no encontrado con ID: " + ejercicioId
            ));

        if (!rutinaEjercicio.getRutina().getId().equals(rutinaId)) {
            throw new IllegalArgumentException(
                "El ejercicio no pertenece a la rutina especificada"
            );
        }

        rutinaEjercicioRepository.delete(rutinaEjercicio);
    }
}

package com.example.nutritrackapi.service;

import com.example.nutritrackapi.dto.ActivarPlanRequest;
import com.example.nutritrackapi.dto.UsuarioPlanResponse;
import com.example.nutritrackapi.exception.BusinessException;
import com.example.nutritrackapi.model.*;
import com.example.nutritrackapi.repository.PerfilUsuarioRepository;
import com.example.nutritrackapi.repository.PlanRepository;
import com.example.nutritrackapi.repository.UsuarioPlanRepository;
import jakarta.persistence.EntityNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UsuarioPlanService - Tests unitarios Módulo 4")
class UsuarioPlanServiceTest {

    @Mock
    private UsuarioPlanRepository usuarioPlanRepository;

    @Mock
    private PlanRepository planRepository;

    @Mock
    private PerfilUsuarioRepository perfilUsuarioRepository;

    @InjectMocks
    private UsuarioPlanService usuarioPlanService;

    private PerfilUsuario perfilUsuario;
    private Plan plan;
    private UsuarioPlan usuarioPlan;

    @BeforeEach
    void setUp() {
        // Setup perfil usuario
        perfilUsuario = PerfilUsuario.builder()
                .id(1L)
                .nombre("Test")
                .apellido("Usuario")
                .build();

        // Setup plan
        plan = Plan.builder()
                .id(1L)
                .nombre("Plan de Pérdida de Peso")
                .descripcion("Plan para perder peso")
                .duracionDias(30)
                .activo(true)
                .build();

        // Setup usuario plan
        usuarioPlan = UsuarioPlan.builder()
                .id(1L)
                .perfilUsuario(perfilUsuario)
                .plan(plan)
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusDays(30))
                .diaActual(1)
                .estado(UsuarioPlan.EstadoAsignacion.ACTIVO)
                .build();
    }

    @Test
    @DisplayName("US-18: Activar plan exitosamente")
    void activarPlan_Success() {
        // Given
        ActivarPlanRequest request = new ActivarPlanRequest();
        request.setPlanId(1L);
        request.setFechaInicio(LocalDate.now());
        request.setNotas("Plan de prueba");

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(planRepository.findById(1L)).thenReturn(Optional.of(plan));
        when(usuarioPlanRepository.existsByPerfilUsuarioIdAndPlanIdAndEstado(
                1L, 1L, UsuarioPlan.EstadoAsignacion.ACTIVO)).thenReturn(false);
        when(usuarioPlanRepository.save(any(UsuarioPlan.class))).thenReturn(usuarioPlan);

        // When
        UsuarioPlanResponse response = usuarioPlanService.activarPlan(1L, request);

        // Then
        assertNotNull(response);
        assertEquals("Plan de Pérdida de Peso", response.getPlanNombre());
        verify(usuarioPlanRepository).save(any(UsuarioPlan.class));
    }

    @Test
    @DisplayName("RN17: No permite activar plan duplicado")
    void activarPlan_RN17_DuplicadoLanzaExcepcion() {
        // Given
        ActivarPlanRequest request = new ActivarPlanRequest();
        request.setPlanId(1L);

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(planRepository.findById(1L)).thenReturn(Optional.of(plan));
        when(usuarioPlanRepository.existsByPerfilUsuarioIdAndPlanIdAndEstado(
                1L, 1L, UsuarioPlan.EstadoAsignacion.ACTIVO)).thenReturn(true);

        // When & Then
        assertThrows(BusinessException.class, () -> {
            usuarioPlanService.activarPlan(1L, request);
        });
        
        verify(usuarioPlanRepository, never()).save(any());
    }

    @Test
    @DisplayName("RN18: Propone reemplazo cuando hay plan activo")
    void activarPlan_RN18_ProponeReemplazo() {
        // Given
        ActivarPlanRequest request = new ActivarPlanRequest();
        request.setPlanId(1L);

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(planRepository.findById(1L)).thenReturn(Optional.of(plan));
        when(usuarioPlanRepository.existsByPerfilUsuarioIdAndPlanIdAndEstado(
                1L, 1L, UsuarioPlan.EstadoAsignacion.ACTIVO)).thenReturn(true);

        // When & Then
        BusinessException exception = assertThrows(BusinessException.class, () -> {
            usuarioPlanService.activarPlan(1L, request);
        });
        
        // RN18: Verificar que propone pausar o cancelar el plan actual
        assertTrue(exception.getMessage().contains("pausarlo") || exception.getMessage().contains("cancelarlo"));
    }

    @Test
    @DisplayName("US-19: Pausar plan exitosamente")
    void pausarPlan_Success() {
        // Given
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));
        when(usuarioPlanRepository.save(any(UsuarioPlan.class))).thenReturn(usuarioPlan);

        // When
        UsuarioPlanResponse response = usuarioPlanService.pausarPlan(1L, 1L);

        // Then
        assertNotNull(response);
        verify(usuarioPlanRepository).save(any(UsuarioPlan.class));
    }

    @Test
    @DisplayName("RN19: No permite pausar plan en estado final")
    void pausarPlan_RN19_EstadoFinalLanzaExcepcion() {
        // Given
        usuarioPlan.setEstado(UsuarioPlan.EstadoAsignacion.COMPLETADO);
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));

        // When & Then
        assertThrows(BusinessException.class, () -> {
            usuarioPlanService.pausarPlan(1L, 1L);
        });
    }

    @Test
    @DisplayName("US-19: Reanudar plan exitosamente")
    void reanudarPlan_Success() {
        // Given
        usuarioPlan.setEstado(UsuarioPlan.EstadoAsignacion.PAUSADO);
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));
        when(usuarioPlanRepository.save(any(UsuarioPlan.class))).thenReturn(usuarioPlan);

        // When
        UsuarioPlanResponse response = usuarioPlanService.reanudarPlan(1L, 1L);

        // Then
        assertNotNull(response);
        verify(usuarioPlanRepository).save(any(UsuarioPlan.class));
    }

    @Test
    @DisplayName("US-20: Completar plan exitosamente")
    void completarPlan_Success() {
        // Given
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));
        when(usuarioPlanRepository.save(any(UsuarioPlan.class))).thenReturn(usuarioPlan);

        // When
        UsuarioPlanResponse response = usuarioPlanService.completarPlan(1L, 1L);

        // Then
        assertNotNull(response);
        verify(usuarioPlanRepository).save(any(UsuarioPlan.class));
    }

    @Test
    @DisplayName("RN26: Valida transición de estado al completar")
    void completarPlan_RN26_ValidaTransicion() {
        // Given
        usuarioPlan.setEstado(UsuarioPlan.EstadoAsignacion.CANCELADO);
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));

        // When & Then
        assertThrows(BusinessException.class, () -> {
            usuarioPlanService.completarPlan(1L, 1L);
        });
    }

    @Test
    @DisplayName("US-20: Cancelar plan exitosamente")
    void cancelarPlan_Success() {
        // Given
        when(usuarioPlanRepository.findById(1L)).thenReturn(Optional.of(usuarioPlan));
        when(usuarioPlanRepository.save(any(UsuarioPlan.class))).thenReturn(usuarioPlan);

        // When
        UsuarioPlanResponse response = usuarioPlanService.cancelarPlan(1L, 1L);

        // Then
        assertNotNull(response);
        verify(usuarioPlanRepository).save(any(UsuarioPlan.class));
    }

    @Test
    @DisplayName("Obtener plan activo actual")
    void obtenerPlanActivo_Success() {
        // Given
        when(usuarioPlanRepository.findPlanActivoActual(1L)).thenReturn(Optional.of(usuarioPlan));

        // When
        UsuarioPlanResponse response = usuarioPlanService.obtenerPlanActivo(1L);

        // Then
        assertNotNull(response);
        assertEquals("Plan de Pérdida de Peso", response.getPlanNombre());
    }

    @Test
    @DisplayName("Obtener plan activo cuando no existe")
    void obtenerPlanActivo_NoExiste() {
        // Given
        when(usuarioPlanRepository.findPlanActivoActual(1L)).thenReturn(Optional.empty());

        // When
        UsuarioPlanResponse response = usuarioPlanService.obtenerPlanActivo(1L);

        // Then
        assertNull(response);
    }

    @Test
    @DisplayName("Obtener todos los planes del usuario")
    void obtenerPlanes_Success() {
        // Given
        when(usuarioPlanRepository.findByPerfilUsuarioId(1L)).thenReturn(List.of(usuarioPlan));

        // When
        List<UsuarioPlanResponse> response = usuarioPlanService.obtenerPlanes(1L);

        // Then
        assertNotNull(response);
        assertEquals(1, response.size());
    }

    @Test
    @DisplayName("Obtener planes activos del usuario")
    void obtenerPlanesActivos_Success() {
        // Given
        when(usuarioPlanRepository.findAllPlanesActivos(1L)).thenReturn(List.of(usuarioPlan));

        // When
        List<UsuarioPlanResponse> response = usuarioPlanService.obtenerPlanesActivos(1L);

        // Then
        assertNotNull(response);
        assertEquals(1, response.size());
    }

    @Test
    @DisplayName("Plan no encontrado lanza excepción")
    void activarPlan_PlanNoEncontrado() {
        // Given
        ActivarPlanRequest request = new ActivarPlanRequest();
        request.setPlanId(999L);

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(planRepository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(EntityNotFoundException.class, () -> {
            usuarioPlanService.activarPlan(1L, request);
        });
    }

    @Test
    @DisplayName("Perfil no encontrado lanza excepción")
    void activarPlan_PerfilNoEncontrado() {
        // Given
        ActivarPlanRequest request = new ActivarPlanRequest();
        request.setPlanId(1L);

        when(perfilUsuarioRepository.findById(999L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(EntityNotFoundException.class, () -> {
            usuarioPlanService.activarPlan(999L, request);
        });
    }
}

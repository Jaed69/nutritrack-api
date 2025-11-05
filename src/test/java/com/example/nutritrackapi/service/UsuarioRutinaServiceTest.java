package com.example.nutritrackapi.service;

import com.example.nutritrackapi.dto.ActivarRutinaRequest;
import com.example.nutritrackapi.dto.UsuarioRutinaResponse;
import com.example.nutritrackapi.exception.BusinessException;
import com.example.nutritrackapi.model.*;
import com.example.nutritrackapi.repository.PerfilUsuarioRepository;
import com.example.nutritrackapi.repository.RutinaRepository;
import com.example.nutritrackapi.repository.UsuarioRutinaRepository;
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
@DisplayName("UsuarioRutinaService - Tests unitarios Módulo 4")
class UsuarioRutinaServiceTest {

    @Mock
    private UsuarioRutinaRepository usuarioRutinaRepository;

    @Mock
    private RutinaRepository rutinaRepository;

    @Mock
    private PerfilUsuarioRepository perfilUsuarioRepository;

    @InjectMocks
    private UsuarioRutinaService usuarioRutinaService;

    private PerfilUsuario perfilUsuario;
    private Rutina rutina;
    private UsuarioRutina usuarioRutina;

    @BeforeEach
    void setUp() {
        perfilUsuario = PerfilUsuario.builder()
                .id(1L)
                .nombre("Test")
                .apellido("Usuario")
                .build();

        rutina = Rutina.builder()
                .id(1L)
                .nombre("Rutina de Fuerza")
                .descripcion("Rutina para ganar fuerza")
                .duracionSemanas(8)
                .activo(true)
                .build();

        usuarioRutina = UsuarioRutina.builder()
                .id(1L)
                .perfilUsuario(perfilUsuario)
                .rutina(rutina)
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusWeeks(8))
                .semanaActual(1)
                .estado(UsuarioPlan.EstadoAsignacion.ACTIVO)
                .build();
    }

    @Test
    @DisplayName("US-18: Activar rutina exitosamente")
    void activarRutina_Success() {
        ActivarRutinaRequest request = new ActivarRutinaRequest();
        request.setRutinaId(1L);

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(rutinaRepository.findById(1L)).thenReturn(Optional.of(rutina));
        when(usuarioRutinaRepository.existsByPerfilUsuarioIdAndRutinaIdAndEstado(
                1L, 1L, UsuarioPlan.EstadoAsignacion.ACTIVO)).thenReturn(false);
        when(usuarioRutinaRepository.save(any(UsuarioRutina.class))).thenReturn(usuarioRutina);

        UsuarioRutinaResponse response = usuarioRutinaService.activarRutina(1L, request);

        assertNotNull(response);
        assertEquals("Rutina de Fuerza", response.getRutinaNombre());
        verify(usuarioRutinaRepository).save(any(UsuarioRutina.class));
    }

    @Test
    @DisplayName("RN17: No permite activar rutina duplicada")
    void activarRutina_RN17_DuplicadoLanzaExcepcion() {
        ActivarRutinaRequest request = new ActivarRutinaRequest();
        request.setRutinaId(1L);

        when(perfilUsuarioRepository.findById(1L)).thenReturn(Optional.of(perfilUsuario));
        when(rutinaRepository.findById(1L)).thenReturn(Optional.of(rutina));
        when(usuarioRutinaRepository.existsByPerfilUsuarioIdAndRutinaIdAndEstado(
                1L, 1L, UsuarioPlan.EstadoAsignacion.ACTIVO)).thenReturn(true);

        assertThrows(BusinessException.class, () -> {
            usuarioRutinaService.activarRutina(1L, request);
        });
    }

    @Test
    @DisplayName("US-19: Pausar rutina exitosamente")
    void pausarRutina_Success() {
        when(usuarioRutinaRepository.findById(1L)).thenReturn(Optional.of(usuarioRutina));
        when(usuarioRutinaRepository.save(any(UsuarioRutina.class))).thenReturn(usuarioRutina);

        UsuarioRutinaResponse response = usuarioRutinaService.pausarRutina(1L, 1L);

        assertNotNull(response);
        verify(usuarioRutinaRepository).save(any(UsuarioRutina.class));
    }

    @Test
    @DisplayName("US-19: Reanudar rutina exitosamente")
    void reanudarRutina_Success() {
        usuarioRutina.setEstado(UsuarioPlan.EstadoAsignacion.PAUSADO);
        when(usuarioRutinaRepository.findById(1L)).thenReturn(Optional.of(usuarioRutina));
        when(usuarioRutinaRepository.save(any(UsuarioRutina.class))).thenReturn(usuarioRutina);

        UsuarioRutinaResponse response = usuarioRutinaService.reanudarRutina(1L, 1L);

        assertNotNull(response);
    }

    @Test
    @DisplayName("US-20: Completar rutina exitosamente")
    void completarRutina_Success() {
        when(usuarioRutinaRepository.findById(1L)).thenReturn(Optional.of(usuarioRutina));
        when(usuarioRutinaRepository.save(any(UsuarioRutina.class))).thenReturn(usuarioRutina);

        UsuarioRutinaResponse response = usuarioRutinaService.completarRutina(1L, 1L);

        assertNotNull(response);
    }

    @Test
    @DisplayName("US-20: Cancelar rutina exitosamente")
    void cancelarRutina_Success() {
        when(usuarioRutinaRepository.findById(1L)).thenReturn(Optional.of(usuarioRutina));
        when(usuarioRutinaRepository.save(any(UsuarioRutina.class))).thenReturn(usuarioRutina);

        UsuarioRutinaResponse response = usuarioRutinaService.cancelarRutina(1L, 1L);

        assertNotNull(response);
    }

    @Test
    @DisplayName("Obtener rutina activa actual")
    void obtenerRutinaActiva_Success() {
        when(usuarioRutinaRepository.findRutinaActivaActual(1L)).thenReturn(Optional.of(usuarioRutina));

        UsuarioRutinaResponse response = usuarioRutinaService.obtenerRutinaActiva(1L);

        assertNotNull(response);
    }

    @Test
    @DisplayName("Obtener todas las rutinas del usuario")
    void obtenerRutinas_Success() {
        when(usuarioRutinaRepository.findByPerfilUsuarioId(1L)).thenReturn(List.of(usuarioRutina));

        List<UsuarioRutinaResponse> response = usuarioRutinaService.obtenerRutinas(1L);

        assertNotNull(response);
        assertEquals(1, response.size());
    }
}

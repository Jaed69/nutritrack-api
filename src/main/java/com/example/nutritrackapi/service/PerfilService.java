package com.example.nutritrackapi.service;

import com.example.nutritrackapi.dto.*;
import com.example.nutritrackapi.model.*;
import com.example.nutritrackapi.repository.*;
import com.example.nutritrackapi.util.UnidadesUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PerfilService {

    private final PerfilUsuarioRepository perfilUsuarioRepository;
    private final UsuarioPerfilSaludRepository perfilSaludRepository;
    private final UsuarioHistorialMedidasRepository historialMedidasRepository;
    private final UsuarioEtiquetasSaludRepository etiquetasSaludRepository;
    private final EtiquetaRepository etiquetaRepository;
    private final CuentaAuthRepository cuentaAuthRepository;

    /**
     * US-03: Actualizar unidades de medida
     * RN03: La unidad aplica a todas las vistas
     */
    @Transactional
    public void actualizarUnidadesMedida(String email, UpdateUnidadesMedidaRequest request) {
        PerfilUsuario perfil = obtenerPerfilPorEmail(email);
        perfil.setUnidadesMedida(request.getUnidadesMedida());
        perfilUsuarioRepository.save(perfil);
    }

    /**
     * US-04: Actualizar perfil de salud
     * RN04: Usar etiquetas maestras
     */
    @Transactional
    public PerfilSaludResponse actualizarPerfilSalud(String email, PerfilSaludRequest request) {
        PerfilUsuario perfil = obtenerPerfilPorEmail(email);
        
        // Crear o actualizar perfil de salud
        UsuarioPerfilSalud perfilSalud = perfilSaludRepository.findByPerfilUsuarioId(perfil.getId())
            .orElse(UsuarioPerfilSalud.builder()
                .perfilUsuario(perfil) // @MapsId asignará automáticamente el ID del perfil
                .build());
        
        perfilSalud.setObjetivoActual(request.getObjetivoActual());
        perfilSalud.setNivelActividadActual(request.getNivelActividadActual());
        perfilSalud.setFechaActualizacion(java.time.LocalDate.now());
        perfilSaludRepository.save(perfilSalud);
        
        // Actualizar etiquetas (alergias, condiciones médicas)
        if (request.getEtiquetasId() != null) {
            // Eliminar etiquetas existentes
            etiquetasSaludRepository.deleteByPerfilUsuarioId(perfil.getId());
            
            // Agregar nuevas etiquetas
            for (Long etiquetaId : request.getEtiquetasId()) {
                Etiqueta etiqueta = etiquetaRepository.findById(etiquetaId)
                    .orElseThrow(() -> new RuntimeException("Etiqueta no encontrada: " + etiquetaId));
                
                UsuarioEtiquetasSalud usuarioEtiqueta = UsuarioEtiquetasSalud.builder()
                    .perfilUsuario(perfil)
                    .etiqueta(etiqueta)
                    .build();
                etiquetasSaludRepository.save(usuarioEtiqueta);
            }
        }
        
        return obtenerPerfilSalud(email);
    }

    /**
     * Obtener perfil de salud del usuario
     */
    @Transactional(readOnly = true)
    public PerfilSaludResponse obtenerPerfilSalud(String email) {
        PerfilUsuario perfil = obtenerPerfilPorEmail(email);
        
        UsuarioPerfilSalud perfilSalud = perfilSaludRepository.findByPerfilUsuarioId(perfil.getId())
            .orElse(null);
        
        if (perfilSalud == null) {
            return null;
        }
        
        List<Etiqueta> etiquetas = etiquetasSaludRepository.findEtiquetasByPerfilId(perfil.getId());
        
        return PerfilSaludResponse.builder()
            .id(perfilSalud.getId())
            .objetivoActual(perfilSalud.getObjetivoActual())
            .nivelActividadActual(perfilSalud.getNivelActividadActual())
            .etiquetas(etiquetas.stream()
                .map(e -> PerfilSaludResponse.EtiquetaDTO.builder()
                    .id(e.getId())
                    .nombre(e.getNombre())
                    .tipoEtiqueta(e.getTipoEtiqueta())
                    .descripcion(e.getDescripcion())
                    .build())
                .collect(Collectors.toList()))
            .build();
    }

    /**
     * US-24: Registrar medición corporal
     * RN22: Validar mediciones en rango
     * RN27: Convertir a KG antes de guardar
     */
    @Transactional
    public HistorialMedidasResponse registrarMedicion(String email, HistorialMedidasRequest request) {
        PerfilUsuario perfil = obtenerPerfilPorEmail(email);
        
        // Validar que no existe medición para la misma fecha
        if (historialMedidasRepository.existsByPerfilUsuarioIdAndFechaMedicion(
                perfil.getId(), request.getFechaMedicion())) {
            throw new RuntimeException("Ya existe una medición para la fecha " + request.getFechaMedicion());
        }
        
        // Convertir peso a KG si viene en LBS (RN27)
        var unidadEntrada = request.getUnidadPeso() != null ? 
            request.getUnidadPeso() : PerfilUsuario.UnidadesMedida.KG;
        var pesoKg = UnidadesUtil.convertirAKg(request.getPeso(), unidadEntrada);
        
        UsuarioHistorialMedidas medicion = UsuarioHistorialMedidas.builder()
            .perfilUsuario(perfil)
            .peso(pesoKg)
            .altura(request.getAltura())
            .fechaMedicion(request.getFechaMedicion())
            .build();
        
        medicion = historialMedidasRepository.save(medicion);
        
        // Convertir a unidad preferida del usuario para la respuesta
        return convertirAResponse(medicion, perfil.getUnidadesMedida());
    }

    /**
     * US-24: Obtener historial de mediciones
     */
    @Transactional(readOnly = true)
    public List<HistorialMedidasResponse> obtenerHistorialMediciones(String email) {
        PerfilUsuario perfil = obtenerPerfilPorEmail(email);
        List<UsuarioHistorialMedidas> historial = historialMedidasRepository
            .findByPerfilUsuarioIdOrderByFechaMedicionDesc(perfil.getId());
        
        return historial.stream()
            .map(m -> convertirAResponse(m, perfil.getUnidadesMedida()))
            .collect(Collectors.toList());
    }
    @Transactional
    public HistorialMedidasResponse actualizarMedicion(String email, Long idMedicion, HistorialMedidasRequest request) {

        PerfilUsuario perfil = obtenerPerfilPorEmail(email);

        UsuarioHistorialMedidas medicion = historialMedidasRepository.findById(idMedicion)
                .orElseThrow(() -> new RuntimeException("Medición no encontrada"));

        // Validar que la medición pertenece al usuario
        if (!medicion.getPerfilUsuario().getId().equals(perfil.getId())) {
            throw new RuntimeException("No tienes permiso para modificar esta medición");
        }

        // Validar duplicado por fecha
        if (historialMedidasRepository.existsByPerfilUsuarioIdAndFechaMedicion(perfil.getId(), request.getFechaMedicion())
                && !medicion.getFechaMedicion().equals(request.getFechaMedicion())) {
            throw new RuntimeException("Ya existe una medición registrada en la misma fecha");
        }

        // Convertir peso a KG
        var unidadEntrada = request.getUnidadPeso() != null ?
                request.getUnidadPeso() : PerfilUsuario.UnidadesMedida.KG;

        var pesoKg = UnidadesUtil.convertirAKg(request.getPeso(), unidadEntrada);

        // Actualizar campos
        medicion.setPeso(pesoKg);
        medicion.setAltura(request.getAltura());
        medicion.setFechaMedicion(request.getFechaMedicion());

        // IMC se recalcula automáticamente (preupdate)
        medicion = historialMedidasRepository.save(medicion);

        return convertirAResponse(medicion, perfil.getUnidadesMedida());
    }

    /**
     * US-24: Eliminar medición corporal
     */
    @Transactional
    public void eliminarMedicion(String email, Long idMedicion) {

        PerfilUsuario perfil = obtenerPerfilPorEmail(email);

        UsuarioHistorialMedidas medicion = historialMedidasRepository.findById(idMedicion)
                .orElseThrow(() -> new RuntimeException("Medición no encontrada"));

        // Verificar que pertenece al usuario
        if (!medicion.getPerfilUsuario().getId().equals(perfil.getId())) {
            throw new RuntimeException("No tienes permiso para eliminar esta medición");
        }

        historialMedidasRepository.delete(medicion);
    }

    /**
     * Obtener información completa del usuario
     * Incluye datos personales, perfil de salud y última medición
     */
    @Transactional(readOnly = true)
    public PerfilCompletoResponse obtenerPerfilCompleto(String email) {
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        
        PerfilUsuario perfil = cuenta.getPerfilUsuario();
        
        // Construir respuesta base
        PerfilCompletoResponse.PerfilCompletoResponseBuilder builder = PerfilCompletoResponse.builder()
            .id(cuenta.getId())
            .email(cuenta.getEmail())
            .rol(cuenta.getRole() != null ? cuenta.getRole().getTipoRol().name() : null)
            .activo(cuenta.getActive())
            .fechaRegistro(cuenta.getCreatedAt())
            .nombre(perfil.getNombre())
            .apellido(perfil.getApellido())
            .nombreCompleto(perfil.getNombre() + " " + perfil.getApellido())
            .unidadesMedida(perfil.getUnidadesMedida())
            .fechaInicioApp(perfil.getFechaInicioApp());
        
        // Agregar perfil de salud si existe
        UsuarioPerfilSalud perfilSalud = perfilSaludRepository.findByPerfilUsuarioId(perfil.getId())
            .orElse(null);
        
        if (perfilSalud != null) {
            List<Etiqueta> etiquetas = etiquetasSaludRepository.findEtiquetasByPerfilId(perfil.getId());
            
            PerfilCompletoResponse.PerfilSaludInfo saludInfo = PerfilCompletoResponse.PerfilSaludInfo.builder()
                .id(perfilSalud.getId())
                .objetivoActual(perfilSalud.getObjetivoActual() != null ? perfilSalud.getObjetivoActual().name() : null)
                .nivelActividadActual(perfilSalud.getNivelActividadActual() != null ? perfilSalud.getNivelActividadActual().name() : null)
                .fechaActualizacion(perfilSalud.getFechaActualizacion())
                .etiquetas(etiquetas.stream()
                    .map(e -> PerfilCompletoResponse.EtiquetaInfo.builder()
                        .id(e.getId())
                        .nombre(e.getNombre())
                        .tipoEtiqueta(e.getTipoEtiqueta() != null ? e.getTipoEtiqueta().name() : null)
                        .descripcion(e.getDescripcion())
                        .build())
                    .collect(Collectors.toList()))
                .build();
            
            builder.perfilSalud(saludInfo);
        }
        
        // Agregar última medición si existe
        List<UsuarioHistorialMedidas> mediciones = historialMedidasRepository
            .findByPerfilUsuarioIdOrderByFechaMedicionDesc(perfil.getId());
        
        builder.totalMediciones(mediciones.size());
        
        if (!mediciones.isEmpty()) {
            UsuarioHistorialMedidas ultimaMedicion = mediciones.get(0);
            var pesoConvertido = UnidadesUtil.convertirDesdeKg(ultimaMedicion.getPeso(), perfil.getUnidadesMedida());
            
            Double imcDouble = ultimaMedicion.getImc() != null ? ultimaMedicion.getImc().doubleValue() : null;
            String categoriaIMC = categorizarIMC(imcDouble);
            
            PerfilCompletoResponse.UltimaMedicionInfo medicionInfo = PerfilCompletoResponse.UltimaMedicionInfo.builder()
                .id(ultimaMedicion.getId())
                .peso(pesoConvertido.doubleValue())
                .altura(ultimaMedicion.getAltura().intValue())
                .imc(imcDouble)
                .fechaMedicion(ultimaMedicion.getFechaMedicion())
                .unidadPeso(perfil.getUnidadesMedida())
                .categoriaIMC(categoriaIMC)
                .build();
            
            builder.ultimaMedicion(medicionInfo);
        }
        
        return builder.build();
    }

    /**
     * Categoriza el IMC según estándares de la OMS
     */
    private String categorizarIMC(Double imc) {
        if (imc == null) return "No disponible";
        if (imc < 18.5) return "Bajo peso";
        if (imc < 25.0) return "Peso normal";
        if (imc < 30.0) return "Sobrepeso";
        return "Obesidad";
    }

    /**
     * Obtener perfil de usuario por email
     */
    private PerfilUsuario obtenerPerfilPorEmail(String email) {
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        return cuenta.getPerfilUsuario();
    }

    /**
     * Convertir medición a DTO de respuesta con unidad preferida del usuario
     */
    private HistorialMedidasResponse convertirAResponse(UsuarioHistorialMedidas medicion, 
                                                        PerfilUsuario.UnidadesMedida unidadPreferida) {
        var pesoConvertido = UnidadesUtil.convertirDesdeKg(medicion.getPeso(), unidadPreferida);
        
        return HistorialMedidasResponse.builder()
            .id(medicion.getId())
            .peso(pesoConvertido)
            .altura(medicion.getAltura())
            .imc(medicion.getImc())
            .fechaMedicion(medicion.getFechaMedicion())
            .unidadPeso(unidadPreferida)
            .build();
    }
}

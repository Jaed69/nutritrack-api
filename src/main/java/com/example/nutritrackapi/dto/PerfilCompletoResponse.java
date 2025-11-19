package com.example.nutritrackapi.dto;

import com.example.nutritrackapi.model.PerfilUsuario;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

/**
 * DTO para respuesta con información completa del usuario
 * Incluye datos personales, perfil de salud y última medición
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilCompletoResponse {
    
    // Datos de cuenta
    private Long id;
    private String email;
    private String rol;
    private Boolean activo;
    private LocalDate fechaRegistro;
    
    // Datos personales
    private String nombre;
    private String apellido;
    private String nombreCompleto;
    private PerfilUsuario.UnidadesMedida unidadesMedida;
    private LocalDate fechaInicioApp;
    
    // Perfil de salud (opcional)
    private PerfilSaludInfo perfilSalud;
    
    // Última medición (opcional)
    private UltimaMedicionInfo ultimaMedicion;
    
    // Estadísticas básicas
    private Integer totalMediciones;
    
    /**
     * Información del perfil de salud del usuario
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PerfilSaludInfo {
        private Long id;
        private String objetivoActual;
        private String nivelActividadActual;
        private LocalDate fechaActualizacion;
        private List<EtiquetaInfo> etiquetas;
    }
    
    /**
     * Información de etiquetas de salud
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EtiquetaInfo {
        private Long id;
        private String nombre;
        private String tipoEtiqueta;
        private String descripcion;
    }
    
    /**
     * Información de la última medición
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UltimaMedicionInfo {
        private Long id;
        private Double peso;
        private Integer altura;
        private Double imc;
        private LocalDate fechaMedicion;
        private PerfilUsuario.UnidadesMedida unidadPeso;
        private String categoriaIMC;
    }
}

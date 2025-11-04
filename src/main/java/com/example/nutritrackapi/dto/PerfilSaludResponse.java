package com.example.nutritrackapi.dto;

import com.example.nutritrackapi.model.Etiqueta;
import com.example.nutritrackapi.model.UsuarioPerfilSalud;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO de respuesta con el perfil de salud del usuario
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerfilSaludResponse {

    private Long id;
    private UsuarioPerfilSalud.ObjetivoSalud objetivoActual;
    private UsuarioPerfilSalud.NivelActividad nivelActividadActual;
    private String notas;
    private List<EtiquetaDTO> etiquetas;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EtiquetaDTO {
        private Long id;
        private String nombre;
        private Etiqueta.TipoEtiqueta tipoEtiqueta;
        private String descripcion;
    }
}

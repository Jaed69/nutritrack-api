package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

/**
 * Entidad UsuarioEtiquetasSalud - Relación Many-to-Many entre Usuario y Etiquetas
 * Almacena alergias y condiciones médicas del usuario
 * Composite Key: (id_perfil, id_etiqueta)
 */
@Entity
@Table(name = "usuario_etiquetas_salud")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(UsuarioEtiquetasSalud.UsuarioEtiquetaId.class)
public class UsuarioEtiquetasSalud {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_perfil", nullable = false)
    private PerfilUsuario perfilUsuario;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_etiqueta", nullable = false)
    private Etiqueta etiqueta;

    /**
     * Clase interna para Composite Key
     * Necesaria para @IdClass cuando se tiene composite key
     */
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class UsuarioEtiquetaId implements Serializable {
        private Long perfilUsuario;
        private Long etiqueta;
    }
}

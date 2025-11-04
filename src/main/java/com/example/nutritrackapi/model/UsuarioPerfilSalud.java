package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entidad UsuarioPerfilSalud - Perfil de salud del usuario
 * Relación 1-to-1 con PerfilUsuario
 * Contiene objetivos de salud y nivel de actividad física
 */
@Entity
@Table(name = "usuario_perfil_salud")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioPerfilSalud {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_perfil", nullable = false, unique = true)
    private PerfilUsuario perfilUsuario;

    @Column(name = "objetivo_actual", length = 50)
    @Enumerated(EnumType.STRING)
    private ObjetivoSalud objetivoActual;

    @Column(name = "nivel_actividad_actual", length = 20)
    @Enumerated(EnumType.STRING)
    private NivelActividad nivelActividadActual;

    @Column(length = 1000)
    private String notas;

    /**
     * Objetivos de salud disponibles en el sistema
     */
    public enum ObjetivoSalud {
        PERDER_PESO,
        GANAR_MASA_MUSCULAR,
        MANTENER_FORMA,
        REHABILITACION,
        CONTROLAR_ESTRES
    }

    /**
     * Niveles de actividad física
     */
    public enum NivelActividad {
        BAJO,      // Sedentario, poco o ningún ejercicio
        MODERADO,  // Ejercicio ligero 1-3 días/semana
        ALTO       // Ejercicio intenso 4-7 días/semana
    }
}

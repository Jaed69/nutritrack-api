package com.example.nutritrackapi.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Entidad Plan - Planes nutricionales con duración fija
 * Un plan es un OBJETIVO COMPLETO que contiene actividades diarias programadas.
 * 
 * US-11: Crear Meta del Catálogo (Plan)
 * US-12: Gestionar Meta (configurar días del plan)
 * US-13: Ver Catálogo de Metas (Admin)
 * US-14: Eliminar Meta
 * RN11: Nombres únicos
 * RN14: No eliminar si tiene usuarios activos
 * RN28: Soft delete (marcar como inactivo)
 */
@Entity
@Table(name = "planes")
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Plan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * RN11: Nombre único del plan
     */
    @Column(nullable = false, unique = true, length = 255)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    /**
     * Duración del plan en días (ej: 30 días, 45 días)
     */
    @Column(name = "duracion_dias", nullable = false)
    private Integer duracionDias;

    /**
     * RN28: Soft delete - si está activo o no
     * false = plan eliminado lógicamente
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Relación 1-to-1 con PlanObjetivo
     * Objetivos nutricionales diarios del plan
     */
    @OneToOne(mappedBy = "plan", cascade = CascadeType.ALL, orphanRemoval = true)
    private PlanObjetivo objetivo;

    /**
     * Relación 1-to-many con PlanDia
     * Actividades diarias programadas del plan
     */
    @OneToMany(mappedBy = "plan", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private Set<PlanDia> dias = new HashSet<>();

    /**
     * Relación many-to-many con Etiqueta
     * Para búsqueda y filtrado
     */
    @ManyToMany
    @JoinTable(
        name = "plan_etiquetas",
        joinColumns = @JoinColumn(name = "id_plan"),
        inverseJoinColumns = @JoinColumn(name = "id_etiqueta")
    )
    @Builder.Default
    private Set<Etiqueta> etiquetas = new HashSet<>();

    /**
     * Helper method para agregar etiqueta
     */
    public void agregarEtiqueta(Etiqueta etiqueta) {
        this.etiquetas.add(etiqueta);
    }

    /**
     * Helper method para remover etiqueta
     */
    public void removerEtiqueta(Etiqueta etiqueta) {
        this.etiquetas.remove(etiqueta);
    }

    /**
     * Helper method para agregar día
     */
    public void agregarDia(PlanDia dia) {
        this.dias.add(dia);
        dia.setPlan(this);
    }

    /**
     * Helper method para remover día
     */
    public void removerDia(PlanDia dia) {
        this.dias.remove(dia);
        dia.setPlan(null);
    }

    @Override
    public String toString() {
        return "Plan{id=" + id + ", nombre='" + nombre + "', duracionDias=" + duracionDias + ", activo=" + activo + "}";
    }
}

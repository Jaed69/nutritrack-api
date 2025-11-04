package com.example.nutritrackapi.repository;

import com.example.nutritrackapi.model.UsuarioPerfilSalud;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioPerfilSaludRepository extends JpaRepository<UsuarioPerfilSalud, Long> {

    /**
     * Buscar perfil de salud por ID del perfil de usuario
     * Relación 1-to-1
     */
    Optional<UsuarioPerfilSalud> findByPerfilUsuarioId(Long perfilUsuarioId);

    /**
     * Verificar si existe perfil de salud para un usuario
     */
    boolean existsByPerfilUsuarioId(Long perfilUsuarioId);

    /**
     * Eliminar perfil de salud por ID del perfil de usuario
     */
    void deleteByPerfilUsuarioId(Long perfilUsuarioId);
}

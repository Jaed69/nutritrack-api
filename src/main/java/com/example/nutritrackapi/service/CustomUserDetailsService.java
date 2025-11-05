package com.example.nutritrackapi.service;

import com.example.nutritrackapi.model.CuentaAuth;
import com.example.nutritrackapi.repository.CuentaAuthRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Collections;

/**
 * Servicio para cargar los detalles del usuario desde la base de datos
 * Requerido por Spring Security para autenticación
 */
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final CuentaAuthRepository cuentaAuthRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + email));

        return User.builder()
                .username(cuenta.getEmail())
                .password(cuenta.getPassword())
                .authorities(getAuthorities(cuenta))
                .accountExpired(false)
                .accountLocked(!cuenta.getActive())
                .credentialsExpired(false)
                .disabled(!cuenta.getActive())
                .build();
    }

    private Collection<? extends GrantedAuthority> getAuthorities(CuentaAuth cuenta) {
        // El enum TipoRol ya incluye el prefijo ROLE_ (ej: ROLE_ADMIN, ROLE_USER)
        return Collections.singletonList(
                new SimpleGrantedAuthority(cuenta.getRole().getTipoRol().name())
        );
    }
}

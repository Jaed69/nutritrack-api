package com.example.nutritrackapi.service;

import com.example.nutritrackapi.dto.AuthResponse;
import com.example.nutritrackapi.dto.DeleteAccountRequest;
import com.example.nutritrackapi.dto.LoginRequest;
import com.example.nutritrackapi.dto.RegisterRequest;
import com.example.nutritrackapi.model.CuentaAuth;
import com.example.nutritrackapi.model.PerfilUsuario;
import com.example.nutritrackapi.model.Role;
import com.example.nutritrackapi.repository.CuentaAuthRepository;
import com.example.nutritrackapi.repository.PerfilUsuarioRepository;
import com.example.nutritrackapi.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final CuentaAuthRepository cuentaAuthRepository;
    private final PerfilUsuarioRepository perfilUsuarioRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        log.info("Registrando nuevo usuario: {}", request.getEmail());

        // Validar email único
        if (cuentaAuthRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("El email ya está registrado");
        }

        // Obtener rol USER por defecto
        Role userRole = roleRepository.findByTipoRol(Role.TipoRol.ROLE_USER)
                .orElseThrow(() -> new RuntimeException("Rol USER no encontrado"));

        // Crear cuenta
        CuentaAuth cuenta = CuentaAuth.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .active(true)
                .role(userRole)
                .build();

        cuenta = cuentaAuthRepository.save(cuenta);

        // Crear perfil
        PerfilUsuario perfil = PerfilUsuario.builder()
                .nombre(request.getNombre())
                .apellido(request.getApellido())
                .cuenta(cuenta)
                .build();

        perfil = perfilUsuarioRepository.save(perfil);

        log.info("Usuario registrado exitosamente: {}", cuenta.getEmail());

        // Generar token JWT
        final CuentaAuth finalCuenta = cuenta;
        UserDetails userDetails = User.builder()
                .username(finalCuenta.getEmail())
                .password(finalCuenta.getPassword())
                .authorities(Collections.singletonList(() -> "ROLE_" + finalCuenta.getRole().getTipoRol().name()))
                .build();
        
        String jwtToken = jwtService.generateToken(userDetails);

        return AuthResponse.builder()
                .token(jwtToken)
                .email(cuenta.getEmail())
                .nombre(perfil.getNombre())
                .apellido(perfil.getApellido())
                .role(cuenta.getRole().getTipoRol().name())
                .userId(cuenta.getId())
                .perfilId(perfil.getId())
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        log.info("Intento de login: {}", request.getEmail());

        // Buscar cuenta
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Credenciales inválidas"));

        // Verificar contraseña
        if (!passwordEncoder.matches(request.getPassword(), cuenta.getPassword())) {
            throw new RuntimeException("Credenciales inválidas");
        }

        // Verificar que la cuenta esté activa
        if (!cuenta.getActive()) {
            throw new RuntimeException("Cuenta inactiva");
        }

        // Obtener perfil
        PerfilUsuario perfil = perfilUsuarioRepository.findByCuentaId(cuenta.getId())
                .orElseThrow(() -> new RuntimeException("Perfil no encontrado"));

        log.info("Login exitoso: {}", cuenta.getEmail());

        // Generar token JWT
        final CuentaAuth finalCuenta = cuenta;
        UserDetails userDetails = User.builder()
                .username(finalCuenta.getEmail())
                .password(finalCuenta.getPassword())
                .authorities(Collections.singletonList(() -> "ROLE_" + finalCuenta.getRole().getTipoRol().name()))
                .build();
        
        String jwtToken = jwtService.generateToken(userDetails);

        return AuthResponse.builder()
                .token(jwtToken)
                .email(cuenta.getEmail())
                .nombre(perfil.getNombre())
                .apellido(perfil.getApellido())
                .role(cuenta.getRole().getTipoRol().name())
                .userId(cuenta.getId())
                .perfilId(perfil.getId())
                .build();
    }

    /**
     * US-05: Eliminar cuenta
     * RN05: Requiere confirmación explícita escribiendo "ELIMINAR"
     * Cascade delete eliminará automáticamente perfil, mediciones, etiquetas, etc.
     */
    @Transactional
    public void eliminarCuenta(String email, DeleteAccountRequest request) {
        log.info("Eliminando cuenta: {}", email);

        // Validación ya está en el DTO con @Pattern
        if (!"ELIMINAR".equals(request.getConfirmacion())) {
            throw new RuntimeException("Confirmación incorrecta. Debes escribir exactamente 'ELIMINAR'");
        }

        // Buscar y eliminar cuenta (cascade eliminará todo lo relacionado)
        CuentaAuth cuenta = cuentaAuthRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada"));

        cuentaAuthRepository.delete(cuenta);
        
        log.info("Cuenta eliminada exitosamente: {}", email);
    }
}

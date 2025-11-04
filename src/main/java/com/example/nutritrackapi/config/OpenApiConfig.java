package com.example.nutritrackapi.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    private static final String SECURITY_SCHEME_NAME = "Bearer Authentication";

    @Bean
    public OpenAPI nutriTrackOpenAPI() {
        Server devServer = new Server();
        devServer.setUrl("http://localhost:8080");
        devServer.setDescription("Server URL in Development environment");

        Contact contact = new Contact();
        contact.setName("NutriTrack Team");
        contact.setEmail("support@nutritrack.com");

        License mitLicense = new License()
                .name("MIT License")
                .url("https://choosealicense.com/licenses/mit/");

        Info info = new Info()
                .title("NutriTrack API")
                .version("1.0.0")
                .contact(contact)
                .description("""
                    API para gestión de nutrición y seguimiento de objetivos de salud.
                    
                    ## 🔐 Autenticación
                    
                    1. **Registrarse**: POST `/api/v1/auth/registro` - Crea una cuenta nueva
                    2. **Login**: POST `/api/v1/auth/login` - Retorna un token JWT
                    3. **Autorizar**: Haz clic en el botón 🔓 "Authorize" arriba
                    4. **Pegar token**: Ingresa el token (sin "Bearer ") y haz clic en "Authorize"
                    5. **Usar API**: Ahora puedes usar todos los endpoints protegidos
                    
                    El token expira en 24 horas. Vuelve a hacer login cuando expire.
                    
                    ## Organización por Módulos
                    
                    ### Módulo 1: Autenticación y Perfil (Leonel Alzamora)
                    - US-01: Crear cuenta
                    - US-02: Iniciar sesión
                    - US-03: Editar perfil
                    - US-04: Actualizar perfil de salud
                    - US-05: Eliminar cuenta
                    
                    ### Módulo 2: Biblioteca de Contenido - Admin (Fabián Rojas)
                    - US-06: Gestionar Etiquetas
                    - US-07: Gestionar Ingredientes
                    - US-08: Gestionar Ejercicios
                    - US-09: Gestionar Comidas
                    - US-10: Gestionar Recetas (ingredientes de comida)
                    """)
                .license(mitLicense);

        // Configuración de seguridad JWT
        SecurityScheme securityScheme = new SecurityScheme()
                .name(SECURITY_SCHEME_NAME)
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .description("Ingresa el token JWT obtenido del login (sin prefijo 'Bearer ')");

        SecurityRequirement securityRequirement = new SecurityRequirement()
                .addList(SECURITY_SCHEME_NAME);

        return new OpenAPI()
                .info(info)
                .servers(List.of(devServer))
                .addSecurityItem(securityRequirement)
                .components(new Components()
                        .addSecuritySchemes(SECURITY_SCHEME_NAME, securityScheme));
    }
}

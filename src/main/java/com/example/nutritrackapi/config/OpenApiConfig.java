package com.example.nutritrackapi.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

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
                    
                    ## Autenticación
                    La mayoría de endpoints requieren autenticación JWT. Use el endpoint `/api/v1/auth/login` para obtener el token.
                    """)
                .license(mitLicense);

        return new OpenAPI()
                .info(info)
                .servers(List.of(devServer));
    }
}

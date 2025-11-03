package com.nutritrack.nutritrackapi.exception;

public class ActividadNoEncontradaException extends RuntimeException {

    public ActividadNoEncontradaException(Long idActividad) {
        super("No se encontró la actividad con ID: " + idActividad);
    }
}

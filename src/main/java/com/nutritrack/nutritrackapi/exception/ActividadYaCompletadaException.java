package com.nutritrack.nutritrackapi.exception;

public class ActividadYaCompletadaException extends RuntimeException {

    public ActividadYaCompletadaException(Long idActividad) {
        super("La actividad con ID " + idActividad + " ya fue completada previamente.");
    }
}

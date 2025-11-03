package com.nutritrack.nutritrackapi.exception;

public class MetaNoActivaException extends RuntimeException {

    public MetaNoActivaException(Long idMetaAsignada) {
        super("No se pueden modificar actividades porque la meta asignada (ID " + idMetaAsignada + ") no está activa.");
    }
}

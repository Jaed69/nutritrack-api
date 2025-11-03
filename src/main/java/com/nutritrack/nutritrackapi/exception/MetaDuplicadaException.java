package com.nutritrack.nutritrackapi.exception;

public class MetaDuplicadaException extends RuntimeException {

    public MetaDuplicadaException(String nombreMeta) {
        super("Ya existe una meta con el nombre: " + nombreMeta);
    }
}

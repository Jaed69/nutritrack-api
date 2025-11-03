package com.nutritrack.nutritrackapi.exception;

public class MetaNoEncontradaException extends RuntimeException {

    public MetaNoEncontradaException(Long idMeta) {
        super("No se encontró la meta con ID: " + idMeta);
    }
}

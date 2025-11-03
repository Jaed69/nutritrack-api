package com.nutritrack.nutritrackapi.exception;

public class MetaConUsuariosActivosException extends RuntimeException {

    public MetaConUsuariosActivosException(Long idMeta) {
        super("No se puede eliminar la meta con ID " + idMeta + " porque tiene usuarios activos asociados.");
    }
}

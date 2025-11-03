package com.nutritrack.nutritrackapi.exception;
import java.util.UUID;

public class MetaActivaExistenteException extends RuntimeException {

    public MetaActivaExistenteException(UUID idCliente) {
        super("El cliente con ID " + idCliente + " ya tiene una meta activa.");
    }
}

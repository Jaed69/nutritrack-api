package com.example.nutritrackapi.util;

import com.example.nutritrackapi.model.PerfilUsuario;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Utilidades para conversión de unidades de medida
 * RN27: Almacenar siempre en KG/CM, convertir en presentación
 */
public class UnidadesUtil {

    private static final BigDecimal KG_TO_LBS = BigDecimal.valueOf(2.20462);
    private static final BigDecimal LBS_TO_KG = BigDecimal.ONE.divide(KG_TO_LBS, 6, RoundingMode.HALF_UP);

    /**
     * Convierte peso a kilogramos (unidad estándar para BD)
     */
    public static BigDecimal convertirAKg(BigDecimal peso, PerfilUsuario.UnidadesMedida unidad) {
        if (peso == null) return null;
        if (unidad == null || unidad == PerfilUsuario.UnidadesMedida.KG) {
            return peso;
        }
        // Convertir de LBS a KG
        return peso.multiply(LBS_TO_KG).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Convierte peso desde kilogramos a la unidad especificada
     */
    public static BigDecimal convertirDesdeKg(BigDecimal pesoKg, PerfilUsuario.UnidadesMedida unidadDestino) {
        if (pesoKg == null) return null;
        if (unidadDestino == null || unidadDestino == PerfilUsuario.UnidadesMedida.KG) {
            return pesoKg;
        }
        // Convertir de KG a LBS
        return pesoKg.multiply(KG_TO_LBS).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Obtiene el símbolo de la unidad de medida
     */
    public static String getSimboloUnidad(PerfilUsuario.UnidadesMedida unidad) {
        return unidad == PerfilUsuario.UnidadesMedida.KG ? "kg" : "lbs";
    }
}

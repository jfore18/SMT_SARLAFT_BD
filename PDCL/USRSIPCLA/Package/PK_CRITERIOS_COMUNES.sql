PROMPT CREATE OR REPLACE PACKAGE pk_criterios_comunes
CREATE OR REPLACE PACKAGE pk_criterios_comunes --Criterios de inusualidad comunes (parte fija de la transaccion)
IS

   FUNCTION f_actividad_econ_critica  (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_cliente_negativo        (idCriterio NUMBER) RETURN NUMBER; --ADD CPB 30ABR2004
   FUNCTION f_cliente_PEPs            (idCriterio NUMBER) RETURN NUMBER; --ADD CPB 30ABR2004
   FUNCTION f_id_en_listas            (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_longitud_id             (idCriterio NUMBER, nDigitosId NUMBER, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_nit_bbogota             (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_nombre_en_listas        (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_mayor_valor_mil_mill (idCriterio NUMBER, valor NUMBER) RETURN NUMBER;
   FUNCTION f_tr_clementine           (idCriterio NUMBER, nivelC VARCHAR2, nivelT VARCHAR2, nivelI VARCHAR2) RETURN NUMBER;

END;
/


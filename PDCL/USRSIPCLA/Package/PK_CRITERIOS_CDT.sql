PROMPT CREATE OR REPLACE PACKAGE pk_criterios_cdt
CREATE OR REPLACE PACKAGE pk_criterios_cdt --Criterios inusualidad CDTs
IS

   FUNCTION f_cancelacion_titulo     (idCriterio NUMBER, codigoTr VARCHAR2) RETURN NUMBER;
   FUNCTION f_menor_edad             (idCriterio NUMBER, valor NUMBER, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_plazo_corto            (idCriterio NUMBER, valor NUMBER, nDiasPlazo VARCHAR2) RETURN NUMBER;
   FUNCTION f_titulo_reciente        (idCriterio NUMBER, nDiasPostApertura NUMBER) RETURN NUMBER;
   FUNCTION f_tr_anterior_a_apertura (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_antigua_proceso     (idCriterio NUMBER, nDiasPostProceso NUMBER) RETURN NUMBER;
   FUNCTION f_tr_en_fecha_apertura   (idCriterio NUMBER) RETURN NUMBER;

END;
/


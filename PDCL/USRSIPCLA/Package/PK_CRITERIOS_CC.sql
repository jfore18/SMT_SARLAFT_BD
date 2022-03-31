PROMPT CREATE OR REPLACE PACKAGE pk_criterios_cc
CREATE OR REPLACE PACKAGE pk_criterios_cc --Criterios inusualidad cuenta corriente
IS

   FUNCTION f_acumulado_credito        (idCriterio NUMBER, valor NUMBER, tipoId VARCHAR2, acumuladoSIPLA NUMBER) RETURN NUMBER;
   FUNCTION f_canje_errado             (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2) RETURN NUMBER;
   FUNCTION f_cuenta_cheques_gerencia  (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_cuenta_generica          (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_cuenta_no_activa         (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_cuenta_reabierta         (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_cuenta_reciente          (idCriterio NUMBER, nDiasPostApertura NUMBER) RETURN NUMBER;
   FUNCTION f_cuenta_sobregiro         (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_deposito_elec_credibanco (idCriterio NUMBER, codigoTr VARCHAR2, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_longitud_cuenta          (idCriterio NUMBER, nDigitosCuenta NUMBER) RETURN NUMBER;
   FUNCTION f_mayorValor_codTr         (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2) RETURN NUMBER;
   FUNCTION f_mayorValor_codTr_tipoID  (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_pitufeo                  (idCriterio NUMBER, porcentaje NUMBER) RETURN NUMBER;
   FUNCTION f_plazas_no_logicas        (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_plaza_critica            (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_promedio_negativo        (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_anterior_a_apertura   (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_antigua_proceso       (idCriterio NUMBER, nDiasPostProceso NUMBER) RETURN NUMBER;
   FUNCTION f_tr_en_fecha_apertura     (idCriterio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_supera_promedio       (idCriterio NUMBER, nVecesPromedio NUMBER) RETURN NUMBER;
   FUNCTION f_tr_supera_saldo          (idCriterio NUMBER, nVecesSaldo NUMBER)    RETURN NUMBER;
   FUNCTION f_transfer_supera_promedio (idCriterio NUMBER, nVecesPromedio NUMBER, codigoTr VARCHAR2) RETURN NUMBER;

END;
/


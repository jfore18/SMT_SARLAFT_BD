PROMPT CREATE OR REPLACE PACKAGE pk_criterios_cd
CREATE OR REPLACE PACKAGE pk_criterios_cd --Criterios compra de divisas
IS

   FUNCTION f_operaciones_beneficiario (nOperaciones NUMBER, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_mayorValor (valor NUMBER) RETURN NUMBER;
   FUNCTION f_repeticion_transaccion (valor NUMBER, nRepeticiones NUMBER) RETURN NUMBER;
   FUNCTION f_paraiso_fiscal RETURN NUMBER;
   FUNCTION f_donacion (numeralCambiario NUMBER) RETURN NUMBER;

END;
/


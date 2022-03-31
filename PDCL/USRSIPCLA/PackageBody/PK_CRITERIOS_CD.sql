PROMPT CREATE OR REPLACE PACKAGE BODY pk_criterios_cd
CREATE OR REPLACE PACKAGE BODY pk_criterios_cd
IS

   FUNCTION f_operaciones_beneficiario (nOperaciones NUMBER, tipoId VARCHAR2) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


   FUNCTION f_mayorValor (valor NUMBER) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


   FUNCTION f_repeticion_transaccion (valor NUMBER, nRepeticiones NUMBER) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


   FUNCTION f_paraiso_fiscal RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


   FUNCTION f_donacion (numeralCambiario NUMBER) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


END;
/


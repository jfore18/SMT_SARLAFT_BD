PROMPT CREATE OR REPLACE PACKAGE BODY pk_criterios_vd
CREATE OR REPLACE PACKAGE BODY pk_criterios_vd
IS

   FUNCTION f_mayorValor_tipoID (valor NUMBER, tipoId VARCHAR2) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;


   FUNCTION f_paraiso_fiscal RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END;

END;
/


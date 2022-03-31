PROMPT CREATE OR REPLACE PACKAGE pk_criterios_vd
CREATE OR REPLACE PACKAGE pk_criterios_vd --Criterios venta de divisas
IS

   FUNCTION f_mayorValor_tipoID (valor NUMBER, tipoId VARCHAR2) RETURN NUMBER;
   FUNCTION f_paraiso_fiscal RETURN NUMBER;

END;
/


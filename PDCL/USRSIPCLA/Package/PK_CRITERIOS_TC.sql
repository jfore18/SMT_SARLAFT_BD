PROMPT CREATE OR REPLACE PACKAGE pk_criterios_tc
CREATE OR REPLACE PACKAGE pk_criterios_tc --Criterios tarjeta de crédito
IS

   FUNCTION f_retiros_exterior (valor NUMBER, nRetiros NUMBER, codigoTr VARCHAR2) RETURN NUMBER;

END;
/


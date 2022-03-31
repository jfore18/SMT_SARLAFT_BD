PROMPT CREATE OR REPLACE TRIGGER ti_cargos
CREATE OR REPLACE TRIGGER ti_cargos
  after insert on cargos
  for each row
 /*
 Creación de trigger para el registro en la bitacora de la estructura CARGOS después de insertar un registro
 Requerimiento 378248-Administracion de usuarios
 Ana María Bocanegra Misas
 octubre 2018
 */
declare
  -- declaracion de variables
  VN_SECUENCIA NUMBER(10);

begin

   -- 1. Obtenemos la secuencia de log
   SELECT SQ_SMT_CARGO_LOG.NEXTVAL INTO VN_SECUENCIA FROM DUAL;

   -- 2. Insertamos registro en la bitacora
   INSERT INTO TBL_SMT_CARGO_LOG (ID_SECUENCIA,FECHA_EVENTO,USUARIO_EVENTO,EVENTO,CARGO,
   CAMPO,VALOR_ACTUAL,VALOR_ANTERIOR,DETALLE) VALUES
   (VN_SECUENCIA,:NEW.FECHA_CREACION,:NEW.USUARIO_CREACION,1,:NEW.CODIGO,
   '','','','Se creó el cargo:'||:NEW.CODIGO ||' asociado al usuario: ' ||:NEW.CODIGO_USUARIO);

end TI_CARGOS;
/


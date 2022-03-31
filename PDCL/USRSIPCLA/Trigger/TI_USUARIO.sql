PROMPT CREATE OR REPLACE TRIGGER ti_usuario
CREATE OR REPLACE TRIGGER ti_usuario
  after insert on usuario
  for each row
 /*
 Creación de trigger para el registro en la bitacora de la estructura usuario cuando se crea un nuevo registro
 Requerimiento 378248-Administracion de usuarios
 Ana María Bocanegra Misas
 octubre 2018
  */
declare
  -- declaracion de variables
  VN_SECUENCIA NUMBER(10);

begin

  -- 1. Obtenemos la secuencia de log
  SELECT SQ_SMT_USUARIO_LOG.NEXTVAL INTO VN_SECUENCIA FROM DUAL;
  -- 2. Insertamos registro en la bitacora
  INSERT INTO TBL_SMT_USUARIO_LOG(ID_SECUENCIA,FECHA_EVENTO,USUARIO_EVENTO,
  EVENTO,USUARIO,CAMPO,VALOR_ACTUAL,VALOR_ANTERIOR,DETALLE)
  VALUES(VN_SECUENCIA,:NEW.FECHA_CREACION,:NEW.USUARIO_CREACION,'1',:NEW.CEDULA,
  '','','','Se creó el usuario:'||:NEW.CEDULA ||'. Estado:' || :NEW.ACTIVO);
end TI_USUARIO;
/


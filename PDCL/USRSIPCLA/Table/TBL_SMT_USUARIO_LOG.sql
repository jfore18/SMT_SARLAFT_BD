PROMPT CREATE TABLE tbl_smt_usuario_log
CREATE TABLE tbl_smt_usuario_log (
  id_secuencia   NUMBER(10,0) NOT NULL,
  fecha_evento   DATE         NULL,
  usuario_evento NUMBER(10,0) NULL,
  evento         NUMBER(1,0)  NULL,
  usuario        NUMBER(10,0) NULL,
  campo          VARCHAR2(20) NULL,
  valor_actual   VARCHAR2(50) NULL,
  valor_anterior VARCHAR2(50) NULL,
  detalle        VARCHAR2(70) NULL
)
  STORAGE (
    INITIAL      64 K
    NEXT       1024 K
  )
/

COMMENT ON COLUMN tbl_smt_usuario_log.id_secuencia IS 'Secuencia del evento';
COMMENT ON COLUMN tbl_smt_usuario_log.fecha_evento IS 'Fecha en que ocurre el evento';
COMMENT ON COLUMN tbl_smt_usuario_log.usuario_evento IS 'Identificacion del usuario que genera el evento';
COMMENT ON COLUMN tbl_smt_usuario_log.evento IS '1-Creacion, 2-Modificacion';
COMMENT ON COLUMN tbl_smt_usuario_log.usuario IS 'Identificacion del usuario sobre el cual ocurre el evento';
COMMENT ON COLUMN tbl_smt_usuario_log.campo IS 'Dato del usuario modificado en el evento 2-Modificacion';
COMMENT ON COLUMN tbl_smt_usuario_log.valor_actual IS 'Valor del campo después de la modificacion';
COMMENT ON COLUMN tbl_smt_usuario_log.valor_anterior IS 'Valor del campo antes de la modificacion';
COMMENT ON COLUMN tbl_smt_usuario_log.detalle IS 'Detalle del evento';


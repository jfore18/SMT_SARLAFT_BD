PROMPT CREATE TABLE log_transaccional
CREATE TABLE log_transaccional (
  secuencia      NUMBER(10,0)  NOT NULL,
  fecha_sistema  DATE          NOT NULL,
  hora_sistema   DATE          NOT NULL,
  codigo_archivo NUMBER(5,0)   NULL,
  fecha_proceso  DATE          NULL,
  id_transaccion NUMBER(5,0)   NULL,
  detalle        VARCHAR2(100) NULL,
  id_proceso     NUMBER(10,0)  NULL,
  codigo_proceso VARCHAR2(3)   NULL
)
  STORAGE (
    INITIAL      64 K
    NEXT       1024 K
  )
/



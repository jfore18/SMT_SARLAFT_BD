PROMPT CREATE TABLE criterios_transaccion
CREATE TABLE criterios_transaccion (
  codigo_archivo          NUMBER(5,0)  NOT NULL,
  fecha_proceso           DATE         NOT NULL,
  id_transaccion          NUMBER(5,0)  NOT NULL,
  id_criterio_inusualidad NUMBER(5,0)  NOT NULL,
  codigo_tipolista_v      VARCHAR2(3)  NULL,
  usuario_creacion        NUMBER(10,0) NULL,
  fecha_creacion          DATE         NULL
)
  STORAGE (
    INITIAL   20480 K
    NEXT       1024 K
  )
/



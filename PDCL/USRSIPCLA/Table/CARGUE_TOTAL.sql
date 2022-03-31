PROMPT CREATE TABLE cargue_total
CREATE TABLE cargue_total (
  fecha_proceso         DATE           NOT NULL,
  codigo_archivo        NUMBER(5,0)    NOT NULL,
  secuencia_transaccion NUMBER(5,0)    NOT NULL,
  codigo_mensaje        NUMBER(5,0)    NULL,
  registro              VARCHAR2(2000) NULL
)
  STORAGE (
    INITIAL    2800 K
    NEXT       1024 K
  )
/



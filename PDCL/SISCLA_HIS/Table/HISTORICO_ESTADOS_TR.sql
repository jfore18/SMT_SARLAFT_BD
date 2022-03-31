PROMPT CREATE TABLE historico_estados_tr
CREATE TABLE historico_estados_tr (
  id                    NUMBER(10,0) NOT NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  codigo_archivo        NUMBER(5,0)  NOT NULL,
  fecha_proceso         DATE         NOT NULL,
  id_transaccion        NUMBER(5,0)  NOT NULL,
  codigo_estado_v       VARCHAR2(3)  NULL,
  fecha_actualizacion   DATE         NULL,
  codigo_cargo          VARCHAR2(6)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



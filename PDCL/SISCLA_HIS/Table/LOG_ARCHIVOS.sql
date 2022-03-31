PROMPT CREATE TABLE log_archivos
CREATE TABLE log_archivos (
  codigo_archivo       NUMBER(5,0)  NOT NULL,
  fecha_proceso        DATE         NOT NULL,
  codigo_mensaje       NUMBER(5,0)  NULL,
  registros_reportados NUMBER(10,0) NULL,
  registros_procesados NUMBER(10,0) NULL,
  usuario_creacion     NUMBER(10,0) NULL,
  fecha_creacion       DATE         NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



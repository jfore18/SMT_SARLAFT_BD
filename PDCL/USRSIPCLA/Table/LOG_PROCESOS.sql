PROMPT CREATE TABLE log_procesos
CREATE TABLE log_procesos (
  id_proceso           NUMBER(10,0) NOT NULL,
  codigo_proceso       VARCHAR2(3)  NOT NULL,
  fecha_hora_inicio    DATE         NOT NULL,
  fecha_hora_fin       DATE         NULL,
  registros_procesados NUMBER(10,0) NULL,
  usuario              NUMBER(10,0) NULL,
  codigo_mensaje       NUMBER(5,0)  NULL
)
  STORAGE (
    INITIAL     144 K
  )
/



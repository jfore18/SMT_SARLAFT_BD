PROMPT CREATE TABLE log_errores
CREATE TABLE log_errores (
  id_proceso NUMBER(10,0)  NULL,
  fecha      DATE          NULL,
  error      VARCHAR2(200) NULL,
  usuario    NUMBER(10,0)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



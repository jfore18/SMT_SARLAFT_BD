PROMPT CREATE TABLE log_ingreso
CREATE TABLE log_ingreso (
  id           NUMBER NOT NULL,
  fecha_login  DATE   NULL,
  fecha_logoff DATE   NULL,
  usuario      NUMBER NULL
)
  STORAGE (
    INITIAL   10240 K
  )
/



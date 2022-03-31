PROMPT CREATE INDEX pk_log_ingreso
CREATE UNIQUE INDEX pk_log_ingreso
  ON log_ingreso (
    id
  )
  STORAGE (
    INITIAL    1024 K
  )
/


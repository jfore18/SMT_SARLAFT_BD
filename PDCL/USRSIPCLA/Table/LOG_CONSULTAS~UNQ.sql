PROMPT ALTER TABLE log_consultas ADD CONSTRAINT pk_consecutivo PRIMARY KEY
ALTER TABLE log_consultas
  ADD CONSTRAINT pk_consecutivo PRIMARY KEY (
    consecutivo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE tbl_smt_usuario_log ADD CONSTRAINT pk_secuencia PRIMARY KEY
ALTER TABLE tbl_smt_usuario_log
  ADD CONSTRAINT pk_secuencia PRIMARY KEY (
    id_secuencia
  )
  USING INDEX
    STORAGE (
      INITIAL      64 K
      NEXT       1024 K
    )
/


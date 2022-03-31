PROMPT ALTER TABLE tbl_smt_cargo_log ADD CONSTRAINT pk_secuencia_cargo PRIMARY KEY
ALTER TABLE tbl_smt_cargo_log
  ADD CONSTRAINT pk_secuencia_cargo PRIMARY KEY (
    id_secuencia
  )
  USING INDEX
    STORAGE (
      INITIAL      64 K
      NEXT       1024 K
    )
/


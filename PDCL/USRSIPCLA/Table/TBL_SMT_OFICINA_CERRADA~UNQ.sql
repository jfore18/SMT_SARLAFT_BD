PROMPT ALTER TABLE tbl_smt_oficina_cerrada ADD CONSTRAINT pk_oficina PRIMARY KEY
ALTER TABLE tbl_smt_oficina_cerrada
  ADD CONSTRAINT pk_oficina PRIMARY KEY (
    oficina_cierra,
    oficina_recibe
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


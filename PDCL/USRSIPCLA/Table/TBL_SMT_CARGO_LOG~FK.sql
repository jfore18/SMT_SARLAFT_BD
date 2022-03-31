PROMPT ALTER TABLE tbl_smt_cargo_log ADD CONSTRAINT fk_cargo FOREIGN KEY
ALTER TABLE tbl_smt_cargo_log
  ADD CONSTRAINT fk_cargo FOREIGN KEY (
    cargo
  ) REFERENCES cargos (
    codigo
  )
/


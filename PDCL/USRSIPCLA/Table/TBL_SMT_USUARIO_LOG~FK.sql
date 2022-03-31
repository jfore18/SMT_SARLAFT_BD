PROMPT ALTER TABLE tbl_smt_usuario_log ADD CONSTRAINT fk_usuario FOREIGN KEY
ALTER TABLE tbl_smt_usuario_log
  ADD CONSTRAINT fk_usuario FOREIGN KEY (
    usuario
  ) REFERENCES usuario (
    cedula
  )
/


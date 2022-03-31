PROMPT ALTER TABLE historico_usuario_cargo ADD FOREIGN KEY
ALTER TABLE historico_usuario_cargo
  ADD FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
/


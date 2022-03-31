PROMPT ALTER TABLE historico_estados_tr ADD FOREIGN KEY
ALTER TABLE historico_estados_tr
  ADD FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE historico_estados_tr ADD FOREIGN KEY
ALTER TABLE historico_estados_tr
  ADD FOREIGN KEY (
    usuario_actualizacion
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/


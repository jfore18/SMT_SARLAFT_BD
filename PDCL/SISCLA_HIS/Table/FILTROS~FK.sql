PROMPT ALTER TABLE filtros ADD FOREIGN KEY
ALTER TABLE filtros
  ADD FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE filtros ADD FOREIGN KEY
ALTER TABLE filtros
  ADD FOREIGN KEY (
    usuario_creacion
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE filtros ADD CONSTRAINT fk_filtro_us_conf_usuario FOREIGN KEY
ALTER TABLE filtros
  ADD CONSTRAINT fk_filtro_us_conf_usuario FOREIGN KEY (
    usuario_confirmacion
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/


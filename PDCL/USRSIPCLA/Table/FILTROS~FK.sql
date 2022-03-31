PROMPT ALTER TABLE filtros ADD FOREIGN KEY
ALTER TABLE filtros
  ADD FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
/

PROMPT ALTER TABLE filtros ADD FOREIGN KEY
ALTER TABLE filtros
  ADD FOREIGN KEY (
    usuario_creacion
  ) REFERENCES usuario (
    cedula
  )
/

PROMPT ALTER TABLE filtros ADD CONSTRAINT fk_filtro_us_conf_usuario FOREIGN KEY
ALTER TABLE filtros
  ADD CONSTRAINT fk_filtro_us_conf_usuario FOREIGN KEY (
    usuario_confirmacion
  ) REFERENCES usuario (
    cedula
  )
/

PROMPT ALTER TABLE filtros ADD CONSTRAINT fk_filtro_us_supervisor FOREIGN KEY
ALTER TABLE filtros
  ADD CONSTRAINT fk_filtro_us_supervisor FOREIGN KEY (
    usuario_supervisor
  ) REFERENCES usuario (
    cedula
  )
/


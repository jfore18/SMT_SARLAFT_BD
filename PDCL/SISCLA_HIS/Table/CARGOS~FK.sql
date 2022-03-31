PROMPT ALTER TABLE cargos ADD CONSTRAINT fk_cargo_un FOREIGN KEY
ALTER TABLE cargos
  ADD CONSTRAINT fk_cargo_un FOREIGN KEY (
    codigo_unidad_negocio
  ) REFERENCES unidades_negocio (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE cargos ADD CONSTRAINT fk_cargo_usuario FOREIGN KEY
ALTER TABLE cargos
  ADD CONSTRAINT fk_cargo_usuario FOREIGN KEY (
    codigo_usuario
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/


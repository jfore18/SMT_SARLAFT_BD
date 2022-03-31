PROMPT ALTER TABLE analista_region ADD FOREIGN KEY
ALTER TABLE analista_region
  ADD FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
  DISABLE
  NOVALIDATE
/


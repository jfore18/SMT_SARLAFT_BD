PROMPT ALTER TABLE reporte ADD CONSTRAINT fk_reporte_cargo FOREIGN KEY
ALTER TABLE reporte
  ADD CONSTRAINT fk_reporte_cargo FOREIGN KEY (
    codigo_cargo
  ) REFERENCES cargos (
    codigo
  )
  DISABLE
  NOVALIDATE
/


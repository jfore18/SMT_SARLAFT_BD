PROMPT ALTER TABLE unidades_negocio ADD FOREIGN KEY
ALTER TABLE unidades_negocio
  ADD FOREIGN KEY (
    codigo_zona,
    codigo_region_v
  ) REFERENCES zonas (
    codigo,
    codigo_region_v
  )
  DISABLE
  NOVALIDATE
/


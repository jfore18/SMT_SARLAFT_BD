PROMPT CREATE INDEX in_unneg_regzon
CREATE INDEX in_unneg_regzon
  ON unidades_negocio (
    codigo_region_v,
    codigo_zona
  )
  STORAGE (
    NEXT       1024 K
  )
/


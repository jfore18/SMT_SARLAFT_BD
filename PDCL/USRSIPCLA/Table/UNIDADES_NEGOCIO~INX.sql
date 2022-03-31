PROMPT CREATE INDEX in_unneg_regzon
CREATE INDEX in_unneg_regzon
  ON unidades_negocio (
    codigo_region_v,
    codigo_zona
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_un_ismg
CREATE INDEX in_un_ismg
  ON unidades_negocio (
    is_megabanco
  )
  STORAGE (
    NEXT       1024 K
  )
/


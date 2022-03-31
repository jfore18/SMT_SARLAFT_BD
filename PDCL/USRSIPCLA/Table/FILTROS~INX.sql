PROMPT CREATE INDEX idx_confirmar
CREATE INDEX idx_confirmar
  ON filtros (
    confirmar
  )
  INITRANS   6
  STORAGE (
    INITIAL    1024 K
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_filtr_codprod
CREATE INDEX in_filtr_codprod
  ON filtros (
    codigo_producto
  )
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_filtr_identif
CREATE INDEX in_filtr_identif
  ON filtros (
    tipo_identificacion,
    numero_identificacion
  )
  STORAGE (
    INITIAL     144 K
  )
/


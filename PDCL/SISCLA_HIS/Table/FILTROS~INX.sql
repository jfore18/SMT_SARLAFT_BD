PROMPT CREATE INDEX in_filtr_codprod
CREATE INDEX in_filtr_codprod
  ON filtros (
    codigo_producto
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_filtr_identif
CREATE INDEX in_filtr_identif
  ON filtros (
    tipo_identificacion,
    numero_identificacion
  )
  STORAGE (
    NEXT       1024 K
  )
/


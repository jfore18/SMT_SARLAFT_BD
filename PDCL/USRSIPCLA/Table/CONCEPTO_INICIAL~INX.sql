PROMPT CREATE INDEX in_rep_concepto_inicial
CREATE INDEX in_rep_concepto_inicial
  ON concepto_inicial (
    id_reporte
  )
  STORAGE (
    NEXT       1024 K
  )
/


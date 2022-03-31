PROMPT CREATE INDEX idx_transacciones_rep
CREATE INDEX idx_transacciones_rep
  ON transacciones_rep (
    id_reporte
  )
  PCTFREE    5
  INITRANS   4
  STORAGE (
    INITIAL   20952 K
    NEXT       1024 K
  )
/


PROMPT CREATE INDEX idx_transacciones_rep_idrep
CREATE INDEX idx_transacciones_rep_idrep
  ON transacciones_rep (
    id_reporte
  )
  PCTFREE   40
  INITRANS   4
  STORAGE (
    INITIAL   57616 K
  )
/


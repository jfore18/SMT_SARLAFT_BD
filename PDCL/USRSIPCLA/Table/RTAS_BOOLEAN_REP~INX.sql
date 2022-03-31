PROMPT CREATE INDEX idx_rtas_boolean_rep_idrep
CREATE INDEX idx_rtas_boolean_rep_idrep
  ON rtas_boolean_rep (
    id_reporte
  )
  PCTFREE   40
  INITRANS   4
  STORAGE (
    INITIAL   40960 K
  )
/


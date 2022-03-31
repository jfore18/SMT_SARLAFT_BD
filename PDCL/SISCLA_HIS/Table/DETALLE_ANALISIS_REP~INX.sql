PROMPT CREATE INDEX in_detanarep_id
CREATE INDEX in_detanarep_id
  ON detalle_analisis_rep (
    id_reporte
  )
  STORAGE (
    NEXT       1024 K
  )
/


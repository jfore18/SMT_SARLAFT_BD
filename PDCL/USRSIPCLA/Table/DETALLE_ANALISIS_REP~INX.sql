PROMPT CREATE INDEX in_detanarep_id
CREATE INDEX in_detanarep_id
  ON detalle_analisis_rep (
    id_reporte
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/


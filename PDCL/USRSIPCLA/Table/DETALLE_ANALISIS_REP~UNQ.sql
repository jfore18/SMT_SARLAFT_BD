PROMPT ALTER TABLE detalle_analisis_rep ADD PRIMARY KEY
ALTER TABLE detalle_analisis_rep
  ADD PRIMARY KEY (
    id_reporte,
    no_acta
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


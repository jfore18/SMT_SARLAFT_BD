PROMPT ALTER TABLE rtas_boolean_rep ADD PRIMARY KEY
ALTER TABLE rtas_boolean_rep
  ADD PRIMARY KEY (
    id_pregunta,
    id_reporte
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


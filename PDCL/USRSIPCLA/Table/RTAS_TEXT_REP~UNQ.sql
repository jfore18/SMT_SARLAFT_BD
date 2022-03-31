PROMPT ALTER TABLE rtas_text_rep ADD PRIMARY KEY
ALTER TABLE rtas_text_rep
  ADD PRIMARY KEY (
    id_pregunta,
    id_reporte
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


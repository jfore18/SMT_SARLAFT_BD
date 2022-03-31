PROMPT ALTER TABLE rtas_boolean_rep ADD PRIMARY KEY
ALTER TABLE rtas_boolean_rep
  ADD PRIMARY KEY (
    id_pregunta,
    id_reporte
  )
  USING INDEX
    INITRANS   8
    STORAGE (
      INITIAL     144 K
    )
/


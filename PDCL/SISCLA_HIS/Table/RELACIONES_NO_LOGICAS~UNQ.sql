PROMPT ALTER TABLE relaciones_no_logicas ADD PRIMARY KEY
ALTER TABLE relaciones_no_logicas
  ADD PRIMARY KEY (
    codigo_plaza_1,
    codigo_plaza_2
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


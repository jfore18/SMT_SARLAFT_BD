PROMPT ALTER TABLE historico_personas_reportadas ADD PRIMARY KEY
ALTER TABLE historico_personas_reportadas
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


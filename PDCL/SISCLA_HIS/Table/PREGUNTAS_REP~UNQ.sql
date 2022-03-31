PROMPT ALTER TABLE preguntas_rep ADD PRIMARY KEY
ALTER TABLE preguntas_rep
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


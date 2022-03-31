PROMPT ALTER TABLE preguntas_rep ADD PRIMARY KEY
ALTER TABLE preguntas_rep
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE comentarios ADD PRIMARY KEY
ALTER TABLE comentarios
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE comentarios ADD PRIMARY KEY
ALTER TABLE comentarios
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


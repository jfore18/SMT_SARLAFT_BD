PROMPT ALTER TABLE consultas ADD PRIMARY KEY
ALTER TABLE consultas
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


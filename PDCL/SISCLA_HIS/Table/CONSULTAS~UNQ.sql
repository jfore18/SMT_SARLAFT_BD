PROMPT ALTER TABLE consultas ADD PRIMARY KEY
ALTER TABLE consultas
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


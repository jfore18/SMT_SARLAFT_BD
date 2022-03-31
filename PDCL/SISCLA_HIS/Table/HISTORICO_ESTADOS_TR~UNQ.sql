PROMPT ALTER TABLE historico_estados_tr ADD PRIMARY KEY
ALTER TABLE historico_estados_tr
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


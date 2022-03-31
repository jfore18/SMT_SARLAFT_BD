PROMPT ALTER TABLE historico_estados_tr ADD PRIMARY KEY
ALTER TABLE historico_estados_tr
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
    )
/


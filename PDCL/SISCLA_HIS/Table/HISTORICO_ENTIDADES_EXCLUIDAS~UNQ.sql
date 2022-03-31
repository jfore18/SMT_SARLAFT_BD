PROMPT ALTER TABLE historico_entidades_excluidas ADD PRIMARY KEY
ALTER TABLE historico_entidades_excluidas
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


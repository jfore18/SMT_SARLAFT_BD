PROMPT ALTER TABLE historico_usuario_cargo ADD PRIMARY KEY
ALTER TABLE historico_usuario_cargo
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


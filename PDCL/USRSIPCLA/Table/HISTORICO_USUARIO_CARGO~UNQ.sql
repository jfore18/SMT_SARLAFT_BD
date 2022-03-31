PROMPT ALTER TABLE historico_usuario_cargo ADD PRIMARY KEY
ALTER TABLE historico_usuario_cargo
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


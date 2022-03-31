PROMPT ALTER TABLE cargos ADD PRIMARY KEY
ALTER TABLE cargos
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


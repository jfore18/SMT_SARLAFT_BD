PROMPT ALTER TABLE tipo_campo ADD PRIMARY KEY
ALTER TABLE tipo_campo
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


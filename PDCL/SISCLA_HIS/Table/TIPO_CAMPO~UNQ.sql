PROMPT ALTER TABLE tipo_campo ADD PRIMARY KEY
ALTER TABLE tipo_campo
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


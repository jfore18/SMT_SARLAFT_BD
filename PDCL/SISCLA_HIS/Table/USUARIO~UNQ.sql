PROMPT ALTER TABLE usuario ADD PRIMARY KEY
ALTER TABLE usuario
  ADD PRIMARY KEY (
    cedula
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


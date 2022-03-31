PROMPT ALTER TABLE usuario ADD PRIMARY KEY
ALTER TABLE usuario
  ADD PRIMARY KEY (
    cedula
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


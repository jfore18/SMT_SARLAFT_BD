PROMPT ALTER TABLE lista_valores ADD PRIMARY KEY
ALTER TABLE lista_valores
  ADD PRIMARY KEY (
    tipo_dato,
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


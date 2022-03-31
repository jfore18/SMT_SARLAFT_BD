PROMPT ALTER TABLE unidades_negocio ADD PRIMARY KEY
ALTER TABLE unidades_negocio
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


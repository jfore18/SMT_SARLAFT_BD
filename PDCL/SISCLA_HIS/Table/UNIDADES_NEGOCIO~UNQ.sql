PROMPT ALTER TABLE unidades_negocio ADD PRIMARY KEY
ALTER TABLE unidades_negocio
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


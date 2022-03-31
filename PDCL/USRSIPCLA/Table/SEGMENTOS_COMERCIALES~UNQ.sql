PROMPT ALTER TABLE segmentos_comerciales ADD PRIMARY KEY
ALTER TABLE segmentos_comerciales
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE segmentos_comerciales ADD PRIMARY KEY
ALTER TABLE segmentos_comerciales
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


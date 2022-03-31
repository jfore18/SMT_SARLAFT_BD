PROMPT ALTER TABLE mensajes ADD PRIMARY KEY
ALTER TABLE mensajes
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


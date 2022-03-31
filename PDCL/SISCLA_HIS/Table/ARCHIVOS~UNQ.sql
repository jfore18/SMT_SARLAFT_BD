PROMPT ALTER TABLE archivos ADD PRIMARY KEY
ALTER TABLE archivos
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


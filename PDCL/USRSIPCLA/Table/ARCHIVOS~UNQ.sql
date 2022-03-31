PROMPT ALTER TABLE archivos ADD PRIMARY KEY
ALTER TABLE archivos
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE zonas ADD PRIMARY KEY
ALTER TABLE zonas
  ADD PRIMARY KEY (
    codigo,
    codigo_region_v
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


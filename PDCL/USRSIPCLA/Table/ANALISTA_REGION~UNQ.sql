PROMPT ALTER TABLE analista_region ADD PRIMARY KEY
ALTER TABLE analista_region
  ADD PRIMARY KEY (
    codigo_cargo,
    codigo_region_v
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


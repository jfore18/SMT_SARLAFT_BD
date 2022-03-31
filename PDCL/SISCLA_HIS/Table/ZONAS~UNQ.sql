PROMPT ALTER TABLE zonas ADD PRIMARY KEY
ALTER TABLE zonas
  ADD PRIMARY KEY (
    codigo,
    codigo_region_v
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


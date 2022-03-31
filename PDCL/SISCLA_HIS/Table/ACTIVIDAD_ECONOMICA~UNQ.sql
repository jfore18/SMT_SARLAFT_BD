PROMPT ALTER TABLE actividad_economica ADD PRIMARY KEY
ALTER TABLE actividad_economica
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


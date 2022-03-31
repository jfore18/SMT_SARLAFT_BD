PROMPT ALTER TABLE control_entidad ADD PRIMARY KEY
ALTER TABLE control_entidad
  ADD PRIMARY KEY (
    fecha_proceso
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


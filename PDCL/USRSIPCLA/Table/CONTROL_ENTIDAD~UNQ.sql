PROMPT ALTER TABLE control_entidad ADD PRIMARY KEY
ALTER TABLE control_entidad
  ADD PRIMARY KEY (
    fecha_proceso
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


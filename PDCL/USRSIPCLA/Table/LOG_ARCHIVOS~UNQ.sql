PROMPT ALTER TABLE log_archivos ADD PRIMARY KEY
ALTER TABLE log_archivos
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


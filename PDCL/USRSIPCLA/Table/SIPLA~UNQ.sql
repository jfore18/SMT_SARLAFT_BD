PROMPT ALTER TABLE sipla ADD PRIMARY KEY
ALTER TABLE sipla
  ADD PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


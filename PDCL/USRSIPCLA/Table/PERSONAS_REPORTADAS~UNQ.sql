PROMPT ALTER TABLE personas_reportadas ADD PRIMARY KEY
ALTER TABLE personas_reportadas
  ADD PRIMARY KEY (
    codigo_motivo_v,
    tipo_identificacion,
    numero_identificacion
  )
  USING INDEX
    STORAGE (
      INITIAL     840 K
    )
/


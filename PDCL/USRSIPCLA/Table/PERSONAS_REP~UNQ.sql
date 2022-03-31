PROMPT ALTER TABLE personas_rep ADD PRIMARY KEY
ALTER TABLE personas_rep
  ADD PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion,
    id_reporte
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


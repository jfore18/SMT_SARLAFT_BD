PROMPT ALTER TABLE clientes ADD PRIMARY KEY
ALTER TABLE clientes
  ADD PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
    )
/


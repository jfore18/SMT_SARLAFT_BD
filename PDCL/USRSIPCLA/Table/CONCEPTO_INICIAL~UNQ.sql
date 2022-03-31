PROMPT ALTER TABLE concepto_inicial ADD CONSTRAINT pk_concepto_inicial PRIMARY KEY
ALTER TABLE concepto_inicial
  ADD CONSTRAINT pk_concepto_inicial PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion,
    id_reporte
  )
  USING INDEX
    STORAGE (
      INITIAL   10240 K
      NEXT       1024 K
    )
/


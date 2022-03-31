PROMPT ALTER TABLE indicadores ADD CONSTRAINT pk_indicadores PRIMARY KEY
ALTER TABLE indicadores
  ADD CONSTRAINT pk_indicadores PRIMARY KEY (
    codigo_oficina,
    fuente
  )
  USING INDEX
    STORAGE (
      INITIAL      64 K
    )
/


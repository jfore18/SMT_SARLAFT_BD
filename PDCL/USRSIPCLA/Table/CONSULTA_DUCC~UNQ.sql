PROMPT ALTER TABLE consulta_ducc ADD CONSTRAINT pk_consulta_ducc PRIMARY KEY
ALTER TABLE consulta_ducc
  ADD CONSTRAINT pk_consulta_ducc PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


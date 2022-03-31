PROMPT ALTER TABLE entidades_excluidas ADD CONSTRAINT pk_entidad_excluida PRIMARY KEY
ALTER TABLE entidades_excluidas
  ADD CONSTRAINT pk_entidad_excluida PRIMARY KEY (
    tipo_identificacion,
    numero_identificacion
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


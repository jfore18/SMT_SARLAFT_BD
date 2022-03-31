PROMPT ALTER TABLE equivalencias ADD CONSTRAINT pk_equivalencias PRIMARY KEY
ALTER TABLE equivalencias
  ADD CONSTRAINT pk_equivalencias PRIMARY KEY (
    tipo_equivalencia,
    codigo_bd
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


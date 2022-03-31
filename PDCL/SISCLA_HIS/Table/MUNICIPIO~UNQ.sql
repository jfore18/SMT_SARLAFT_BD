PROMPT ALTER TABLE municipio ADD CONSTRAINT pk_municipio PRIMARY KEY
ALTER TABLE municipio
  ADD CONSTRAINT pk_municipio PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


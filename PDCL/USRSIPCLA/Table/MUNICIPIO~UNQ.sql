PROMPT ALTER TABLE municipio ADD CONSTRAINT pk_municipio PRIMARY KEY
ALTER TABLE municipio
  ADD CONSTRAINT pk_municipio PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     280 K
      NEXT       1024 K
    )
/


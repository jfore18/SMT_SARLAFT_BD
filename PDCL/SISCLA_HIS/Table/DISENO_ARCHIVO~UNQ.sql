PROMPT ALTER TABLE diseno_archivo ADD PRIMARY KEY
ALTER TABLE diseno_archivo
  ADD PRIMARY KEY (
    codigo_archivo,
    secuencia_campo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


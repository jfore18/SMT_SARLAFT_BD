PROMPT ALTER TABLE diseno_archivo ADD FOREIGN KEY
ALTER TABLE diseno_archivo
  ADD FOREIGN KEY (
    codigo
  ) REFERENCES tipo_campo (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE diseno_archivo ADD FOREIGN KEY
ALTER TABLE diseno_archivo
  ADD FOREIGN KEY (
    codigo_archivo
  ) REFERENCES archivos (
    codigo
  )
  DISABLE
  NOVALIDATE
/


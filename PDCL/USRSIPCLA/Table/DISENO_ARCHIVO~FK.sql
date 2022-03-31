PROMPT ALTER TABLE diseno_archivo ADD FOREIGN KEY
ALTER TABLE diseno_archivo
  ADD FOREIGN KEY (
    codigo
  ) REFERENCES tipo_campo (
    codigo
  )
/

PROMPT ALTER TABLE diseno_archivo ADD FOREIGN KEY
ALTER TABLE diseno_archivo
  ADD FOREIGN KEY (
    codigo_archivo
  ) REFERENCES archivos (
    codigo
  )
/


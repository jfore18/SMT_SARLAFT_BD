PROMPT CREATE INDEX in_activeco_desc
CREATE UNIQUE INDEX in_activeco_desc
  ON actividad_economica (
    descripcion
  )
  STORAGE (
    NEXT       1024 K
  )
/


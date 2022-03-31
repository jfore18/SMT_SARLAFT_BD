PROMPT CREATE INDEX in_activeco_desc
CREATE UNIQUE INDEX in_activeco_desc
  ON actividad_economica (
    descripcion
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/


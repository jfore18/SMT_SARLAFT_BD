PROMPT CREATE INDEX in_perep_apellrs
CREATE INDEX in_perep_apellrs
  ON personas_rep (
    apellidos_razon_social
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_perep_nombrc
CREATE INDEX in_perep_nombrc
  ON personas_rep (
    nombres_razon_comercial
  )
  STORAGE (
    NEXT       1024 K
  )
/


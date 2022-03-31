PROMPT CREATE INDEX in_perepo_apellrs
CREATE INDEX in_perepo_apellrs
  ON personas_reportadas (
    apellidos_razon_social
  )
  STORAGE (
    INITIAL     704 K
  )
/

PROMPT CREATE INDEX in_perepo_identif
CREATE INDEX in_perepo_identif
  ON personas_reportadas (
    tipo_identificacion,
    numero_identificacion
  )
  STORAGE (
    INITIAL     704 K
  )
/

PROMPT CREATE INDEX in_perepo_nombrc
CREATE INDEX in_perepo_nombrc
  ON personas_reportadas (
    nombres_razon_comercial
  )
  STORAGE (
    INITIAL     704 K
  )
/


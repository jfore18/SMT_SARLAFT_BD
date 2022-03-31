PROMPT CREATE INDEX in_munic_dpto
CREATE INDEX in_munic_dpto
  ON municipio (
    departamento
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_munic_muni
CREATE INDEX in_munic_muni
  ON municipio (
    municipio
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_munic_poblad
CREATE INDEX in_munic_poblad
  ON municipio (
    centro_poblado
  )
  STORAGE (
    NEXT       1024 K
  )
/


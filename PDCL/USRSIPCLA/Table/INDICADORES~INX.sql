PROMPT CREATE INDEX idx_ind_region
CREATE INDEX idx_ind_region
  ON indicadores (
    codigo_region
  )
  STORAGE (
    INITIAL      64 K
  )
/

PROMPT CREATE INDEX idx_ind_region_zona
CREATE INDEX idx_ind_region_zona
  ON indicadores (
    codigo_region,
    codigo_zona
  )
  STORAGE (
    INITIAL      64 K
  )
/

PROMPT CREATE INDEX idx_ind_zona
CREATE INDEX idx_ind_zona
  ON indicadores (
    codigo_zona
  )
  STORAGE (
    INITIAL      64 K
  )
/


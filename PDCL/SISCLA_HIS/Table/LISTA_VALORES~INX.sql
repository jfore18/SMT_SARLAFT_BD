PROMPT CREATE INDEX in_lval_codigo
CREATE INDEX in_lval_codigo
  ON lista_valores (
    codigo
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_lval_tipodato
CREATE INDEX in_lval_tipodato
  ON lista_valores (
    tipo_dato
  )
  STORAGE (
    NEXT       1024 K
  )
/


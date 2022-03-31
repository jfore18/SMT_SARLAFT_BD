PROMPT CREATE INDEX in_lval_codigo
CREATE INDEX in_lval_codigo
  ON lista_valores (
    codigo
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_lval_tipodato
CREATE INDEX in_lval_tipodato
  ON lista_valores (
    tipo_dato
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/


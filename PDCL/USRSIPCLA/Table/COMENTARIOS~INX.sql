PROMPT CREATE INDEX in_comen_trans
CREATE INDEX in_comen_trans
  ON comentarios (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/


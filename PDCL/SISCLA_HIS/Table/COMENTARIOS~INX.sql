PROMPT CREATE INDEX in_comen_trans
CREATE INDEX in_comen_trans
  ON comentarios (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  STORAGE (
    NEXT       1024 K
  )
/


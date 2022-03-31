PROMPT CREATE INDEX in_hiest_trans
CREATE INDEX in_hiest_trans
  ON historico_estados_tr (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  STORAGE (
    INITIAL     144 K
  )
/


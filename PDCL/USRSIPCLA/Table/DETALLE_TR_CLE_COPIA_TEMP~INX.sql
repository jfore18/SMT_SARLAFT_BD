PROMPT CREATE INDEX pk_detalle_cle
CREATE UNIQUE INDEX pk_detalle_cle
  ON detalle_tr_cle_copia_temp (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  STORAGE (
    NEXT       1024 K
  )
/


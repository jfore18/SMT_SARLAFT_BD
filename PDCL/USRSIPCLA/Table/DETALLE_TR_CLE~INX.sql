PROMPT CREATE INDEX in_detalle_cle
CREATE INDEX in_detalle_cle
  ON detalle_tr_cle (
    fecha_operacion,
    numero_cuenta,
    codigo_transaccion
  )
  STORAGE (
    NEXT       1024 K
  )
/


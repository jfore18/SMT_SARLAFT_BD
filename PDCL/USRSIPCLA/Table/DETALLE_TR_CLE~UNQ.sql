PROMPT ALTER TABLE detalle_tr_cle ADD CONSTRAINT pk_detalle_tr_cle PRIMARY KEY
ALTER TABLE detalle_tr_cle
  ADD CONSTRAINT pk_detalle_tr_cle PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


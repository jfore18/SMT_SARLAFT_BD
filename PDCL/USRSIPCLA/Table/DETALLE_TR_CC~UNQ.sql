PROMPT ALTER TABLE detalle_tr_cc ADD PRIMARY KEY
ALTER TABLE detalle_tr_cc
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


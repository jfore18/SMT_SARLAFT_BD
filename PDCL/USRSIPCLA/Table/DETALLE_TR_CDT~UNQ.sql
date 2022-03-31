PROMPT ALTER TABLE detalle_tr_cdt ADD PRIMARY KEY
ALTER TABLE detalle_tr_cdt
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


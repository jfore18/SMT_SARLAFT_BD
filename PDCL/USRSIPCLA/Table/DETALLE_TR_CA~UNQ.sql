PROMPT ALTER TABLE detalle_tr_ca ADD PRIMARY KEY
ALTER TABLE detalle_tr_ca
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
    )
/


PROMPT ALTER TABLE cargue_total ADD PRIMARY KEY
ALTER TABLE cargue_total
  ADD PRIMARY KEY (
    fecha_proceso,
    codigo_archivo,
    secuencia_transaccion
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


PROMPT ALTER TABLE transacciones_cliente ADD PRIMARY KEY
ALTER TABLE transacciones_cliente
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


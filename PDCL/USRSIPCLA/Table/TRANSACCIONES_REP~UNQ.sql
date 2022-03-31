PROMPT ALTER TABLE transacciones_rep ADD PRIMARY KEY
ALTER TABLE transacciones_rep
  ADD PRIMARY KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion,
    id_reporte
  )
  USING INDEX
    INITRANS   8
    STORAGE (
      INITIAL     144 K
    )
/


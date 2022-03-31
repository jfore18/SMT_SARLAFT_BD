PROMPT ALTER TABLE transacciones_rep ADD CONSTRAINT fk_transacciones_rep_reporte FOREIGN KEY
ALTER TABLE transacciones_rep
  ADD CONSTRAINT fk_transacciones_rep_reporte FOREIGN KEY (
    id_reporte
  ) REFERENCES reporte (
    id
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE transacciones_rep ADD CONSTRAINT fk_tr_rep_tr_cliente FOREIGN KEY
ALTER TABLE transacciones_rep
  ADD CONSTRAINT fk_tr_rep_tr_cliente FOREIGN KEY (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  ) REFERENCES transacciones_cliente (
    codigo_archivo,
    fecha_proceso,
    id
  )
  DISABLE
  NOVALIDATE
/


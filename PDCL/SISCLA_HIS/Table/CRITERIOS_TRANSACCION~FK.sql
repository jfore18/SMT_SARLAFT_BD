PROMPT ALTER TABLE criterios_transaccion ADD FOREIGN KEY
ALTER TABLE criterios_transaccion
  ADD FOREIGN KEY (
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

PROMPT ALTER TABLE criterios_transaccion ADD FOREIGN KEY
ALTER TABLE criterios_transaccion
  ADD FOREIGN KEY (
    id_criterio_inusualidad
  ) REFERENCES criterios_inusualidad (
    id
  )
  DISABLE
  NOVALIDATE
/


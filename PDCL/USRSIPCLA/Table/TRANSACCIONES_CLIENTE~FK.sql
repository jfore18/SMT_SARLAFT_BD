PROMPT ALTER TABLE transacciones_cliente ADD FOREIGN KEY
ALTER TABLE transacciones_cliente
  ADD FOREIGN KEY (
    codigo_actividad_economica
  ) REFERENCES actividad_economica (
    codigo
  )
/

PROMPT ALTER TABLE transacciones_cliente ADD FOREIGN KEY
ALTER TABLE transacciones_cliente
  ADD FOREIGN KEY (
    codigo_archivo
  ) REFERENCES archivos (
    codigo
  )
/


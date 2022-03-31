PROMPT ALTER TABLE clientes ADD FOREIGN KEY
ALTER TABLE clientes
  ADD FOREIGN KEY (
    codigo_actividad_economica
  ) REFERENCES actividad_economica (
    codigo
  )
/

PROMPT ALTER TABLE clientes ADD FOREIGN KEY
ALTER TABLE clientes
  ADD FOREIGN KEY (
    codigo_segmento_comercial
  ) REFERENCES segmentos_comerciales (
    codigo
  )
/


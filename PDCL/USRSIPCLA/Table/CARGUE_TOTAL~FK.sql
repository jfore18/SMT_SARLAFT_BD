PROMPT ALTER TABLE cargue_total ADD FOREIGN KEY
ALTER TABLE cargue_total
  ADD FOREIGN KEY (
    codigo_archivo
  ) REFERENCES archivos (
    codigo
  )
/

PROMPT ALTER TABLE cargue_total ADD FOREIGN KEY
ALTER TABLE cargue_total
  ADD FOREIGN KEY (
    codigo_mensaje
  ) REFERENCES mensajes (
    codigo
  )
/


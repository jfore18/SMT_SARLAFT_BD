PROMPT ALTER TABLE log_archivos ADD FOREIGN KEY
ALTER TABLE log_archivos
  ADD FOREIGN KEY (
    codigo_archivo
  ) REFERENCES archivos (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE log_archivos ADD FOREIGN KEY
ALTER TABLE log_archivos
  ADD FOREIGN KEY (
    codigo_mensaje
  ) REFERENCES mensajes (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE log_archivos ADD FOREIGN KEY
ALTER TABLE log_archivos
  ADD FOREIGN KEY (
    usuario_creacion
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/


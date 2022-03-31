PROMPT ALTER TABLE detalle_analisis_rep ADD FOREIGN KEY
ALTER TABLE detalle_analisis_rep
  ADD FOREIGN KEY (
    usuario_actualizacion
  ) REFERENCES usuario (
    cedula
  )
  DISABLE
  NOVALIDATE
/


PROMPT ALTER TABLE visibilidad ADD CONSTRAINT fk_visibilidad_consulta FOREIGN KEY
ALTER TABLE visibilidad
  ADD CONSTRAINT fk_visibilidad_consulta FOREIGN KEY (
    id_consulta
  ) REFERENCES consultas (
    id
  )
/


PROMPT ALTER TABLE rtas_boolean_rep ADD FOREIGN KEY
ALTER TABLE rtas_boolean_rep
  ADD FOREIGN KEY (
    id_pregunta
  ) REFERENCES preguntas_rep (
    id
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE rtas_boolean_rep ADD CONSTRAINT fk_rtas_bool_rep_reporte FOREIGN KEY
ALTER TABLE rtas_boolean_rep
  ADD CONSTRAINT fk_rtas_bool_rep_reporte FOREIGN KEY (
    id_reporte
  ) REFERENCES reporte (
    id
  )
  DISABLE
  NOVALIDATE
/


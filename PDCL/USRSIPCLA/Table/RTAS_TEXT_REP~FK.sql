PROMPT ALTER TABLE rtas_text_rep ADD FOREIGN KEY
ALTER TABLE rtas_text_rep
  ADD FOREIGN KEY (
    id_pregunta
  ) REFERENCES preguntas_rep (
    id
  )
/

PROMPT ALTER TABLE rtas_text_rep ADD CONSTRAINT fk_rtas_text_rep_reporte FOREIGN KEY
ALTER TABLE rtas_text_rep
  ADD CONSTRAINT fk_rtas_text_rep_reporte FOREIGN KEY (
    id_reporte
  ) REFERENCES reporte (
    id
  )
/


PROMPT ALTER TABLE personas_rep ADD CONSTRAINT fk_personas_rep_municipio FOREIGN KEY
ALTER TABLE personas_rep
  ADD CONSTRAINT fk_personas_rep_municipio FOREIGN KEY (
    codigo_municipio
  ) REFERENCES municipio (
    codigo
  )
  DISABLE
  NOVALIDATE
/

PROMPT ALTER TABLE personas_rep ADD CONSTRAINT fk_personas_rep_reporte FOREIGN KEY
ALTER TABLE personas_rep
  ADD CONSTRAINT fk_personas_rep_reporte FOREIGN KEY (
    id_reporte
  ) REFERENCES reporte (
    id
  )
  DISABLE
  NOVALIDATE
/


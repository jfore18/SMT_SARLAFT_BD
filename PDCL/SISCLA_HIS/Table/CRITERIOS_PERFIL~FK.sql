PROMPT ALTER TABLE criterios_perfil ADD FOREIGN KEY
ALTER TABLE criterios_perfil
  ADD FOREIGN KEY (
    id_criterio_inusualidad
  ) REFERENCES criterios_inusualidad (
    id
  )
  DISABLE
  NOVALIDATE
/


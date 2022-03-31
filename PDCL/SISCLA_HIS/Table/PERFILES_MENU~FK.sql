PROMPT ALTER TABLE perfiles_menu ADD CONSTRAINT fk_opcion_menu FOREIGN KEY
ALTER TABLE perfiles_menu
  ADD CONSTRAINT fk_opcion_menu FOREIGN KEY (
    codigo_opcion_menu
  ) REFERENCES opciones_menu (
    codigo
  )
  DISABLE
  NOVALIDATE
/


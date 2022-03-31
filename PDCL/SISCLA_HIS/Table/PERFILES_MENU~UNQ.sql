PROMPT ALTER TABLE perfiles_menu ADD PRIMARY KEY
ALTER TABLE perfiles_menu
  ADD PRIMARY KEY (
    codigo_opcion_menu,
    codigo_perfil_v
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


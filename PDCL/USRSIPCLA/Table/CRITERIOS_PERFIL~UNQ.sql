PROMPT ALTER TABLE criterios_perfil ADD PRIMARY KEY
ALTER TABLE criterios_perfil
  ADD PRIMARY KEY (
    id_criterio_inusualidad,
    codigo_perfil
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


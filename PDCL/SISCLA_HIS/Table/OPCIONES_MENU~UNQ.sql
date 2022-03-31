PROMPT ALTER TABLE opciones_menu ADD PRIMARY KEY
ALTER TABLE opciones_menu
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


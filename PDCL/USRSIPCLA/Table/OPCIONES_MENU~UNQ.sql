PROMPT ALTER TABLE opciones_menu ADD PRIMARY KEY
ALTER TABLE opciones_menu
  ADD PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


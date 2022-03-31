PROMPT ALTER TABLE criterios_inusualidad ADD PRIMARY KEY
ALTER TABLE criterios_inusualidad
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


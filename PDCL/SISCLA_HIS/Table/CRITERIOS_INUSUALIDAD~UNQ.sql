PROMPT ALTER TABLE criterios_inusualidad ADD PRIMARY KEY
ALTER TABLE criterios_inusualidad
  ADD PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


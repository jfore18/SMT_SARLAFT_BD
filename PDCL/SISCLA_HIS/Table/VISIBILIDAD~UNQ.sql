PROMPT ALTER TABLE visibilidad ADD CONSTRAINT pk_visibilidad PRIMARY KEY
ALTER TABLE visibilidad
  ADD CONSTRAINT pk_visibilidad PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/


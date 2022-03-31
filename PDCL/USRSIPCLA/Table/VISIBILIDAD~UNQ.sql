PROMPT ALTER TABLE visibilidad ADD CONSTRAINT pk_visibilidad PRIMARY KEY
ALTER TABLE visibilidad
  ADD CONSTRAINT pk_visibilidad PRIMARY KEY (
    id
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


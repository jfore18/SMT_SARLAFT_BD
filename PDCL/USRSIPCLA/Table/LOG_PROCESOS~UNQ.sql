PROMPT ALTER TABLE log_procesos ADD PRIMARY KEY
ALTER TABLE log_procesos
  ADD PRIMARY KEY (
    id_proceso
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


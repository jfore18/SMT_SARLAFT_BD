PROMPT ALTER TABLE log_transaccional ADD CONSTRAINT pk_secuencia_log_trans PRIMARY KEY
ALTER TABLE log_transaccional
  ADD CONSTRAINT pk_secuencia_log_trans PRIMARY KEY (
    secuencia
  )
  USING INDEX
    STORAGE (
      INITIAL      64 K
      NEXT       1024 K
    )
/


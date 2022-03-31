PROMPT CREATE INDEX in_critr_trans
CREATE INDEX in_critr_trans
  ON criterios_transaccion (
    codigo_archivo,
    fecha_proceso,
    id_transaccion
  )
  STORAGE (
    INITIAL     144 K
  )
/


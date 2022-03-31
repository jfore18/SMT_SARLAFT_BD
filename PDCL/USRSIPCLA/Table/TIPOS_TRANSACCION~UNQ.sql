PROMPT ALTER TABLE tipos_transaccion ADD PRIMARY KEY
ALTER TABLE tipos_transaccion
  ADD PRIMARY KEY (
    codigo_producto_v,
    codigo_transaccion
  )
  USING INDEX
    STORAGE (
      INITIAL     144 K
      NEXT       1024 K
    )
/


PROMPT CREATE INDEX idx_tr_cliente_cheq
CREATE INDEX idx_tr_cliente_cheq
  ON transacciones_cliente (
    chequeada
  )
  STORAGE (
    INITIAL      64 K
  )
/

PROMPT CREATE INDEX in_trcli_cliente
CREATE INDEX in_trcli_cliente
  ON transacciones_cliente (
    nombre_cliente
  )
  STORAGE (
    INITIAL     840 K
  )
/

PROMPT CREATE INDEX in_trcli_codofi
CREATE INDEX in_trcli_codofi
  ON transacciones_cliente (
    codigo_oficina
  )
  STORAGE (
    INITIAL     280 K
  )
/

PROMPT CREATE INDEX in_trcli_estadod
CREATE INDEX in_trcli_estadod
  ON transacciones_cliente (
    estado_ducc
  )
  STORAGE (
    INITIAL     280 K
  )
/

PROMPT CREATE INDEX in_trcli_estadoo
CREATE INDEX in_trcli_estadoo
  ON transacciones_cliente (
    estado_oficina
  )
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_trcli_fecha
CREATE INDEX in_trcli_fecha
  ON transacciones_cliente (
    fecha
  )
  STORAGE (
    INITIAL     560 K
  )
/

PROMPT CREATE INDEX in_trcli_filtrod
CREATE INDEX in_trcli_filtrod
  ON transacciones_cliente (
    filtro_ducc
  )
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_trcli_filtroo
CREATE INDEX in_trcli_filtroo
  ON transacciones_cliente (
    filtro_oficina
  )
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_trcli_identif
CREATE INDEX in_trcli_identif
  ON transacciones_cliente (
    tipo_identificacion,
    numero_identificacion
  )
  STORAGE (
    INITIAL     424 K
  )
/

PROMPT CREATE INDEX in_trcli_mriesgo
CREATE INDEX in_trcli_mriesgo
  ON transacciones_cliente (
    mayor_riesgo
  )
  STORAGE (
    INITIAL     280 K
  )
/

PROMPT CREATE INDEX in_trcli_negocio
CREATE INDEX in_trcli_negocio
  ON transacciones_cliente (
    numero_negocio
  )
  STORAGE (
    INITIAL     424 K
  )
/

PROMPT CREATE INDEX in_trcli_nueva
CREATE INDEX in_trcli_nueva
  ON transacciones_cliente (
    nueva
  )
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_trcli_valor
CREATE INDEX in_trcli_valor
  ON transacciones_cliente (
    fecha_proceso,
    codigo_archivo,
    numero_negocio,
    codigo_transaccion,
    valor_transaccion
  )
  INITRANS   7
  STORAGE (
    INITIAL     280 K
  )
/


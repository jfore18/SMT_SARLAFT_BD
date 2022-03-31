PROMPT CREATE TABLE detalle_tr_ca
CREATE TABLE detalle_tr_ca (
  codigo_archivo     NUMBER(5,0)  NOT NULL,
  fecha_proceso      DATE         NOT NULL,
  id_transaccion     NUMBER(5,0)  NOT NULL,
  valor_canje        NUMBER(17,2) NULL,
  fecha_apertura     DATE         NULL,
  signo_sobregiro    VARCHAR2(1)  NULL,
  saldo              NUMBER(17,2) NULL,
  documento_tr       VARCHAR2(10) NULL,
  signo_promedio     VARCHAR2(1)  NULL,
  promedio_semestral NUMBER(17,2) NULL,
  estado_cuenta      VARCHAR2(2)  NULL
)
  STORAGE (
    INITIAL     144 K
  )
/



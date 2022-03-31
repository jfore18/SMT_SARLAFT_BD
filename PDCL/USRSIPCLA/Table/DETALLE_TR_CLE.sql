PROMPT CREATE TABLE detalle_tr_cle
CREATE TABLE detalle_tr_cle (
  codigo_archivo           NUMBER(5,0)   NOT NULL,
  fecha_proceso            DATE          NOT NULL,
  id_transaccion           NUMBER(5,0)   NOT NULL,
  fecha_operacion          DATE          NOT NULL,
  tipo_cuenta              VARCHAR2(3)   NOT NULL,
  numero_cuenta            VARCHAR2(20)  NOT NULL,
  tipo_identificacion      VARCHAR2(3)   NOT NULL,
  numero_identificacion    VARCHAR2(12)  NOT NULL,
  codigo_transaccion       VARCHAR2(8)   NOT NULL,
  numero_operaciones_dia   NUMBER(10,2)  NOT NULL,
  valor_operaciones_dia    NUMBER(18,2)  NOT NULL,
  prom_num_operaciones_dia NUMBER(10,2)  NOT NULL,
  prom_val_operaciones_dia NUMBER(18,2)  NOT NULL,
  max_hist_operaciones_dia NUMBER(10,2)  NOT NULL,
  max_hist_val_oper_dia    NUMBER(18,2)  NOT NULL,
  nivel_criticidad         CHAR(1)       NOT NULL,
  valor_transaccion        NUMBER(18,2)  NULL,
  tipo_alerta              CHAR(1)       NULL,
  criterios_inusualidad    VARCHAR2(100) NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



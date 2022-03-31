PROMPT CREATE TABLE detalle_tr_cdt
CREATE TABLE detalle_tr_cdt (
  codigo_archivo      NUMBER(5,0)  NOT NULL,
  fecha_proceso       DATE         NOT NULL,
  id_transaccion      NUMBER(5,0)  NOT NULL,
  tasa_interes        NUMBER(4,2)  NULL,
  tipo_interes        VARCHAR2(1)  NULL,
  periodo_interes     VARCHAR2(4)  NULL,
  plazo               NUMBER(4,0)  NULL,
  nombre_titular_2    VARCHAR2(30) NULL,
  tipo_id_titular_2   VARCHAR2(3)  NULL,
  numero_id_titular_2 VARCHAR2(11) NULL,
  nombre_titular_3    VARCHAR2(30) NULL,
  tipo_id_titular_3   VARCHAR2(3)  NULL,
  numero_id_titular_3 VARCHAR2(11) NULL,
  nombre_titular_4    VARCHAR2(30) NULL,
  tipo_id_titular_4   VARCHAR2(3)  NULL,
  numero_id_titular_4 VARCHAR2(11) NULL,
  fecha_vencimiento   DATE         NULL,
  fecha_apertura      DATE         NULL,
  tipo_cdt            VARCHAR2(1)  NULL
)
  STORAGE (
    INITIAL     144 K
  )
/

COMMENT ON COLUMN detalle_tr_cdt.tipo_cdt IS 'Posibles valores D-Desmaterializados,F-Fisicos';


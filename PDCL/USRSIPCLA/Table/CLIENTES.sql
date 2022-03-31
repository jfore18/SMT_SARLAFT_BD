PROMPT CREATE TABLE clientes
CREATE TABLE clientes (
  tipo_identificacion        VARCHAR2(3)  NOT NULL,
  numero_identificacion      VARCHAR2(11) NOT NULL,
  codigo_actividad_economica VARCHAR2(5)  NULL,
  codigo_segmento_comercial  NUMBER(4,0)  NULL,
  nombre_razon_social        VARCHAR2(40) NULL,
  tipo_telefono              VARCHAR2(3)  NULL,
  telefono                   VARCHAR2(30) NULL,
  negativo                   NUMBER(1,0)  NULL,
  peps                       NUMBER(1,0)  NULL,
  gran_contribuyente         NUMBER(1,0)  NULL,
  vigilado_superbancaria     NUMBER(1,0)  NULL,
  tipo_empresa               VARCHAR2(3)  NULL,
  fecha_actualizacion        DATE         NULL
)
  STORAGE (
    INITIAL     424 K
  )
/



PROMPT CREATE TABLE personas_rep
CREATE TABLE personas_rep (
  tipo_identificacion      VARCHAR2(3)  NOT NULL,
  numero_identificacion    VARCHAR2(11) NOT NULL,
  id_reporte               NUMBER(10,0) NOT NULL,
  codigo_municipio         VARCHAR2(8)  NULL,
  apellidos_razon_social   VARCHAR2(40) NULL,
  nombres_razon_comercial  VARCHAR2(40) NULL,
  direccion_email          VARCHAR2(30) NULL,
  tipo_relacion_v          VARCHAR2(3)  NULL,
  otra_relacion            VARCHAR2(20) NULL,
  vinculado                NUMBER(1,0)  NULL,
  razon_retiro_v           VARCHAR2(3)  NULL,
  inicio_vinculacion       DATE         NULL,
  final_vinculacion        DATE         NULL,
  ingresos_mensuales       NUMBER(17,2) NULL,
  fecha_ingresos           DATE         NULL,
  codigo_ciiu              VARCHAR2(5)  NULL,
  descripcion_actividad_ec VARCHAR2(30) NULL,
  telefono                 VARCHAR2(30) NULL,
  fax                      VARCHAR2(30) NULL,
  direccion                VARCHAR2(40) NULL,
  codigo_tipo_direccion_v  VARCHAR2(3)  NULL,
  apellidos_rep_legal      VARCHAR2(25) NULL,
  nombres_rep_legal        VARCHAR2(25) NULL,
  ti_rep_legal             VARCHAR2(3)  NULL,
  ni_rep_legal             VARCHAR2(11) NULL,
  codigo_tipo_telefono_v   VARCHAR2(3)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



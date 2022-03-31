PROMPT CREATE TABLE personas_reportadas
CREATE TABLE personas_reportadas (
  codigo_motivo_v         VARCHAR2(3)   NOT NULL,
  tipo_identificacion     VARCHAR2(3)   NOT NULL,
  numero_identificacion   VARCHAR2(11)  NOT NULL,
  id_reporte              NUMBER(10,0)  NULL,
  apellidos_razon_social  VARCHAR2(60)  NULL,
  nombres_razon_comercial VARCHAR2(60)  NULL,
  alias                   VARCHAR2(20)  NULL,
  comentario              VARCHAR2(100) NULL,
  fecha_ingreso           DATE          NULL,
  tipo_reporte            VARCHAR2(1)   NULL,
  ros                     VARCHAR2(10)  NULL
)
  STORAGE (
    INITIAL    1824 K
  )
/



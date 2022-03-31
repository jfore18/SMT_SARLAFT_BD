PROMPT CREATE TABLE historico_personas_reportadas
CREATE TABLE historico_personas_reportadas (
  id                      NUMBER(11,0)  NOT NULL,
  codigo_motivo_v         VARCHAR2(3)   NULL,
  tipo_identificacion     VARCHAR2(3)   NULL,
  numero_identificacion   VARCHAR2(11)  NULL,
  id_reporte              NUMBER(10,0)  NULL,
  apellidos_razon_social  VARCHAR2(60)  NULL,
  nombres_razon_comercial VARCHAR2(60)  NULL,
  alias                   VARCHAR2(20)  NULL,
  comentario              VARCHAR2(100) NULL,
  fecha_ingreso           DATE          NULL,
  tipo_reporte            VARCHAR2(1)   NULL,
  ros                     VARCHAR2(10)  NULL,
  usuario_actualizacion   NUMBER(10,0)  NULL,
  fecha_actualizacion     DATE          NULL,
  accion                  VARCHAR2(12)  NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



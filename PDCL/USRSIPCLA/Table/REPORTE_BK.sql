PROMPT CREATE TABLE reporte_bk
CREATE TABLE reporte_bk (
  id                      NUMBER(10,0)   NOT NULL,
  codigo_cargo            VARCHAR2(5)    NULL,
  justificacion_inicial   VARCHAR2(3000) NULL,
  codigo_clase_reporte_v  VARCHAR2(3)    NULL,
  codigo_tipo_reporte_v   VARCHAR2(3)    NULL,
  codigo_estado_reporte_v VARCHAR2(3)    NULL,
  ros_relacionado         NUMBER(10,0)   NULL,
  indagacion              VARCHAR2(500)  NULL,
  otro_documento_soporte  VARCHAR2(30)   NULL,
  otra_fuente_informacion VARCHAR2(30)   NULL,
  existe_rep_analista     NUMBER(1,0)    NULL,
  usuario_creacion        NUMBER(10,0)   NULL,
  fecha_creacion          DATE           NULL,
  usuario_actualizacion   NUMBER(10,0)   NULL,
  fecha_actualizacion     DATE           NULL,
  codigo_tipo_consulta_v  VARCHAR2(3)    NULL,
  numero_identificacion   VARCHAR2(11)   NULL,
  revisado                NUMBER(1,0)    NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



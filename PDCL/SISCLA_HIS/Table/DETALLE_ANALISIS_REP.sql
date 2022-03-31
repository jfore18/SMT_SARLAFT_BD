PROMPT CREATE TABLE detalle_analisis_rep
CREATE TABLE detalle_analisis_rep (
  id_reporte              NUMBER(10,0)  NOT NULL,
  no_acta                 NUMBER(5,0)   NOT NULL,
  fecha_acta              DATE          NULL,
  justificacion_final     VARCHAR2(500) NULL,
  codigo_estado_reporte_v VARCHAR2(3)   NULL,
  usuario_actualizacion   NUMBER(10,0)  NULL,
  fecha_actualizacion     DATE          NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



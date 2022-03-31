PROMPT CREATE INDEX in_rep_cargo
CREATE INDEX in_rep_cargo
  ON reporte (
    codigo_cargo
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_rep_estado
CREATE INDEX in_rep_estado
  ON reporte (
    codigo_estado_reporte_v
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_rep_fecha
CREATE INDEX in_rep_fecha
  ON reporte (
    fecha_creacion
  )
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT CREATE INDEX in_rep_ros
CREATE INDEX in_rep_ros
  ON reporte (
    ros_relacionado
  )
  STORAGE (
    NEXT       1024 K
  )
/


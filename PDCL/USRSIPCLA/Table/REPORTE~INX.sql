PROMPT CREATE INDEX idx_numero_identificacion
CREATE INDEX idx_numero_identificacion
  ON reporte (
    numero_identificacion
  )
  STORAGE (
    INITIAL    1024 K
  )
/

PROMPT CREATE INDEX in_rep_cargo
CREATE INDEX in_rep_cargo
  ON reporte (
    codigo_cargo
  )
  INITRANS   8
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_rep_estado
CREATE INDEX in_rep_estado
  ON reporte (
    codigo_estado_reporte_v
  )
  INITRANS   8
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_rep_fecha
CREATE INDEX in_rep_fecha
  ON reporte (
    fecha_creacion
  )
  INITRANS   8
  STORAGE (
    INITIAL     144 K
  )
/

PROMPT CREATE INDEX in_rep_ros
CREATE INDEX in_rep_ros
  ON reporte (
    ros_relacionado
  )
  INITRANS   8
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/


PROMPT CREATE TABLE archivos
CREATE TABLE archivos (
  codigo              NUMBER(5,0)  NOT NULL,
  codigo_tipo_archivo NUMBER(3,0)  NULL,
  codigo_producto_v   VARCHAR2(3)  NULL,
  usuario_creacion    NUMBER(10,0) NULL,
  fecha_creacion      DATE         NULL,
  nombre              VARCHAR2(20) NULL,
  ubicacion           VARCHAR2(30) NULL,
  tabla_detalle       VARCHAR2(20) NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



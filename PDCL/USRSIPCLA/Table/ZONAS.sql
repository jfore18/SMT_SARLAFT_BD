PROMPT CREATE TABLE zonas
CREATE TABLE zonas (
  codigo                NUMBER(3,0)  NOT NULL,
  codigo_region_v       VARCHAR2(3)  NOT NULL,
  nombre_corto          VARCHAR2(3)  NULL,
  nombre_largo          VARCHAR2(30) NULL,
  usuario_creacion      NUMBER(10,0) NULL,
  fecha_creacion        DATE         NULL,
  activa                NUMBER(1,0)  NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



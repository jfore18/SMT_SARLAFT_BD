PROMPT CREATE TABLE zonas
CREATE TABLE zonas (
  codigo           NUMBER(3,0)  NOT NULL,
  codigo_region_v  VARCHAR2(3)  NOT NULL,
  nombre_corto     VARCHAR2(3)  NULL,
  nombre_largo     VARCHAR2(30) NULL,
  usuario_creacion NUMBER(10,0) NULL,
  fecha_creacion   DATE         NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



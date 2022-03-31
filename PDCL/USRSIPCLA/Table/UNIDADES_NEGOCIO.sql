PROMPT CREATE TABLE unidades_negocio
CREATE TABLE unidades_negocio (
  codigo                NUMBER(4,0)  NOT NULL,
  codigo_zona           NUMBER(3,0)  NULL,
  codigo_region_v       VARCHAR2(3)  NULL,
  ceo                   NUMBER(1,0)  NULL,
  plaza_critica         NUMBER(1,0)  NULL,
  descripcion           VARCHAR2(40) NULL,
  activa                NUMBER(1,0)  NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL,
  is_megabanco          NUMBER(1,0)  NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



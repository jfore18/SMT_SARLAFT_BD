PROMPT CREATE TABLE cargos
CREATE TABLE cargos (
  codigo                VARCHAR2(6)  NOT NULL,
  codigo_unidad_negocio NUMBER(4,0)  NOT NULL,
  codigo_tipo_cargo_v   VARCHAR2(3)  NOT NULL,
  codigo_usuario        NUMBER(10,0) NULL,
  codigo_perfil_v       VARCHAR2(3)  NULL,
  activo                NUMBER(1,0)  NULL,
  fecha_creacion        DATE         NULL,
  usuario_creacion      NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL,
  usuario_actualizacion NUMBER(10,0) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



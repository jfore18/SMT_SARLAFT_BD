PROMPT CREATE TABLE usuario
CREATE TABLE usuario (
  cedula                NUMBER(10,0) NOT NULL,
  nombre                VARCHAR2(40) NULL,
  activo                NUMBER(1,0)  NULL,
  dominio_usuario       VARCHAR2(30) NULL,
  fecha_creacion        DATE         NULL,
  usuario_creacion      NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  password              VARCHAR2(30) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



PROMPT CREATE TABLE historico_usuario_cargo
CREATE TABLE historico_usuario_cargo (
  id                    NUMBER(10,0) NOT NULL,
  codigo_usuario        NUMBER(10,0) NULL,
  codigo_cargo          VARCHAR2(6)  NULL,
  activo                NUMBER(1,0)  NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



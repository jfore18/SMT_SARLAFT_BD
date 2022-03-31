PROMPT CREATE TABLE lista_valores
CREATE TABLE lista_valores (
  tipo_dato             NUMBER(2,0)  NOT NULL,
  codigo                VARCHAR2(3)  NOT NULL,
  nombre_corto          VARCHAR2(3)  NULL,
  nombre_largo          VARCHAR2(50) NULL,
  aplica_gerente        VARCHAR2(1)  NULL,
  activo                NUMBER(1,0)  NULL,
  fecha_actualizacion   DATE         NULL,
  usuario_actualizacion NUMBER(10,0) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



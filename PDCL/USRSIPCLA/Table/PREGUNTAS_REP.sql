PROMPT CREATE TABLE preguntas_rep
CREATE TABLE preguntas_rep (
  id                    NUMBER(3,0)  NOT NULL,
  descripcion           VARCHAR2(90) NULL,
  vigente_desde         DATE         NULL,
  vigente_hasta         DATE         NULL,
  codigo_perfil_v       VARCHAR2(3)  NULL,
  tipo_pregunta_v       VARCHAR2(3)  NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



PROMPT CREATE TABLE actividad_economica
CREATE TABLE actividad_economica (
  codigo      VARCHAR2(5)   NOT NULL,
  descripcion VARCHAR2(200) NOT NULL,
  alto_riesgo NUMBER(1,0)   NOT NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



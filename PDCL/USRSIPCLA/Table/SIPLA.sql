PROMPT CREATE TABLE sipla
CREATE TABLE sipla (
  tipo_identificacion   VARCHAR2(3)  NOT NULL,
  numero_identificacion VARCHAR2(11) NOT NULL,
  acumulado_credito     NUMBER(17,2) NULL
)
  STORAGE (
    INITIAL     144 K
  )
/



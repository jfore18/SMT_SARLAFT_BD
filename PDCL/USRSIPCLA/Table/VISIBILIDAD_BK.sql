PROMPT CREATE TABLE visibilidad_bk
CREATE TABLE visibilidad_bk (
  id              NUMBER(10,0)  NOT NULL,
  id_consulta     NUMBER(3,0)   NOT NULL,
  tabla           VARCHAR2(100) NOT NULL,
  columna         VARCHAR2(200) NOT NULL,
  alias           VARCHAR2(60)  NULL,
  conector        VARCHAR2(20)  NULL,
  atributo        VARCHAR2(60)  NULL,
  conector_final  VARCHAR2(40)  NULL,
  group_by        NUMBER(1,0)   NULL,
  orden           NUMBER(2,0)   NULL,
  codigo_perfil_v VARCHAR2(3)   NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



PROMPT CREATE TABLE municipio
CREATE TABLE municipio (
  codigo         VARCHAR2(8)  NOT NULL,
  centro_poblado VARCHAR2(30) NOT NULL,
  departamento   VARCHAR2(30) NOT NULL,
  municipio      VARCHAR2(30) NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



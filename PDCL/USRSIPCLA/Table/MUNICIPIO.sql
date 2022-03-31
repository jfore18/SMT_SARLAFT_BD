PROMPT CREATE TABLE municipio
CREATE TABLE municipio (
  codigo         VARCHAR2(8)  NOT NULL,
  centro_poblado VARCHAR2(30) NOT NULL,
  departamento   VARCHAR2(30) NOT NULL,
  municipio      VARCHAR2(30) NOT NULL
)
  STORAGE (
    INITIAL     560 K
    NEXT       1024 K
  )
/



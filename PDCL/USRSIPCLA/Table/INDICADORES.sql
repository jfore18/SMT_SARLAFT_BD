PROMPT CREATE TABLE indicadores
CREATE TABLE indicadores (
  codigo_oficina   NUMBER(4,0)  NOT NULL,
  nombre_oficina   VARCHAR2(40) NULL,
  codigo_zona      NUMBER(3,0)  NULL,
  nombre_zona      VARCHAR2(30) NULL,
  codigo_region    VARCHAR2(3)  NULL,
  nombre_region    VARCHAR2(50) NULL,
  fuente           VARCHAR2(50) NOT NULL,
  recibidas_un     NUMBER       NULL,
  gestionadas_un   NUMBER       NULL,
  menor_tres_un    NUMBER       NULL,
  tres_cinco_un    NUMBER       NULL,
  mayor_cinco_un   NUMBER       NULL,
  recibidas_ducc   NUMBER       NULL,
  gestionadas_ducc NUMBER       NULL,
  menor_tres_ducc  NUMBER       NULL,
  tres_cinco_ducc  NUMBER       NULL,
  mayor_cinco_ducc NUMBER       NULL
)
  STORAGE (
    INITIAL     256 K
  )
/



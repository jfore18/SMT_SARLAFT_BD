PROMPT CREATE TABLE concepto_inicial
CREATE TABLE concepto_inicial (
  tipo_identificacion   VARCHAR2(3)  NOT NULL,
  numero_identificacion VARCHAR2(11) NOT NULL,
  id_reporte            NUMBER(10,0) NOT NULL
)
  STORAGE (
    INITIAL   16384 K
    NEXT       1024 K
  )
/



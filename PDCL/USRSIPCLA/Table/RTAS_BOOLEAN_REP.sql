PROMPT CREATE TABLE rtas_boolean_rep
CREATE TABLE rtas_boolean_rep (
  id_pregunta NUMBER(3,0)  NOT NULL,
  id_reporte  NUMBER(10,0) NOT NULL,
  respuesta   NUMBER(1,0)  NULL
)
  INITRANS   6
  STORAGE (
    INITIAL     144 K
  )
/



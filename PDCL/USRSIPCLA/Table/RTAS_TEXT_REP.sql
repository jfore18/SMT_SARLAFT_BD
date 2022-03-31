PROMPT CREATE TABLE rtas_text_rep
CREATE TABLE rtas_text_rep (
  id_pregunta NUMBER(3,0)  NOT NULL,
  id_reporte  NUMBER(10,0) NOT NULL,
  respuesta   VARCHAR2(15) NULL
)
  STORAGE (
    INITIAL     144 K
  )
/



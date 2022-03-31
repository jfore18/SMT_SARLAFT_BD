PROMPT CREATE TABLE tipo_campo
CREATE TABLE tipo_campo (
  codigo           NUMBER(3,0)  NOT NULL,
  descripcion      VARCHAR2(30) NULL,
  formato          VARCHAR2(20) NULL,
  codigo_tipo_dato VARCHAR2(3)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



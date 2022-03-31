PROMPT CREATE TABLE mensajes
CREATE TABLE mensajes (
  codigo      NUMBER(5,0)  NOT NULL,
  descripcion VARCHAR2(50) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



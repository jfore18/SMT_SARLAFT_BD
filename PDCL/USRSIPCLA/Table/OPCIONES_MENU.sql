PROMPT CREATE TABLE opciones_menu
CREATE TABLE opciones_menu (
  codigo      NUMBER(3,0)  NOT NULL,
  descripcion VARCHAR2(25) NULL,
  pagina      VARCHAR2(60) NULL,
  class       VARCHAR2(10) NULL,
  opcion      VARCHAR2(10) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



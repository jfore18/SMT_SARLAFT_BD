PROMPT CREATE TABLE comentarios
CREATE TABLE comentarios (
  id               NUMBER(10,0)  NOT NULL,
  codigo_archivo   NUMBER(5,0)   NULL,
  fecha_proceso    DATE          NULL,
  id_transaccion   NUMBER(5,0)   NULL,
  comentario       VARCHAR2(280) NOT NULL,
  usuario_creacion NUMBER(10,0)  NULL,
  fecha_creacion   DATE          NULL
)
  STORAGE (
    INITIAL     144 K
  )
/



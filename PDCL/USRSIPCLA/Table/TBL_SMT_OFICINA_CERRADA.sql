PROMPT CREATE TABLE tbl_smt_oficina_cerrada
CREATE TABLE tbl_smt_oficina_cerrada (
  oficina_cierra NUMBER(4,0) NOT NULL,
  oficina_recibe NUMBER(4,0) NOT NULL,
  fecha_registro DATE        NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



PROMPT CREATE TABLE equivalencias
CREATE TABLE equivalencias (
  tipo_equivalencia VARCHAR2(2)  NOT NULL,
  codigo_bd         VARCHAR2(10) NOT NULL,
  equivalencia      VARCHAR2(50) NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/

COMMENT ON TABLE equivalencias IS 'EQUIV 1 -> UNIDADES NEGOCIO';



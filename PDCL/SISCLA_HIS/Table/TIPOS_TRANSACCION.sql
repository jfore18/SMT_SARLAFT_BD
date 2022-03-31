PROMPT CREATE TABLE tipos_transaccion
CREATE TABLE tipos_transaccion (
  codigo_producto_v  VARCHAR2(3)  NOT NULL,
  codigo_transaccion VARCHAR2(6)  NOT NULL,
  descripcion        VARCHAR2(60) NULL,
  mayor_riesgo       NUMBER(1,0)  NULL,
  naturaleza         VARCHAR2(1)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



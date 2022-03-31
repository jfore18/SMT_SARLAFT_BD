PROMPT CREATE TABLE tipos_transaccion
CREATE TABLE tipos_transaccion (
  codigo_producto_v  VARCHAR2(3)  NOT NULL,
  codigo_transaccion VARCHAR2(8)  NOT NULL,
  descripcion        VARCHAR2(70) NULL,
  mayor_riesgo       NUMBER(1,0)  NULL,
  naturaleza         VARCHAR2(1)  NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/



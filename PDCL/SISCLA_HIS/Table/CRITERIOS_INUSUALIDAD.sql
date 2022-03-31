PROMPT CREATE TABLE criterios_inusualidad
CREATE TABLE criterios_inusualidad (
  id                    NUMBER(5,0)  NOT NULL,
  descripcion           VARCHAR2(30) NULL,
  mensaje               VARCHAR2(50) NULL,
  funcion               VARCHAR2(30) NULL,
  activo                NUMBER(1,0)  NULL,
  usuario_desactivacion NUMBER(10,0) NULL,
  fecha_desactivacion   DATE         NULL,
  codigo_producto_v     VARCHAR2(3)  NULL,
  descripcion_p1        VARCHAR2(20) NULL,
  valor_p1              VARCHAR2(50) NULL,
  lista_valor_p1        VARCHAR2(20) NULL,
  descripcion_p2        VARCHAR2(20) NULL,
  valor_p2              VARCHAR2(50) NULL,
  lista_valor_p2        VARCHAR2(20) NULL,
  descripcion_p3        VARCHAR2(20) NULL,
  valor_p3              VARCHAR2(50) NULL,
  lista_valor_p3        VARCHAR2(20) NULL,
  descripcion_p4        VARCHAR2(20) NULL,
  valor_p4              VARCHAR2(50) NULL,
  lista_valor_p4        VARCHAR2(20) NULL,
  descripcion_p5        VARCHAR2(20) NULL,
  valor_p5              VARCHAR2(50) NULL,
  lista_valor_p5        VARCHAR2(20) NULL,
  usuario_creacion      NUMBER(10,0) NULL,
  fecha_creacion        DATE         NULL,
  procesar_por_grupos   NUMBER(1,0)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



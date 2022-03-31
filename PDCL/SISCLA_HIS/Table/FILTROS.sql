PROMPT CREATE TABLE filtros
CREATE TABLE filtros (
  id                    NUMBER(10,0)  NOT NULL,
  codigo_cargo          VARCHAR2(6)   NULL,
  codigo_producto       VARCHAR2(3)   NULL,
  numero_negocio        VARCHAR2(20)  NULL,
  tipo_identificacion   VARCHAR2(3)   NULL,
  numero_identificacion VARCHAR2(11)  NULL,
  condicion             VARCHAR2(50)  NULL,
  vigente_desde         DATE          NULL,
  vigente_hasta         DATE          NULL,
  justificacion         VARCHAR2(300) NULL,
  usuario_creacion      NUMBER(10,0)  NULL,
  fecha_creacion        DATE          NULL,
  confirmar             NUMBER(1,0)   DEFAULT 0 NULL,
  fecha_confirmacion    DATE          NULL,
  usuario_confirmacion  NUMBER(10,0)  NULL
)
  STORAGE (
    NEXT       1024 K
  )
/



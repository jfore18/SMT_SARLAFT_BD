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
  usuario_confirmacion  NUMBER(10,0)  NULL,
  estado_filtro         VARCHAR2(1)   DEFAULT '0' NOT NULL,
  usuario_supervisor    NUMBER(10,0)  NULL,
  fecha_supervisor      DATE          NULL,
  concepto_supervisor   VARCHAR2(300) NULL
)
  STORAGE (
    INITIAL     144 K
    NEXT       1024 K
  )
/

COMMENT ON COLUMN filtros.estado_filtro IS '0-Pendiente, 1-Aprobado,2-Inactivo, 3-Rechazado';
COMMENT ON COLUMN filtros.usuario_supervisor IS 'Usuario que aprueba,rechaza un filtro';
COMMENT ON COLUMN filtros.fecha_supervisor IS 'Fecha en que el supervisor aprueba/rechaza el filtro';
COMMENT ON COLUMN filtros.concepto_supervisor IS 'Concepto emitido por el supervisor al momento de rechazar un filtro';


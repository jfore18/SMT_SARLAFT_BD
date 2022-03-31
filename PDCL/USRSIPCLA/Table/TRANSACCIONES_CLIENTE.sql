PROMPT CREATE TABLE transacciones_cliente
CREATE TABLE transacciones_cliente (
  codigo_archivo             NUMBER(5,0)   NOT NULL,
  fecha_proceso              DATE          NOT NULL,
  id                         NUMBER(5,0)   NOT NULL,
  codigo_actividad_economica VARCHAR2(5)   NULL,
  codigo_oficina             NUMBER(4,0)   NULL,
  codigo_oficina_origen      NUMBER(4,0)   NULL,
  codigo_transaccion         VARCHAR2(8)   NULL,
  estado_ducc                VARCHAR2(1)   NULL,
  estado_oficina             VARCHAR2(1)   NULL,
  fecha                      DATE          NULL,
  filtro_ducc                NUMBER(1,0)   NULL,
  filtro_oficina             NUMBER(1,0)   NULL,
  mayor_riesgo               NUMBER(1,0)   NULL,
  nombre_cliente             VARCHAR2(40)  NULL,
  nueva                      NUMBER(1,0)   NULL,
  procesada_criterios        NUMBER(1,0)   NULL,
  procesada_filtros          NUMBER(1,0)   NULL,
  no_comentarios             NUMBER(3,0)   NULL,
  no_comentarios_ducc        NUMBER(2,0)   NULL,
  no_criterios               NUMBER(3,0)   NULL,
  numero_negocio             VARCHAR2(20)  NULL,
  tipo_identificacion        VARCHAR2(3)   NULL,
  numero_identificacion      VARCHAR2(11)  NULL,
  valor_transaccion          NUMBER(17,2)  NULL,
  usuario_creacion           NUMBER(10,0)  NULL,
  usuario_actualizacion      NUMBER(10,0)  NULL,
  fecha_actualizacion        DATE          NULL,
  procesada_pitufeo          NUMBER(1,0)   NULL,
  chequeada                  NUMBER(1,0)   DEFAULT 0 NULL,
  descripcion_transaccion    VARCHAR2(200) NULL
)
  STORAGE (
    INITIAL    1400 K
  )
/



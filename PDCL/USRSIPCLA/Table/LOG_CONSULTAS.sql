PROMPT CREATE TABLE log_consultas
CREATE TABLE log_consultas (
  consecutivo         NUMBER(10,0)   NOT NULL,
  usuario             NUMBER(10,0)   NOT NULL,
  canal               VARCHAR2(200)  NULL,
  nombre_pc           VARCHAR2(50)   NOT NULL,
  fecha_ejecucion     DATE           NOT NULL,
  query               VARCHAR2(4000) NOT NULL,
  usuario_nt          VARCHAR2(15)   DEFAULT ' ' NOT NULL,
  enviado             CHAR(1)        DEFAULT 0 NOT NULL,
  fecha_envio         DATE           DEFAULT SYSDATE NULL,
  dominio_red         VARCHAR2(16)   DEFAULT ' ' NOT NULL,
  tipo_id             CHAR(1)        NULL,
  numero_id           NUMBER(12,0)   NULL,
  tipo_producto       VARCHAR2(6)    NULL,
  numero_producto     VARCHAR2(16)   NULL,
  tipo_busqueda       NUMBER(1,0)    DEFAULT 0 NOT NULL,
  tipo_transaccion    NUMBER(1,0)    DEFAULT 0 NOT NULL,
  resultado_tx        NUMBER(1,0)    DEFAULT 0 NOT NULL,
  descripcion_rechazo VARCHAR2(20)   NULL
)
  STORAGE (
    NEXT       1024 K
  )
/

COMMENT ON COLUMN log_consultas.consecutivo IS 'Consecutivo en la tabla de consultas';
COMMENT ON COLUMN log_consultas.usuario IS 'Identificacion de usuario, ya sea cedula, usuario de red, usuario bd';
COMMENT ON COLUMN log_consultas.canal IS 'Nombre de la Pantalla o Servicio  consultada';
COMMENT ON COLUMN log_consultas.nombre_pc IS 'Nombre pc o equipo';
COMMENT ON COLUMN log_consultas.fecha_ejecucion IS 'Fecha y hora de la consulta realizada';
COMMENT ON COLUMN log_consultas.query IS 'Sentencia sql o condicion de busqueda';
COMMENT ON COLUMN log_consultas.usuario_nt IS 'Usuario de red';
COMMENT ON COLUMN log_consultas.enviado IS '0= no enviado, 1= enviado';
COMMENT ON COLUMN log_consultas.fecha_envio IS 'Fecha en que fue reportado en el archivo log';
COMMENT ON COLUMN log_consultas.dominio_red IS 'Dominio de red';
COMMENT ON COLUMN log_consultas.tipo_id IS 'Tipo de identificacion del cliente';
COMMENT ON COLUMN log_consultas.numero_id IS 'Numero de identificacion del cliente';
COMMENT ON COLUMN log_consultas.tipo_producto IS 'Tipo de producto';
COMMENT ON COLUMN log_consultas.numero_producto IS 'Numero de producto';
COMMENT ON COLUMN log_consultas.tipo_busqueda IS '1= individual, 2= Masiva';
COMMENT ON COLUMN log_consultas.tipo_transaccion IS '1= Consulta, 2= Actualizacion, 3= Eliminacion';
COMMENT ON COLUMN log_consultas.resultado_tx IS '1=Exitosa 2=Declinada';
COMMENT ON COLUMN log_consultas.descripcion_rechazo IS 'Se registra la causal de rechazo';


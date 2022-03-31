PROMPT CREATE OR REPLACE VIEW v_clientes_filtros
CREATE OR REPLACE VIEW v_clientes_filtros (
  tipo_identificacion,
  numero_identificacion,
  codigo_oficina,
  total,
  ceo,
  zona,
  region
) AS
SELECT tipo_identificacion
, numero_identificacion
, codigo_oficina
, SUM(total) total
, ceo
, zona
, region
FROM (
  SELECT tc.tipo_identificacion
  , tc.numero_identificacion
  , tc.codigo_oficina
  , count(DISTINCT tc.fecha_proceso) total
  , un.ceo
  , un.codigo_zona zona
  , un.codigo_region_v region
  FROM transacciones_cliente tc
  , unidades_negocio un
  WHERE tc.codigo_oficina = un.codigo
  AND tc.estado_oficina = 'N'
  GROUP BY tc.tipo_identificacion
  , tc.numero_identificacion
  , tc.codigo_oficina
  , un.ceo
  , un.codigo_zona
  , un.codigo_region_v
  UNION
  SELECT htc.tipo_identificacion
  , htc.numero_identificacion
  , htc.codigo_oficina
  , count(DISTINCT htc.fecha_proceso) total
  , un.ceo
  , un.codigo_zona zona
  , un.codigo_region_v region
  FROM siscla_his.transacciones_cliente htc
  , unidades_negocio un
  WHERE htc.codigo_oficina = un.codigo
  AND htc.estado_oficina = 'N'
  GROUP BY htc.tipo_identificacion
  , htc.numero_identificacion
  , htc.codigo_oficina
  , un.ceo
  , un.codigo_zona
  , un.codigo_region_v
)
GROUP BY tipo_identificacion
, numero_identificacion
, codigo_oficina
, ceo
, zona
, region
HAVING SUM(total) > 2
OR (ceo = 1 AND SUM(total) > 0)
/


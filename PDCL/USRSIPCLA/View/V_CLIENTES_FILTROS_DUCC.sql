PROMPT CREATE OR REPLACE VIEW v_clientes_filtros_ducc
CREATE OR REPLACE VIEW v_clientes_filtros_ducc (
  tipo_identificacion,
  numero_identificacion,
  codigo_region,
  total
) AS
SELECT tipo_identificacion
, numero_identificacion
, codigo_region
, SUM(total) total
FROM(
  SELECT tc.tipo_identificacion
  , tc.numero_identificacion
  , un.codigo_region_v codigo_region
  ,COUNT(DISTINCT tc.fecha_proceso) total
  FROM transacciones_cliente tc
  , unidades_negocio un
  WHERE un.codigo = tc.codigo_oficina
  AND tc.estado_ducc = 'N'
  GROUP BY tc.tipo_identificacion
  , tc.numero_identificacion
  , un.codigo_region_v
  UNION
  SELECT htc.tipo_identificacion
  , htc.numero_identificacion
  , un.codigo_region_v codigo_region
  ,COUNT(DISTINCT htc.fecha_proceso) total
  FROM siscla_his.transacciones_cliente htc
  , unidades_negocio un
  WHERE un.codigo = htc.codigo_oficina
  AND htc.estado_ducc = 'N'
  GROUP BY htc.tipo_identificacion
  , htc.numero_identificacion
  , un.codigo_region_v
)
GROUP BY tipo_identificacion
, numero_identificacion
, codigo_region
HAVING SUM(total) > 2
/


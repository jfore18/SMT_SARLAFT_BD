PROMPT CREATE OR REPLACE VIEW v_criterios_tr1
CREATE OR REPLACE VIEW v_criterios_tr1 (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  id_criterio_inusualidad,
  codigo_tipolista_v,
  perfil,
  mensaje
) AS
SELECT
CTR.codigo_archivo,
CTR.fecha_proceso,
CTR.id_transaccion,
CTR.id_criterio_inusualidad,
CTR.codigo_tipolista_v,
CPF.codigo_perfil perfil,
CIN.mensaje || ' ' || LOV.nombre_largo mensaje
FROM
CRITERIOS_TRANSACCION CTR,
CRITERIOS_INUSUALIDAD CIN,
LISTA_VALORES LOV,
CRITERIOS_PERFIL CPF
WHERE
CTR.id_criterio_inusualidad = CIN.id
AND CTR.id_criterio_inusualidad = CPF.id_criterio_inusualidad
AND LOV.tipo_dato (+) = 16--15
AND LOV.codigo (+) = CTR.codigo_tipolista_v
/


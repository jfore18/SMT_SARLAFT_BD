PROMPT CREATE OR REPLACE VIEW v_criterios_admin
CREATE OR REPLACE VIEW v_criterios_admin (
  id,
  descripcion,
  mensaje,
  funcion,
  activo,
  codigo_producto_v,
  producto,
  usuario_creacion,
  fecha_creacion,
  procesar_por_grupos
) AS
SELECT
  CI.ID,
  CI.DESCRIPCION,
  CI.MENSAJE,
  CI.FUNCION,
  CI.ACTIVO,
  CI.CODIGO_PRODUCTO_V,
  LV.NOMBRE_LARGO "PRODUCTO",
  CI.USUARIO_CREACION,
  CI.FECHA_CREACION,
  CI.PROCESAR_POR_GRUPOS
FROM
  CRITERIOS_INUSUALIDAD CI
  LEFT OUTER JOIN
  LISTA_VALORES LV
  ON CI.CODIGO_PRODUCTO_V = LV.CODIGO
WHERE
  CI.FUNCION = 'f_clementine'
  AND LV.TIPO_DATO = 27
  AND CI.CODIGO_PRODUCTO_V = LV.CODIGO
  ORDER BY CI.ID
/


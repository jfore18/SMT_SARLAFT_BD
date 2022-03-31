PROMPT CREATE OR REPLACE VIEW v_zonas
CREATE OR REPLACE VIEW v_zonas (
  codigo_zona,
  codigo_region_v,
  nombre_region,
  region_activa,
  nombre_corto,
  nombre_largo,
  activa,
  usuario_creacion,
  fecha_creacion,
  usuario_actualizacion,
  fecha_actualizacion
) AS
SELECT
Z.CODIGO CODIGO_ZONA,
R.CODIGO CODIGO_REGION_V,
R.DESC_LARGA NOMBRE_REGION,
R.ACTIVO REGION_ACTIVA,
Z.NOMBRE_CORTO,
Z.NOMBRE_LARGO,
Z.ACTIVA,
Z.USUARIO_CREACION,
Z.FECHA_CREACION,
Z.USUARIO_ACTUALIZACION,
Z.FECHA_ACTUALIZACION
FROM ZONAS Z,
V_REGION R
WHERE Z.CODIGO_REGION_V = R.CODIGO
/


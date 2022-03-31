PROMPT CREATE OR REPLACE VIEW v_transacciones
CREATE OR REPLACE VIEW v_transacciones (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  fecha,
  tipo_identificacion,
  numero_identificacion,
  identificacion,
  cliente,
  n_producto,
  codigo_fuente,
  fuente,
  codigo_tr,
  valor,
  codigo_estado_oficina,
  codigo_estado_ducc,
  estado_oficina,
  estado_ducc,
  no_comentarios,
  total_comentarios,
  m_riesgo,
  mayor_riesgo,
  filtro_of,
  filtro_ducc,
  nueva,
  nc_region,
  region,
  nc_zona,
  zona,
  codigo_oficina,
  oficina,
  descripcion_tipo_tr,
  chequeada
) AS
SELECT
codigo_archivo,
fecha_proceso,
id id_transaccion,
fecha,
tipo_identificacion,
numero_identificacion,
tipo_identificacion||'-'||numero_identificacion IDENTIFICACION,
nombre_cliente CLIENTE,
numero_negocio "N_PRODUCTO",
VP.codigo CODIGO_FUENTE,
VP.NOMBRE_CORTO FUENTE,
TC.codigo_transaccion "CODIGO_TR",
valor_transaccion VALOR,
VE1.CODIGO codigo_estado_oficina,
VE2.CODIGO codigo_estado_ducc,
VE1.nombre_corto estado_oficina,
VE2.nombre_corto estado_ducc,
NVL(NO_COMENTARIOS,0) NO_COMENTARIOS,
NVL(NVL(NO_COMENTARIOS,0) + NVL(NO_COMENTARIOS_DUCC,0),0) "TOTAL_COMENTARIOS",
DECODE( TC.MAYOR_RIESGO, '1', 'X', ' ') "M_RIESGO",
TC.MAYOR_RIESGO,
DECODE(FILTRO_OFICINA,'1','X',' ') "FILTRO_OF",
DECODE(FILTRO_DUCC,'1','X',' ') "FILTRO_DUCC",
nueva,
VR.NOMBRE_CORTO NC_REGION,
VR.CODIGO REGION,
Z.NOMBRE_CORTO NC_ZONA,
Z.CODIGO ZONA,
CODIGO_OFICINA CODIGO_OFICINA,
UN.DESCRIPCION OFICINA,
TT.DESCRIPCION DESCRIPCION_TIPO_TR,
TC.CHEQUEADA
FROM
usrsipcla.TRANSACCIONES_CLIENTE TC,
usrsipcla.UNIDADES_NEGOCIO UN,
usrsipcla.ZONAS Z,
usrsipcla.lista_valores VR,
usrsipcla.lista_valores VE1,
usrsipcla.lista_valores VE2,
usrsipcla.lista_valores VP,
usrsipcla.TIPOS_TRANSACCION TT,
usrsipcla.archivos AR
WHERE
UN.CODIGO = TC.CODIGO_OFICINA AND
VR.TIPO_DATO = 3 AND
VR.CODIGO = UN.CODIGO_REGION_V AND
Z.CODIGO_REGION_V = UN.CODIGO_REGION_V AND
Z.CODIGO = UN.CODIGO_ZONA AND
VE1.TIPO_DATO = 11 AND
VE1.CODIGO = TC.ESTADO_OFICINA AND
VE2.TIPO_DATO = 11 AND
VE2.CODIGO = TC.ESTADO_DUCC AND
VP.TIPO_DATO = 2  AND
ar.codigo = tc.codigo_archivo and
VP.CODIGO = ar.codigo_producto_v and
TT.CODIGO_TRANSACCION = TC.CODIGO_TRANSACCION AND
TT.CODIGO_PRODUCTO_V = AR.CODIGO_PRODUCTO_V
/


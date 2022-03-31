PROMPT CREATE OR REPLACE VIEW v_detalle_tr
CREATE OR REPLACE VIEW v_detalle_tr (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  fecha,
  tipo_identificacion,
  numero_identificacion,
  cliente,
  cliente_crm,
  telefono,
  actividad_econ,
  segmento,
  n_producto,
  fuente,
  codigo_tr,
  descripcion_tr,
  naturaleza_tr,
  valor,
  codigo_estado_oficina,
  codigo_estado_ducc,
  estado_oficina,
  estado_ducc,
  filtro_of,
  filtro_ducc,
  codigo_oficina,
  oficina,
  codigo_oficina_origen,
  oficina_origen,
  zona,
  region,
  descripcion_transaccion
) AS
SELECT
codigo_archivo,
fecha_proceso,
id id_transaccion,
fecha,
TC.tipo_identificacion,
TC.numero_identificacion,
nombre_cliente CLIENTE,
CLI.nombre_razon_social CLIENTE_CRM,
CLI.telefono telefono,
ACT.codigo || ' ' || ACT.descripcion ACTIVIDAD_ECON,
SEG.descripcion SEGMENTO,
numero_negocio "N_PRODUCTO",
VP.NOMBRE_CORTO FUENTE,
TC.codigo_transaccion "CODIGO_TR",
TT.DESCRIPCION DESCRIPCION_TR,
TT.NATURALEZA NATURALEZA_TR,
valor_transaccion VALOR,
EST1.CODIGO codigo_estado_oficina,
EST2.CODIGO codigo_estado_ducc,
EST1.nombre_corto estado_oficina,
EST2.nombre_corto estado_ducc,
DECODE(FILTRO_OFICINA,'1','SI','NO') "FILTRO_OF",
DECODE(FILTRO_DUCC,'1','SI','NO') "FILTRO_DUCC",
CODIGO_OFICINA CODIGO_OFICINA,
UN.DESCRIPCION OFICINA,
CODIGO_OFICINA_ORIGEN CODIGO_OFICINA_ORIGEN,
UN1.DESCRIPCION OFICINA_ORIGEN,
Z.NOMBRE_CORTO ZONA,
R.NOMBRE_CORTO REGION,
TC.DESCRIPCION_TRANSACCION
FROM TRANSACCIONES_CLIENTE TC,
CLIENTES CLI,
UNIDADES_NEGOCIO UN,
UNIDADES_NEGOCIO UN1,
ACTIVIDAD_ECONOMICA ACT,
SEGMENTOS_COMERCIALES SEG,
LISTA_VALORES EST1,
LISTA_VALORES EST2,
LISTA_VALORES VP,
TIPOS_TRANSACCION TT,
ARCHIVOS AR,
ZONAS Z,
LISTA_VALORES R
WHERE
TC.TIPO_IDENTIFICACION = CLI.TIPO_IDENTIFICACION(+) AND
TC.NUMERO_IDENTIFICACION = CLI.NUMERO_IDENTIFICACION(+) AND
ACT.CODIGO (+) = CLI.CODIGO_ACTIVIDAD_ECONOMICA AND
SEG.CODIGO (+) = CLI.CODIGO_SEGMENTO_COMERCIAL AND
UN.CODIGO = TC.CODIGO_OFICINA AND
UN1.CODIGO (+) = TC.CODIGO_OFICINA_ORIGEN AND
EST1.TIPO_DATO = 11 AND
EST1.CODIGO = TC.ESTADO_OFICINA AND
EST2.TIPO_DATO = 11 AND
EST2.CODIGO = TC.ESTADO_DUCC AND
VP.TIPO_DATO = 2  AND
AR.codigo = TC.codigo_archivo AND
VP.CODIGO = AR.codigo_producto_v AND
TT.CODIGO_TRANSACCION = TC.CODIGO_TRANSACCION AND
TT.CODIGO_PRODUCTO_V = AR.CODIGO_PRODUCTO_V AND
Z.CODIGO = UN.CODIGO_ZONA AND
Z.CODIGO_REGION_V = UN.CODIGO_REGION_V AND
R.CODIGO = Z.CODIGO_REGION_V AND
R.TIPO_DATO = 3
/


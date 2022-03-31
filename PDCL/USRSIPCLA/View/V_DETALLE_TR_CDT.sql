PROMPT CREATE OR REPLACE VIEW v_detalle_tr_cdt
CREATE OR REPLACE VIEW v_detalle_tr_cdt (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  tasa,
  tipo_interes,
  periodo,
  plazo,
  nombre_titular_2,
  id_titular_2,
  nombre_titular_3,
  id_titular_3,
  nombre_titular_4,
  id_titular_4,
  oficina,
  fecha_apertura,
  tipo_cdt
) AS
SELECT
DTCDT.codigo_archivo,
DTCDT.fecha_proceso,
id_transaccion,
tasa_interes tasa,
DECODE(tipo_interes,'A','Anticipado','V','Vencido','') tipo_interes,
periodo_interes periodo,
plazo,
nombre_titular_2,
DECODE(tipo_id_titular_2, NULL, NULL, tipo_id_titular_2 || '-' || numero_id_titular_2) id_titular_2,
nombre_titular_3,
DECODE(tipo_id_titular_3, NULL, NULL, tipo_id_titular_3 || '-' || numero_id_titular_3) id_titular_3,
nombre_titular_4,
DECODE(tipo_id_titular_4, NULL, NULL, tipo_id_titular_4 || '-' || numero_id_titular_4) id_titular_4,
U.DESCRIPCION OFICINA,
fecha_apertura,
DECODE(tipo_cdt,'D','Desmaterializado','F','Fisico')tipo_cdt
FROM
DETALLE_TR_CDT DTCDT,
TRANSACCIONES_CLIENTE T,
UNIDADES_NEGOCIO U
WHERE
DTCDT.CODIGO_ARCHIVO = T.CODIGO_ARCHIVO AND
DTCDT.FECHA_PROCESO = T.FECHA_PROCESO AND
DTCDT.ID_TRANSACCION = T.ID AND
U.CODIGO = T.CODIGO_OFICINA
/


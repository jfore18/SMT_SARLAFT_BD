PROMPT CREATE OR REPLACE VIEW v_detalle_tr_cc
CREATE OR REPLACE VIEW v_detalle_tr_cc (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  fecha_apertura,
  valor_canje,
  signo_sobregiro,
  saldo,
  signo_promedio,
  promedio_semestral,
  estado_cuenta,
  documento_tr,
  oficina,
  codigo_transaccion
) AS
SELECT
DTCC.codigo_archivo,
DTCC.fecha_proceso,
id_transaccion,
fecha_apertura,
TO_CHAR(valor_canje,'999,999,999,999.99') VALOR_CANJE,
signo_sobregiro,
TO_CHAR(saldo,'999,999,999,999.99') SALDO,
signo_promedio,
TO_CHAR(promedio_semestral,'999,999,999,999.99') PROMEDIO_SEMESTRAL,
DECODE(estado_cuenta,'00','Activa',
'01','Congelada',
'02','Embargada',
'03','Cancelada saldo +',
'04','Cancelada saldo 0',
'05','Borrada',
'07','Inactiva',
'08','Terminada',
'09','Calcelada saldo -',
'Indeterminado') estado_cuenta,
documento_tr,
U.DESCRIPCION OFICINA,
t.codigo_transaccion
FROM
DETALLE_TR_CC DTCC,
TRANSACCIONES_CLIENTE T,
UNIDADES_NEGOCIO U
WHERE
DTCC.CODIGO_ARCHIVO = T.CODIGO_ARCHIVO AND
DTCC.FECHA_PROCESO = T.FECHA_PROCESO AND
DTCC.ID_TRANSACCION = T.ID AND
U.CODIGO = T.CODIGO_OFICINA
/


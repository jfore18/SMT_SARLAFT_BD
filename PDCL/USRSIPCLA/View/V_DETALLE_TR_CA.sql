PROMPT CREATE OR REPLACE VIEW v_detalle_tr_ca
CREATE OR REPLACE VIEW v_detalle_tr_ca (
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
DTCA.codigo_archivo,
DTCA.fecha_proceso,
id_transaccion,
fecha_apertura,
TO_CHAR(valor_canje,'999,999,999,999.99') VALOR_CANJE,
signo_sobregiro,
TO_CHAR(saldo,'999,999,999,999.99') SALDO,
signo_promedio,
TO_CHAR(promedio_semestral,'999,999,999,999.99') PROMEDIO_SEMESTRAL,
DECODE(estado_cuenta,'00','Activa',
'01','Inactiva',
'02','Embargada',
'03','Cerrada',
'04','Terminada',
'05','Purgada',
'08','Congelada',
'Indeterminado') estado_cuenta,
documento_tr,
U.DESCRIPCION OFICINA,
t.codigo_transaccion
FROM
DETALLE_TR_CA DTCA,
TRANSACCIONES_CLIENTE T,
UNIDADES_NEGOCIO U
WHERE
DTCA.CODIGO_ARCHIVO = T.CODIGO_ARCHIVO AND
DTCA.FECHA_PROCESO = T.FECHA_PROCESO AND
DTCA.ID_TRANSACCION = T.ID AND
U.CODIGO = T.CODIGO_OFICINA
/


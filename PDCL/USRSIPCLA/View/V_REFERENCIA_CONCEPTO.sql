PROMPT CREATE OR REPLACE VIEW v_referencia_concepto
CREATE OR REPLACE VIEW v_referencia_concepto (
  id_reporte,
  id_transaccion,
  fecha_proceso,
  codigo_archivo,
  estado_oficina,
  referencia_oficina,
  estado_ducc,
  referencia_ducc
) AS
select
tr.id_reporte,
t.id id_transaccion,
t.fecha_proceso,
t.codigo_archivo,
t.estado_oficina,
decode ( r.codigo_clase_reporte_v,
'1', '<b>ID TN</b> '|| t.id || '.'||t.codigo_archivo||'.'||t.fecha_proceso,
'2', '<b>No INT REP</b> ' || tr.id_reporte
) REFERENCIA_OFICINA,
t.estado_ducc,
decode ( r.codigo_clase_reporte_v,
'1', '<b>ID TN</b> '|| t.id || '.'||t.codigo_archivo||'.'||t.fecha_proceso,
'2', '<b>No INT REP</b> ' || tr.id_reporte || DECODE(R.ROS_relacionado,NULL, '',  ' <b>ROS</b> '||R.ROS_RELACIONADO)
) REFERENCIA_DUCC
from
transacciones_rep tr,
transacciones_cliente t,
reporte r
where
tr.id_transaccion = t.id and
tr.fecha_proceso = t.fecha_proceso and
tr.codigo_archivo = t.codigo_archivo and
r.id = tr.id_reporte
/


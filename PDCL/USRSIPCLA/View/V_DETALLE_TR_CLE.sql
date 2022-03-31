PROMPT CREATE OR REPLACE VIEW v_detalle_tr_cle
CREATE OR REPLACE VIEW v_detalle_tr_cle (
  fecha_proceso,
  codigo_transaccion,
  numero_cuenta,
  numero_oper_dia,
  valor_oper_dia,
  prom_numero_oper_dia,
  prom_valor_oper_dia,
  max_histo_oper_dia,
  max_histo_valor_oper_dia
) AS
SELECT fecha_proceso
, codigo_transaccion
, numero_cuenta
, numero_operaciones_dia numero_oper_dia
, To_Char(valor_operaciones_dia,'999,999,999,999.99') valor_oper_dia
, prom_num_operaciones_dia prom_numero_oper_dia
, To_Char(prom_val_operaciones_dia,'999,999,999,999.99') prom_valor_oper_dia
, max_hist_operaciones_dia max_histo_oper_dia
, To_Char(max_hist_val_oper_dia,'999,999,999,999.99') max_histo_valor_oper_dia
FROM detalle_tr_cle
where tipo_alerta = '1'
/


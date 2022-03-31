PROMPT CREATE OR REPLACE PACKAGE pk_aplicar_criterios_grupales
CREATE OR REPLACE PACKAGE pk_aplicar_criterios_grupales
IS
   PROCEDURE p_evaluar_criterios;

   PROCEDURE p_pitufeo  ( idCriterio           NUMBER,
                          porcentajeDiferencia NUMBER,
                          nMinTransacciones    NUMBER,
                          vrMaxTransaccion     NUMBER);

   PROCEDURE p_grabar_criterio_pitufeo (p_codigo_archivo   CRITERIOS_TRANSACCION.codigo_archivo%TYPE,
   			 					        p_fecha_proceso    CRITERIOS_TRANSACCION.fecha_proceso%TYPE,
								        p_id_transaccion   CRITERIOS_TRANSACCION.id_transaccion%TYPE,
		                  		        p_id_criterio      CRITERIOS_TRANSACCION.id_criterio_inusualidad%TYPE);

   TYPE reg_tr_pitufeo  IS RECORD(codigo_archivo TRANSACCIONES_CLIENTE.codigo_archivo%TYPE,
                                  fecha_proceso  TRANSACCIONES_CLIENTE.fecha_proceso%TYPE,
                                  id_transaccion TRANSACCIONES_CLIENTE.id%TYPE,
                                  numero_negocio TRANSACCIONES_CLIENTE.numero_negocio%TYPE,
                                  valor_tr       TRANSACCIONES_CLIENTE.valor_transaccion%TYPE);

END;
/


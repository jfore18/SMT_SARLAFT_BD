PROMPT CREATE OR REPLACE PACKAGE pk_aplicar_criterios_inus
CREATE OR REPLACE PACKAGE pk_aplicar_criterios_inus
IS

   TYPE reg_criterio IS RECORD(sql_dinamico VARCHAR2(500));
   TYPE tab_criterios IS TABLE OF reg_criterio INDEX BY BINARY_INTEGER;
   arr_criterios tab_criterios;

   TYPE tab_paquetes IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   arr_nombres_paquetes tab_paquetes;

   nombre_paquete_grupos VARCHAR2(30);

   g_transaccion      TRANSACCIONES_CLIENTE%ROWTYPE;
   g_transaccion_cc   DETALLE_TR_CC%ROWTYPE;
   g_transaccion_ca   DETALLE_TR_CA%ROWTYPE;
   g_transaccion_cdt  DETALLE_TR_CDT%ROWTYPE;

-- AJUSTE
-- PROCEDURE p_evaluar_criterios_tr (tr IN OUT TRANSACCIONES_CLIENTE%ROWTYPE);
-- FIN AJUSTE
   PROCEDURE p_evaluar_criterios_tr (tr IN OUT TRANSACCIONES_CLIENTE%ROWTYPE, bitacora IN OUT utl_file.file_type);

   PROCEDURE p_cargar_detalle_tr (codigoProducto ARCHIVOS.codigo_producto_v%TYPE,
	  		 			          codigoArchivo  TRANSACCIONES_CLIENTE.codigo_archivo%TYPE,
	  		 			          fechaProceso   TRANSACCIONES_CLIENTE.fecha_proceso%TYPE,
						          idTransaccion  TRANSACCIONES_CLIENTE.id%TYPE);

   PROCEDURE p_grabar_criterio_tr(p_codigo_archivo   CRITERIOS_TRANSACCION.codigo_archivo%TYPE,
   			 					  p_fecha_proceso    CRITERIOS_TRANSACCION.fecha_proceso%TYPE,
								  p_id_transaccion   CRITERIOS_TRANSACCION.id_transaccion%TYPE,
		                  		  p_id_criterio      CRITERIOS_TRANSACCION.id_criterio_inusualidad%TYPE,
						  		  p_codigo_tipolista CRITERIOS_TRANSACCION.codigo_tipolista_v%TYPE);

   PROCEDURE p_crear_sqls_dinamicos (codProducto CRITERIOS_INUSUALIDAD.codigo_producto_v%TYPE,
                                     procesarGrupos CRITERIOS_INUSUALIDAD.procesar_por_grupos%TYPE DEFAULT 0);

   FUNCTION  f_get_sql_funcion_criterio (regCriterio CRITERIOS_INUSUALIDAD%ROWTYPE) RETURN VARCHAR2;

END;
/


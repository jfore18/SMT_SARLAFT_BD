PROMPT CREATE OR REPLACE PACKAGE BODY pk_aplicar_criterios_inus
CREATE OR REPLACE PACKAGE BODY pk_aplicar_criterios_inus
IS

   /* Adiciona un registro con los campos especificados a la tabla CRITERIOS_TRANSACCION
   */
   PROCEDURE p_grabar_criterio_tr (p_codigo_archivo   CRITERIOS_TRANSACCION.codigo_archivo%TYPE,
   			 					   p_fecha_proceso    CRITERIOS_TRANSACCION.fecha_proceso%TYPE,
								   p_id_transaccion   CRITERIOS_TRANSACCION.id_transaccion%TYPE,
		                  		   p_id_criterio      CRITERIOS_TRANSACCION.id_criterio_inusualidad%TYPE,
						  		   p_codigo_tipolista CRITERIOS_TRANSACCION.codigo_tipolista_v%TYPE) IS
   BEGIN

		  INSERT INTO CRITERIOS_TRANSACCION (
		                codigo_archivo,
						fecha_proceso,
						id_transaccion,
		                id_criterio_inusualidad,
						codigo_tipolista_v,
						usuario_creacion,
						fecha_creacion)
				VALUES (p_codigo_archivo,
				        p_fecha_proceso,
						p_id_transaccion,
						p_id_criterio,
						p_codigo_tipolista,
						Pk_Llamar_Procesos_Batch.g_cedula_usuario,
						SYSDATE);

   END p_grabar_criterio_tr;


   /* Almacena las llamadas SQL dinámicas a funciones de inusualidad activas y
      correspondientes con el código producto especificado como argumento
	  (incluyendo las funciones comunes a todos los productos), en el arreglo
      global arr_criterios.
	  Si se le suministra el valor 'null', como parámetro genera las llamadas
      dinámicas para todos los códigos de producto.
	  El parámetro procesarGrupos identifica si el conjunto de llamadas dinámicas
	  que se desea crear es de procesamiento individual (por transacción) o
	  por grupo (analiza un conjunto de transacciones a la vez).
   */
   PROCEDURE p_crear_sqls_dinamicos (codProducto CRITERIOS_INUSUALIDAD.codigo_producto_v%TYPE,
                                     procesarGrupos CRITERIOS_INUSUALIDAD.procesar_por_grupos%TYPE DEFAULT 0) IS

       CURSOR cur_criterios_producto IS
          SELECT *
            FROM CRITERIOS_INUSUALIDAD
	       WHERE (codigo_producto_v = codProducto OR codigo_producto_v = 0) --ADD OR CPB 03MAY2004
		     AND activo = 1
			 AND procesar_por_grupos = procesarGrupos;

       CURSOR cur_criterios IS
          SELECT *
            FROM CRITERIOS_INUSUALIDAD
		   WHERE activo = 1
			 AND procesar_por_grupos = procesarGrupos;

	   i NUMBER := 1;

   BEGIN
        IF procesarGrupos = 0 THEN
   		    arr_nombres_paquetes (0)  := 'Pk_Criterios_Comunes';
   		    arr_nombres_paquetes (1)  := 'Pk_Criterios_Cc';    --1	CC	CUENTA CORRIENTE
   		    arr_nombres_paquetes (2)  := 'Pk_Criterios_Ca';    --2	CA	CUENTA AHORRO
   		    arr_nombres_paquetes (3)  := 'Pk_Criterios_Cdt';   --3	CDT	CERTIFICADO DEPOSITO A TERMINO
   		    arr_nombres_paquetes (4)  := 'Pk_Criterios_Cda';   --4	CDA	CERTIFICADO AHORRO A TERMINO
   		    arr_nombres_paquetes (5)  := 'Pk_Criterios_Cd';    --5	CD	COMPRA DE DIVISAS
   		    arr_nombres_paquetes (6)  := 'Pk_Criterios_Vd';    --6	VD	VENTA DE DIVISAS
   		    arr_nombres_paquetes (7)  := 'Pk_Criterios_Tc';    --7	TC	TARJETA DE CREDITO
   		    --arr_nombres_paquetes (8)  := 'Pk_Criterios_';
   		    --arr_nombres_paquetes (9)  := 'Pk_Criterios_';
   		    --arr_nombres_paquetes (10) := 'Pk_Criterios_';
        ELSE
		    nombre_paquete_grupos := 'Pk_Aplicar_Criterios_Grupales';
        END IF;

        arr_criterios.DELETE;

		IF codProducto IS NULL THEN
		    FOR reg IN cur_criterios LOOP
                arr_criterios(i).sql_dinamico := f_get_sql_funcion_criterio(reg);
                i := i + 1;
			END LOOP;
		ELSE

 			FOR reg IN cur_criterios_producto LOOP
                arr_criterios(i).sql_dinamico := f_get_sql_funcion_criterio(reg);
                i := i + 1;
			END LOOP;
		END IF;
   END p_crear_sqls_dinamicos;


   /* Retorna la cadena SQL dinámica correspondiente al llamado a función de inusualidad del criterio
      especificado como parámetro.
   */
   FUNCTION f_get_sql_funcion_criterio (regCriterio CRITERIOS_INUSUALIDAD%ROWTYPE) RETURN VARCHAR2 IS

	   cadena_sql     VARCHAR2(500);
       /*TYPE tab_paquetes IS TABLE OF VARCHAR2(30)
         INDEX BY BINARY_INTEGER;
       nombres_paquetes tab_paquetes;*/

   BEGIN

       IF regCriterio.procesar_por_grupos = 0 THEN

/*   		nombres_paquetes (0)  := 'Pk_Criterios_Comunes';
		nombres_paquetes (1)  := 'Pk_Criterios_Cc';    --1	CC	CUENTA CORRIENTE
		nombres_paquetes (2)  := 'Pk_Criterios_Ca';    --2	CA	CUENTA AHORRO
		nombres_paquetes (3)  := 'Pk_Criterios_Cdt';   --3	CDT	CERTIFICADO DEPOSITO A TERMINO
		nombres_paquetes (4)  := 'Pk_Criterios_Cda';   --4	CDA	CERTIFICADO AHORRO A TERMINO
		nombres_paquetes (5)  := 'Pk_Criterios_Cd';    --5	CD	COMPRA DE DIVISAS
		nombres_paquetes (6)  := 'Pk_Criterios_Vd';    --6	VD	VENTA DE DIVISAS
		nombres_paquetes (7)  := 'Pk_Criterios_Tc';    --7	TC	TARJETA DE CREDITO
		--nombres_paquetes (8)  := 'Pk_Criterios_';
		--nombres_paquetes (9)  := 'Pk_Criterios_';
		--nombres_paquetes (10) := 'Pk_Criterios_';
*/
           cadena_sql := 'call '|| arr_nombres_paquetes(TO_NUMBER(regCriterio.codigo_producto_v)) || '.'
                               || regCriterio.funcion || '(' || regCriterio.id;
       ELSE
           cadena_sql := 'call '|| nombre_paquete_grupos || '.'
                               || regCriterio.funcion || '(' || regCriterio.id;
       END IF;

	   IF regCriterio.valor_p1 IS NOT NULL THEN
           cadena_sql := cadena_sql || ', ' || regCriterio.valor_p1;
	       IF regCriterio.valor_p2 IS NOT NULL THEN
               cadena_sql := cadena_sql || ', ' || regCriterio.valor_p2;
			   IF regCriterio.valor_p3 IS NOT NULL THEN
                   cadena_sql := cadena_sql || ', ' || regCriterio.valor_p3;
				   IF regCriterio.valor_p4 IS NOT NULL THEN
					   cadena_sql := cadena_sql || ', ' || regCriterio.valor_p4;
					   IF regCriterio.valor_p5 IS NOT NULL THEN
						   cadena_sql := cadena_sql || ', ' || regCriterio.valor_p5;
					   END IF;
					END IF;
				END IF;
			END IF;
	   END IF;

       IF regCriterio.procesar_por_grupos = 0 THEN
	       cadena_sql := cadena_sql || ') INTO :valor';
	   ELSE
	       cadena_sql := cadena_sql || ')';
       END IF;
--dbms_output.put_line(cadena_sql); --PRUEBAS
       RETURN cadena_sql;

   END f_get_sql_funcion_criterio;


   /* Ejecuta los llamados a las funciones para aplicación de criterios de
      inusualidad
   */
-- AJUSTE
--PROCEDURE p_evaluar_criterios_tr (tr IN OUT TRANSACCIONES_CLIENTE%ROWTYPE) IS
-- FIN AJUSTE
   PROCEDURE p_evaluar_criterios_tr (tr IN OUT TRANSACCIONES_CLIENTE%ROWTYPE, bitacora IN OUT utl_file.file_type) IS

	   total_criterios NUMBER := 0;
	   error           VARCHAR2(50);
	   codigo_error    NUMBER;

	   v_cursor        INTEGER;
	   v_dname         CHAR(20);
	   v_rows          INTEGER;
	   valor_retornado NUMBER;

	   i NUMBER := 1;
-- AJUSTE
y number;
-- FIN AJUSTE
   BEGIN
       g_transaccion := tr;
       p_cargar_detalle_tr (Pk_Llamar_Procesos_Batch.g_codigo_producto,
                            g_transaccion.codigo_archivo,
                            g_transaccion.fecha_proceso,
                            g_transaccion.id);
-- AJUSTE
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Aplicar criterios a tx: cod_archivo: ' || g_transaccion.codigo_archivo || ' - id - ' || g_transaccion.id,y);
-- FIN AJUSTE

		WHILE (i > 0) LOOP
		    BEGIN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                DBMS_SQL.PARSE(v_cursor, arr_criterios(i).sql_dinamico, DBMS_SQL.V7);
                DBMS_SQL.BIND_VARIABLE(v_cursor, ':valor', valor_retornado);
-- AJUSTE
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'cursor: ' || arr_criterios(i).sql_dinamico,y);
-- FIN AJUSTE
                v_rows := DBMS_SQL.EXECUTE(v_cursor);
                DBMS_SQL.VARIABLE_VALUE(v_cursor, ':valor', valor_retornado);

                total_criterios := total_criterios + valor_retornado;

                DBMS_SQL.CLOSE_CURSOR(v_cursor);
                i := i + 1;
			EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_SQL.CLOSE_CURSOR(v_cursor);
-- AJUSTE
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'exception NO_DATA_FOUND: - codigo ' || SQLCODE || ' - mensaje ' || SUBSTR(SQLERRM,1,200),y);
-- FIN AJUSTE
		   	        EXIT;
                WHEN OTHERS THEN
                    DBMS_SQL.CLOSE_CURSOR(v_cursor);
-- AJUSTE
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'exception OTHERS: - codigo ' || SQLCODE || ' - mensaje ' || SUBSTR(SQLERRM,1,200),y);
-- FIN AJUSTE
                    EXIT;
			END;

		END LOOP;

	   IF total_criterios > 0 THEN
	       tr.no_criterios := total_criterios;
	   END IF;

	   EXCEPTION WHEN OTHERS THEN
           ROLLBACK;
		   error := SUBSTR(SQLERRM,1,50);
		   codigo_error := SQLCODE;
           Pk_Lib.p_insertar_mensaje(codigo_error, error);
	       DBMS_SQL.CLOSE_CURSOR(v_cursor);
-- AJUSTE
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'exception OTHERS del procedimiento: - codigo ' || SQLCODE || ' - mensaje ' || SUBSTR(SQLERRM,1,200),y);
-- FIN AJUSTE
   END p_evaluar_criterios_tr;


   /* Carga la tabla global de detalle para la transacción cuya llave es especificada
      por los campos suministrados como parámetros.
   */
   PROCEDURE p_cargar_detalle_tr (codigoProducto ARCHIVOS.codigo_producto_v%TYPE,
	  		 			          codigoArchivo  TRANSACCIONES_CLIENTE.codigo_archivo%TYPE,
	  		 			          fechaProceso   TRANSACCIONES_CLIENTE.fecha_proceso%TYPE,
						          idTransaccion  TRANSACCIONES_CLIENTE.id%TYPE) IS

   BEGIN

   	  IF codigoProducto = '1' THEN
          SELECT *
            INTO g_transaccion_cc
            FROM DETALLE_TR_CC
           WHERE codigo_archivo = codigoArchivo
             AND fecha_proceso  = fechaProceso
             AND id_transaccion = idTransaccion;
	  ELSIF codigoProducto = '2' THEN
          SELECT *
            INTO g_transaccion_ca
            FROM DETALLE_TR_CA
           WHERE codigo_archivo = codigoArchivo
             AND fecha_proceso  = fechaProceso
             AND id_transaccion = idTransaccion;
	  ELSIF codigoProducto = '3' THEN
          SELECT *
            INTO g_transaccion_cdt
            FROM DETALLE_TR_CDT
           WHERE codigo_archivo = codigoArchivo
             AND fecha_proceso  = fechaProceso
             AND id_transaccion = idTransaccion;
	  END IF;
   END p_cargar_detalle_tr;

END;
/


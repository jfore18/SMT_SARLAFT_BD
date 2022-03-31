PROMPT CREATE OR REPLACE PACKAGE BODY pk_aplicar_criterios_grupales
CREATE OR REPLACE PACKAGE BODY pk_aplicar_criterios_grupales
IS

   /* Ejecuta las llamadas sql dinámicas que invocan a los procedimientos de
      aplicación de criterios de inusualidad grupales
   */
   PROCEDURE p_evaluar_criterios IS

	   error           VARCHAR2(50);
	   codigo_error    NUMBER;
	   v_cursor        INTEGER;
--	   v_dname         CHAR(20);
	   v_rows          INTEGER;
--	   valor_retornado NUMBER;

	   i NUMBER := 1;

   BEGIN

		WHILE (i > 0) LOOP
		    BEGIN
                v_cursor := DBMS_SQL.OPEN_CURSOR;
                DBMS_SQL.PARSE(v_cursor, Pk_Aplicar_Criterios_Inus.arr_criterios(i).sql_dinamico, DBMS_SQL.V7);
                --DBMS_SQL.BIND_VARIABLE(v_cursor, ':valor', valor_retornado);
                v_rows := DBMS_SQL.EXECUTE(v_cursor);
                --DBMS_SQL.VARIABLE_VALUE(v_cursor, ':valor', valor_retornado);
                --total_criterios := total_criterios + valor_retornado;

                DBMS_SQL.CLOSE_CURSOR(v_cursor);
                i := i + 1;
			EXCEPTION WHEN NO_DATA_FOUND THEN
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
		   	    EXIT;
			END;
		END LOOP;

	    EXCEPTION WHEN OTHERS THEN
            ROLLBACK;
		    error := SUBSTR(SQLERRM,1,50);
		    codigo_error := SQLCODE;
            Pk_Lib.p_insertar_mensaje(codigo_error, error);
	        DBMS_SQL.CLOSE_CURSOR(v_cursor);
   END p_evaluar_criterios;

   /* Proceso masivo que identifica los grupos de transacciones a analizarse por
      posible Pitufeo, y aplica la condición que establece si cada transacción
      cumple dicho criterio de inusualidad.
      Al final, actualiza el campo PROCESADA_PITUFEO (=1) de las transacciones
      que no se incluyeron en el análisis.
   */
   PROCEDURE p_pitufeo (idCriterio NUMBER, porcentajeDiferencia NUMBER, nMinTransacciones NUMBER, vrMaxTransaccion NUMBER) IS

       CURSOR cur_trs_pitufeo IS
           SELECT t.fecha_proceso, t.codigo_archivo, t.id, t.valor_transaccion,
                  grupo.numero_negocio, grupo.fecha
             FROM TRANSACCIONES_CLIENTE t,
                  (  SELECT  fecha, numero_negocio
                       FROM  TRANSACCIONES_CLIENTE
                      WHERE  codigo_archivo    = Pk_Llamar_Procesos_Batch.g_codigo_archivo
                        AND  procesada_pitufeo = 0
                        AND  valor_transaccion < vrMaxTransaccion
                   GROUP BY  fecha, numero_negocio
                     HAVING  COUNT(*)  >=  nMinTransacciones
                  ) grupo
            WHERE  t.fecha             = grupo.fecha
              AND  t.numero_negocio    = grupo.numero_negocio
              AND  t.valor_transaccion < vrMaxTransaccion
         ORDER BY  grupo.fecha, grupo.numero_negocio, valor_transaccion;

	   tr_aux        reg_tr_pitufeo;
	   n_regs_commit NUMBER := 1;

   BEGIN

       FOR reg_tr IN cur_trs_pitufeo LOOP
           IF reg_tr.numero_negocio = tr_aux.numero_negocio THEN  --Sobra comparar por fecha de la transaccion
               IF ((reg_tr.valor_transaccion - tr_aux.valor_tr)/tr_aux.valor_tr)*100 <= porcentajeDiferencia
               THEN
				   p_grabar_criterio_pitufeo ( tr_aux.codigo_archivo,
				    						   tr_aux.fecha_proceso,
											   tr_aux.id_transaccion,
											   idCriterio );
                   tr_aux.codigo_archivo  :=  reg_tr.codigo_archivo;
                   tr_aux.fecha_proceso   :=  reg_tr.fecha_proceso;
                   tr_aux.id_transaccion  :=  reg_tr.id;
                   tr_aux.valor_tr        :=  reg_tr.valor_transaccion;
                   tr_aux.numero_negocio  :=  reg_tr.numero_negocio;
				   p_grabar_criterio_pitufeo ( tr_aux.codigo_archivo,
				    						   tr_aux.fecha_proceso,
											   tr_aux.id_transaccion,
											   idCriterio );
                   n_regs_commit := n_regs_commit + 1;
               ELSE
                   UPDATE TRANSACCIONES_CLIENTE
                      SET procesada_pitufeo = 1
                    WHERE codigo_Archivo    = tr_aux.codigo_archivo
                      AND fecha_proceso     = tr_aux.fecha_proceso
                      AND id                = tr_aux.id_transaccion;
               END IF;
           ELSE
               IF n_regs_commit != 1 THEN
                   COMMIT;
				   n_regs_commit := 1;
               END IF;
		   END IF;
           --cuando se graba tr_aux para pitufeo, este código es redundante
           tr_aux.codigo_archivo := reg_tr.codigo_archivo;
           tr_aux.fecha_proceso  := reg_tr.fecha_proceso;
           tr_aux.id_transaccion := reg_tr.id;
           tr_aux.valor_tr       := reg_tr.valor_transaccion;
           tr_aux.numero_negocio := reg_tr.numero_negocio;
       END LOOP;
       COMMIT;

       --Actualización de las transacciones que no fueron incluidas en el análisis
       UPDATE TRANSACCIONES_CLIENTE
          SET procesada_pitufeo = 1
        WHERE codigo_Archivo    = Pk_Llamar_Procesos_Batch.g_codigo_archivo
          AND procesada_pitufeo = 0;

       COMMIT;

   END p_pitufeo;


   /* Actualiza las tablas CRITERIOS_TRANSACCION y TRANSACCIONES_CLIENTE para la
      transacción que se ha identificado como parte de un grupo de Pitufeo.
      El procedimiento la invoca a p_grabar_pitufeo es responsable del COMMIT.
   */
   PROCEDURE p_grabar_criterio_pitufeo (p_codigo_archivo   CRITERIOS_TRANSACCION.codigo_archivo%TYPE,
   			 					        p_fecha_proceso    CRITERIOS_TRANSACCION.fecha_proceso%TYPE,
								        p_id_transaccion   CRITERIOS_TRANSACCION.id_transaccion%TYPE,
		                  		        p_id_criterio      CRITERIOS_TRANSACCION.id_criterio_inusualidad%TYPE) IS

	  id_tr    TRANSACCIONES_CLIENTE.id%TYPE := 0;
   BEGIN

       SELECT id
         INTO id_Tr
         FROM TRANSACCIONES_CLIENTE
        WHERE codigo_Archivo    =  p_codigo_archivo
          AND fecha_proceso     =  p_fecha_proceso
          AND id                =  p_id_transaccion
          AND procesada_pitufeo =  0; --Evita que la transacción sea actualizada
                                      --por pitufeo más de una vez

       INSERT INTO CRITERIOS_TRANSACCION
                 (codigo_archivo,
                  fecha_proceso,
                  id_transaccion,
                  id_criterio_inusualidad,
                  usuario_creacion,
                  fecha_creacion)
              VALUES
			     (p_codigo_archivo,
                  p_fecha_proceso,
                  p_id_transaccion,
                  p_id_criterio,
                  Pk_Llamar_Procesos_Batch.g_cedula_usuario,
                  SYSDATE);

       UPDATE TRANSACCIONES_CLIENTE
          SET no_criterios      =  no_criterios + 1,
              procesada_pitufeo =  1,
              mayor_riesgo      =  1
        WHERE codigo_Archivo    =  p_codigo_archivo
          AND fecha_proceso     =  p_fecha_proceso
          AND id                =  p_id_transaccion;

   EXCEPTION WHEN NO_DATA_FOUND THEN
       RETURN;
   END p_grabar_criterio_pitufeo;
END;
/


PROMPT CREATE OR REPLACE PACKAGE BODY pk_aplicar_filtros
CREATE OR REPLACE PACKAGE BODY pk_aplicar_filtros
IS

   /* Realiza las actualizaciones de tablas pertinentes si la transacción cumple el
      filtro especificado dentro de los parámetros.
   */
   PROCEDURE p_evaluar_filtro_tr (codigoArchivo    TRANSACCIONES_CLIENTE.codigo_archivo%TYPE,
                                  fechaProceso     TRANSACCIONES_CLIENTE.fecha_proceso%TYPE,
                                  idTransaccion    TRANSACCIONES_CLIENTE.id%TYPE,
                                  valorTransaccion TRANSACCIONES_CLIENTE.valor_transaccion%TYPE,
                                  idFiltro         FILTROS.id%TYPE,
                                  codigoCargo      FILTROS.codigo_cargo%TYPE) IS

	   perfil_cargo  CARGOS.codigo_perfil_v%TYPE;

	BEGIN

       IF f_cumple_filtro (idFiltro, valorTransaccion) THEN

           perfil_cargo := Pk_Lib.f_get_perfil_cargo(codigoCargo);

           IF perfil_cargo = '2' THEN --Gerente de Oficina

               UPDATE TRANSACCIONES_CLIENTE
                  SET filtro_oficina = 1,
                      estado_oficina = 'N',
                      procesada_filtros = 1
                WHERE codigo_archivo = codigoArchivo
                  AND fecha_proceso = fechaProceso
                  AND id = idTransaccion;

		   ELSIF perfil_cargo = '5' THEN --Analista DUCC

               UPDATE TRANSACCIONES_CLIENTE
                  SET filtro_ducc = 1,
                      estado_ducc = 'N',
                      procesada_filtros = 1
                WHERE codigo_archivo = codigoArchivo
                  AND fecha_proceso = fechaProceso
                  AND id = idTransaccion;

		   ELSE
		       RETURN;
           END IF;

		   INSERT INTO HISTORICO_ESTADOS_TR (id	,  usuario_actualizacion,
                             codigo_archivo,  fecha_proceso,  id_transaccion,
                             codigo_estado_v, fecha_actualizacion,  codigo_cargo)
                     VALUES (seq_historico_estado.NEXTVAL, Pk_Llamar_Procesos_Batch.g_cedula_usuario,
                             codigoArchivo,  fechaProceso, idTransaccion,
                             'N', TRUNC(SYSDATE), codigoCargo);
       END IF;

	END p_evaluar_filtro_tr;


	/* Verifica si el valor pasado como parámetro cumple o no con la condición
	   definida en el filtro con el ID especificado.
	*/
    FUNCTION f_cumple_filtro (idFiltro FILTROS.id%TYPE,
                              valor    TRANSACCIONES_CLIENTE.valor_transaccion%TYPE) RETURN BOOLEAN IS
	   condicion_filtro  FILTROS.condicion%TYPE;
       operador          VARCHAR2(1);
       posicion          NUMBER;
       parametro1        NUMBER;
       parametro2        NUMBER;
	   cumpleFiltro      BOOLEAN := FALSE;

   BEGIN
	   SELECT condicion
	   INTO condicion_filtro
	   FROM FILTROS
	   WHERE id = idFiltro;

       operador := SUBSTR(condicion_filtro,1,1);

	   IF operador = '#' THEN
           posicion   := INSTR(condicion_filtro,',');
           parametro1 := TO_NUMBER(SUBSTR(condicion_filtro, 2, posicion-2));
           parametro2 := TO_NUMBER(SUBSTR(condicion_filtro, posicion+1));
           /*cadena_sql := 'BETWEEN '
                         || SUBSTR(condicion_filtro, 2, posicion-2)
                         || ' AND '
                         || SUBSTR(condicion_filtro, posicion+1);*/
           IF valor BETWEEN parametro1 AND parametro2 THEN
               cumpleFiltro := TRUE;
           END IF;

       ELSIF operador = '>' THEN
           parametro1 := TO_NUMBER(SUBSTR(condicion_filtro, 2));
           IF valor > parametro1 THEN
               cumpleFiltro := TRUE;
           END IF;

       ELSIF operador = '<' THEN
           parametro1 := TO_NUMBER(SUBSTR(condicion_filtro, 2));
           IF valor < parametro1 THEN
               cumpleFiltro := TRUE;
           END IF;

	   END IF;

       RETURN cumpleFiltro;
   END f_cumple_filtro;

END;
/


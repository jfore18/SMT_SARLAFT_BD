PROMPT CREATE OR REPLACE PACKAGE BODY pk_criterios_comunes
CREATE OR REPLACE PACKAGE BODY pk_criterios_comunes
IS
   /* Verifica si el código de la actividad económica del cliente está
      identificada como crítica dentro de la tabla de actividades económicas.
   */
   FUNCTION f_actividad_econ_critica (idCriterio NUMBER) RETURN NUMBER IS
      codActividad ACTIVIDAD_ECONOMICA.codigo%TYPE;
   BEGIN
/*      SELECT codigo
        INTO codActividad
        FROM ACTIVIDAD_ECONOMICA
       WHERE codigo = Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_actividad_economica
         AND alto_riesgo = 1; REM INGRID M. ALONSO M. SE DEBE CRUZAR CONTRA ACTIVIDAD ECONOMICA CRM: */
      SELECT A.codigo
        INTO codActividad
        FROM ACTIVIDAD_ECONOMICA A,
		CLIENTES C
       WHERE C.TIPO_IDENTIFICACION = Pk_Aplicar_Criterios_Inus.g_transaccion.TIPO_IDENTIFICACION
	     AND C.NUMERO_IDENTIFICACION = Pk_Aplicar_Criterios_Inus.g_transaccion.NUMERO_IDENTIFICACION
	     AND A.codigo = C.CODIGO_ACTIVIDAD_ECONOMICA
         AND A.alto_riesgo = 1;

  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
	 		  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
			  Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		   	  idCriterio,
		  	  NULL);
	  RETURN 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
	      RETURN 0;
   END f_actividad_econ_critica;
   /* Verifica si el cliente fue marcado como negativo durante la
      actualización batch de datos demográgicos.
   */
   FUNCTION f_cliente_negativo (idCriterio NUMBER) RETURN NUMBER IS
   	   es_negativo CLIENTES.negativo%TYPE := 0;
   BEGIN
      BEGIN
          SELECT negativo
            INTO es_negativo
            FROM CLIENTES
           WHERE tipo_identificacion = Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion
             AND numero_identificacion = Pk_Aplicar_Criterios_Inus.g_transaccion.numero_identificacion;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
	          RETURN 0;
          WHEN OTHERS THEN
	          RETURN 0;
      END;
      IF es_negativo IS NULL THEN
          es_negativo := 0;
      ELSIF es_negativo = 1 THEN
          Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
              Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
              Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
              Pk_Aplicar_Criterios_Inus.g_transaccion.id,
              idCriterio,
              NULL);
      END IF;
	  RETURN es_negativo;
   END f_cliente_negativo;
   /* Verifica si el cliente fue marcado como PEPs durante la
      actualización batch de datos demográgicos.
   */
   FUNCTION f_cliente_PEPs (idCriterio NUMBER) RETURN NUMBER IS
   	   es_PEPs CLIENTES.peps%TYPE := 0;
   BEGIN
      BEGIN
          SELECT peps
            INTO es_PEPs
            FROM CLIENTES
            WHERE tipo_identificacion = Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion
              AND numero_identificacion = Pk_Aplicar_Criterios_Inus.g_transaccion.numero_identificacion;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
	          RETURN 0;
          WHEN OTHERS THEN
	          RETURN 0;
      END;
      IF es_PEPs IS NULL THEN
          es_PEPs := 0;
      ELSIF es_PEPs = 1 THEN
          Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
              Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
              Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
              Pk_Aplicar_Criterios_Inus.g_transaccion.id,
              idCriterio,
              NULL);
      END IF;
	  RETURN es_PEPs;
   END f_cliente_PEPs;
   /* Verifica si el tipo y número de identificación del cliente
      coincide alguno de los incluidos en las listas de cruce de la UCC.
   */
   FUNCTION f_id_en_listas (idCriterio NUMBER) RETURN NUMBER IS
       CURSOR cur_listas (--p_tipoId PERSONAS_REPORTADAS.tipo_identificacion%TYPE,
	                      p_nId    PERSONAS_REPORTADAS.numero_identificacion%TYPE) IS
          SELECT *
            FROM PERSONAS_REPORTADAS
	       WHERE tipo_identificacion  != 'S' --S indica que el número de identificación es una secuencia
		     --AND tipo_identificacion   = p_tipoId
		     AND numero_identificacion = p_nId;
	   total_listas NUMBER := 0;
   BEGIN
	   FOR reg_listas IN cur_listas(--Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion,
                                    Pk_Aplicar_Criterios_Inus.g_transaccion.numero_identificacion)
	   LOOP
	  	   Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
		   					  Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
 			 				  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
							  Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  	  idCriterio,
						  	  reg_listas.codigo_motivo_v);
		   total_listas := total_listas + 1;
	   END LOOP;
       RETURN total_listas;
   END f_id_en_listas;
   /* Verifica si la longitud del número de identificación es menor
      a cierto número de dígitos. Esto da una aproximación de que el
	  cliente es de edad avanzada.
   */
   FUNCTION f_longitud_id (idCriterio NUMBER, nDigitosId NUMBER, tipoId VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion = tipoId
	      AND LENGTH(Pk_Aplicar_Criterios_Inus.g_transaccion.numero_identificacion) < nDigitosId THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;
   END f_longitud_id;
   /* Compara el tipo y número de identificación del cliente
      contra el nit del Banco de Bogotá.
   */
   FUNCTION f_nit_bbogota (idCriterio NUMBER) RETURN NUMBER IS
       --nitBancoBogotaDV  CONSTANT  VARCHAR2(10) :='8600029644'; -- NIT '860002964-4'
       nitBancoBogota    CONSTANT  VARCHAR2(10) := '860002964%';
   BEGIN
       IF (Pk_Aplicar_Criterios_Inus.g_transaccion.numero_identificacion LIKE nitBancoBogota)
	   THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;
   END f_nit_bbogota;
   /* Verifica si el nombre del cliente suministrado por la aplicación
      coincide con algún nombre de las listas de cruce de la UCC.
   */
   FUNCTION f_nombre_en_listas (idCriterio NUMBER) RETURN NUMBER IS
       /*CURSOR cur_listas (p_nombre varchar2) IS
          SELECT *
            FROM personas_reportadas
	       WHERE apellidos_razon_social || ' ' || nombres_razon_comercial like '%' || p_nombre || '%';*/
	   total_listas NUMBER := 0;
   BEGIN
	   /*FOR reg_listas in cur_listas(Pk_Aplicar_Criterios_Inus.g_transaccion.nombre_cliente)
	   LOOP
	  	   pk_APLICAR_CRITERIOS_INUS.p_grabar_criterio_tr (
		   					  Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
 			 				  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
							  Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  	  idCriterio,
						  	  reg_listas.codigo_motivo_v);
		   total_listas := total_listas + 1;
	   END LOOP;*/
       RETURN total_listas;
   END f_nombre_en_listas;

   FUNCTION f_tr_mayor_valor_mil_mill (idCriterio NUMBER, valor NUMBER) RETURN NUMBER IS
   BEGIN

       IF  (Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >= valor) THEN
           Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 	       Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		             idCriterio, NULL);

		       RETURN 1;
	     END IF;
       RETURN 0;
   END f_tr_mayor_valor_mil_mill;

   FUNCTION f_tr_clementine(idCriterio NUMBER, nivelC VARCHAR2, nivelT VARCHAR2, nivelI VARCHAR2) RETURN NUMBER IS
    nivelCriticidad DETALLE_TR_CLE.nivel_criticidad%TYPE;
   BEGIN

    BEGIN
      SELECT nivel_criticidad
      INTO nivelCriticidad
      FROM detalle_tr_cle
      WHERE TO_NUMBER(numero_cuenta)  = TO_NUMBER(Pk_Aplicar_Criterios_Inus.g_transaccion.numero_negocio)
      AND fecha_proceso               = Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso
      AND codigo_transaccion          = Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 0;
      WHEN OTHERS THEN
        RETURN 0;
    END;

    IF (nivelCriticidad = nivelC) OR (nivelCriticidad = nivelT) OR (nivelCriticidad = nivelI) THEN
      Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo
                                                      , Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso
                                                      , Pk_Aplicar_Criterios_Inus.g_transaccion.id
                                                      , idCriterio
                                                      , NULL);
      RETURN 1;
    END IF;
    RETURN 0;

   END f_tr_clementine;
END;
/


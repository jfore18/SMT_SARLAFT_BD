PROMPT CREATE OR REPLACE PACKAGE BODY pk_criterios_ca
CREATE OR REPLACE PACKAGE BODY pk_criterios_ca
IS

   FUNCTION f_canje_errado (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2) RETURN NUMBER IS
   BEGIN

       IF     Pk_Aplicar_Criterios_Inus.g_transaccion_ca.valor_canje  = valor
	      AND Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion = codigoTr THEN

		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;

	   RETURN 0;

   END f_canje_errado;


   FUNCTION f_cuenta_cheques_gerencia (idCriterio NUMBER) RETURN NUMBER IS

       cta_generica_cheques VARCHAR2(9) := '___77777_';

   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.numero_negocio LIKE cta_generica_cheques
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
   END f_cuenta_cheques_gerencia;


   FUNCTION f_cuenta_generica (idCriterio NUMBER) RETURN NUMBER IS
       cta_generica_1 VARCHAR2(9) := '___66666_';
       cta_generica_2 VARCHAR2(9) := '___88888_';

   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.numero_negocio LIKE cta_generica_1 OR
              Pk_Aplicar_Criterios_Inus.g_transaccion.numero_negocio LIKE cta_generica_2
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
   END f_cuenta_generica;


   FUNCTION f_cuenta_no_activa (idCriterio NUMBER) RETURN NUMBER IS
       cod_cuenta_activa VARCHAR2(2) := '00';
   BEGIN
       IF  Pk_Aplicar_Criterios_Inus.g_transaccion_ca.estado_cuenta != cod_cuenta_activa THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;
   END f_cuenta_no_activa;


   FUNCTION f_cuenta_reciente (idCriterio NUMBER, nDiasPostApertura NUMBER) RETURN NUMBER IS
       dias_diferencia NUMBER;
   BEGIN
       dias_diferencia := Pk_Aplicar_Criterios_Inus.g_transaccion.fecha -
           Pk_Aplicar_Criterios_Inus.g_transaccion_ca.fecha_apertura;
       IF dias_diferencia <= nDiasPostApertura AND dias_diferencia > 0
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
   END f_cuenta_reciente;


   FUNCTION f_cuenta_sobregiro (idCriterio NUMBER) RETURN NUMBER IS
       signo_sobregiro VARCHAR2(1) := '-';
   BEGIN

       IF  Pk_Aplicar_Criterios_Inus.g_transaccion_ca.signo_sobregiro = signo_sobregiro THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;
   END f_cuenta_sobregiro;


   FUNCTION f_deposito_elec_credibanco (idCriterio NUMBER, codigoTr VARCHAR2, tipoId VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion = codigoTr
	      AND Pk_Lib.f_valor_en_lista_multiple (
		                 Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion, tipoId)
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
   END f_deposito_elec_credibanco;


   FUNCTION f_longitud_cuenta  (idCriterio NUMBER, nDigitosCuenta NUMBER) RETURN NUMBER IS
   BEGIN
       IF LENGTH(Pk_Aplicar_Criterios_Inus.g_transaccion.numero_negocio) != nDigitosCuenta
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
   END f_longitud_cuenta;


   FUNCTION f_mayorValor_codTr (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF   Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >= valor
	    AND Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion = codigoTr
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
   END f_mayorValor_codTr;


   FUNCTION f_mayorValor_codTr_tipoID (idCriterio NUMBER, valor NUMBER, codigoTr VARCHAR2, tipoId VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF   Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >= valor
	    AND Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion = codigoTr
		AND Pk_Lib.f_valor_en_lista_multiple (
		               Pk_Aplicar_Criterios_Inus.g_transaccion.tipo_identificacion, tipoId)
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
   END f_mayorValor_codTr_tipoID;


   FUNCTION f_pitufeo (idCriterio NUMBER, porcentaje NUMBER) RETURN NUMBER IS
   BEGIN
       RETURN 0;
   END f_pitufeo;


   FUNCTION f_plazas_no_logicas (idCriterio NUMBER) RETURN NUMBER IS

      codPlaza  RELACIONES_NO_LOGICAS.codigo_plaza_1%TYPE;
      codPlaza1 RELACIONES_NO_LOGICAS.codigo_plaza_1%TYPE
                      := Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_oficina;
      codPlaza2 RELACIONES_NO_LOGICAS.codigo_plaza_2%TYPE
                      := Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_oficina_origen;

   BEGIN
       SELECT codigo_plaza_1
         INTO codPlaza
         FROM RELACIONES_NO_LOGICAS
        WHERE (codigo_plaza_1 = codPlaza1 AND codigo_plaza_2 = codPlaza2) OR
              (codigo_plaza_1 = codPlaza2 AND codigo_plaza_2 = codPlaza1);

       Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
		  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   		 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
							 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
	                  		 idCriterio,
					  		 NULL);
	   RETURN 1;

       EXCEPTION WHEN NO_DATA_FOUND THEN
           RETURN 0;
   END f_plazas_no_logicas;


   FUNCTION f_plaza_critica (idCriterio NUMBER) RETURN NUMBER IS

       codigo_plaza_critica UNIDADES_NEGOCIO.codigo%TYPE;
   BEGIN

       SELECT codigo
         INTO codigo_plaza_critica
         FROM UNIDADES_NEGOCIO
        WHERE codigo = Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_oficina_origen
          AND plaza_critica = 1;

       IF Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_oficina_origen
          <> Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_oficina THEN

              Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
                             Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
                             Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
                             Pk_Aplicar_Criterios_Inus.g_transaccion.id,
                             idCriterio,
                             NULL);
           RETURN 1;
       END IF;
       RETURN 0;

       EXCEPTION WHEN NO_DATA_FOUND THEN
           RETURN 0;

   END f_plaza_critica;


   FUNCTION f_promedio_negativo (idCriterio NUMBER) RETURN NUMBER IS
       signo_promedio VARCHAR2(1) := '-';
   BEGIN
       IF  Pk_Aplicar_Criterios_Inus.g_transaccion_ca.signo_promedio = signo_promedio THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;
   END f_promedio_negativo;


   FUNCTION f_tr_anterior_a_apertura (idCriterio NUMBER) RETURN NUMBER IS
   BEGIN

       IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha <
           Pk_Aplicar_Criterios_Inus.g_transaccion_ca.fecha_apertura  THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;

   END f_tr_anterior_a_apertura;


   FUNCTION f_tr_antigua_proceso (idCriterio NUMBER, nDiasPostProceso NUMBER) RETURN NUMBER IS
   BEGIN

       IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso -
           Pk_Aplicar_Criterios_Inus.g_transaccion.fecha > nDiasPostProceso THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
       RETURN 0;

   END f_tr_antigua_proceso;


   FUNCTION f_tr_en_fecha_apertura (idCriterio NUMBER) RETURN NUMBER IS
   BEGIN
       IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha =
           Pk_Aplicar_Criterios_Inus.g_transaccion_ca.fecha_apertura  THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;
	   RETURN 0;

   END f_tr_en_fecha_apertura;


   FUNCTION f_tr_supera_promedio (idCriterio NUMBER, nVecesPromedio NUMBER) RETURN NUMBER IS
   BEGIN

       IF (Pk_Aplicar_Criterios_Inus.g_transaccion_ca.promedio_semestral > 0) --ADD CPB 10JUN2004
           AND (Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >
                (nVecesPromedio * Pk_Aplicar_Criterios_Inus.g_transaccion_ca.promedio_semestral))
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
   END f_tr_supera_promedio;


   FUNCTION f_tr_supera_saldo (idCriterio NUMBER, nVecesSaldo NUMBER) RETURN NUMBER IS
   BEGIN

       IF (Pk_Aplicar_Criterios_Inus.g_transaccion_ca.saldo > 0) --ADD CPB 10JUN2004
           AND (Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >
                (nVecesSaldo * Pk_Aplicar_Criterios_Inus.g_transaccion_ca.saldo))
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
   END f_tr_supera_saldo;

   --ADD CPB 23JUN2004
   FUNCTION f_transfer_supera_promedio (idCriterio NUMBER, nVecesPromedio NUMBER, codigoTr VARCHAR2) RETURN NUMBER IS
   BEGIN

       IF (Pk_Aplicar_Criterios_Inus.g_transaccion_ca.promedio_semestral > 0) --ADD CPB 23JUN2004
           AND (Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion >
                 (nVecesPromedio * Pk_Aplicar_Criterios_Inus.g_transaccion_ca.promedio_semestral)
		       AND Pk_Lib.f_valor_en_lista_multiple
                          (Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion, codigoTr)
          )
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
   END f_transfer_supera_promedio;

END;
/


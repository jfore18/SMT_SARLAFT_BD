PROMPT CREATE OR REPLACE PACKAGE BODY pk_criterios_cdt
CREATE OR REPLACE PACKAGE BODY pk_criterios_cdt
IS

   FUNCTION f_cancelacion_titulo (idCriterio NUMBER, codigoTr VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_transaccion = codigoTr
--	      AND Pk_Aplicar_Criterios_Inus.g_transaccion.fecha < Pk_Aplicar_Criterios_Inus.g_transaccion_cdt.fecha_vencimiento
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
   END;


   FUNCTION f_menor_edad (idCriterio NUMBER, valor NUMBER, tipoId VARCHAR2) RETURN NUMBER IS

   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion > valor
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
   END;


   FUNCTION f_plazo_corto (idCriterio NUMBER, valor NUMBER, nDiasPlazo VARCHAR2) RETURN NUMBER IS
   BEGIN
       IF     Pk_Aplicar_Criterios_Inus.g_transaccion.valor_transaccion > valor
	      AND Pk_Aplicar_Criterios_Inus.g_transaccion_cdt.plazo < nDiasPlazo
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
   END;


   FUNCTION f_titulo_reciente (idCriterio NUMBER, nDiasPostApertura NUMBER) RETURN NUMBER IS
   BEGIN
       /*IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha -
           Pk_Aplicar_Criterios_Inus.g_transaccion_cdt.fecha_apertura <= nDiasPostApertura THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;*/
	   RETURN 0;
   END;


   FUNCTION f_tr_anterior_a_apertura (idCriterio NUMBER) RETURN NUMBER IS
   BEGIN
       /*IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha <
           Pk_Aplicar_Criterios_Inus.g_transaccion_cdt.fecha_apertura  THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;*/
	   RETURN 0;
   END;


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

   END;


   FUNCTION f_tr_en_fecha_apertura (idCriterio NUMBER) RETURN NUMBER IS
   BEGIN
       /*IF  Pk_Aplicar_Criterios_Inus.g_transaccion.fecha =
           Pk_Aplicar_Criterios_Inus.g_transaccion_cdt.fecha_apertura  THEN
		  	  Pk_Aplicar_Criterios_Inus.p_grabar_criterio_tr (
			  				     Pk_Aplicar_Criterios_Inus.g_transaccion.codigo_archivo,
   			 					 Pk_Aplicar_Criterios_Inus.g_transaccion.fecha_proceso,
								 Pk_Aplicar_Criterios_Inus.g_transaccion.id,
		                  		 idCriterio,
						  		 NULL);
		      RETURN 1;
	   END IF;*/
	   RETURN 0;
   END;

END;
/


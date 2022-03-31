PROMPT CREATE OR REPLACE PACKAGE BODY pk_cargue_entidades
CREATE OR REPLACE PACKAGE BODY pk_cargue_entidades IS

/******************************************************************************************
                                        P_CARGAR
     Lee del directorio de entradas de la base de datos, el archivo con las entidades a cargar
	 para que las transacciones que lleguen al sistema de estas personas no sean cargadas
     Los nombres del directorio de entradas y del archivo se leen de la vista V_RUTAS_BD.
     Parametros:
           - tipoEntidad : refiere el tipo de entidades a cargas: Superbancaria, oficiales...
		   	 hace match con la vista V_ENTIDADES (TIPO_DATO = 24)
           - cedulaUsuario : persona que ejecuta el cargue
******************************************************************************************/


    PROCEDURE p_cargar          (tipoEntidad           IN VARCHAR2,
                                 cedulaUsuario         IN  USUARIO.cedula%TYPE,
                                 mensajeRetorno        OUT VARCHAR2) IS

        idProceso           LOG_PROCESOS.id_proceso%TYPE := NULL;

        dir_entradas        V_RUTAS_BD.descripcion%TYPE := 'IDL'; --INPUT DIRECTORY LIST
        archivo_entrada     V_RUTAS_BD.descripcion%TYPE := 'IEE';  -- INPUT ENTIDAD EXCLUIDA
        descriptorArchivo   UTL_FILE.File_Type;
        codigoMensaje       NUMBER;
        registro            VARCHAR2(1000);
        finArchivo          BOOLEAN;
        nRegistros          NUMBER := 0;
        contCommit          NUMBER := 0;
        error               LOG_ERRORES.error%TYPE;

        --CONTADORES PARA MOSTRAR AL FINAL DEL PROCESO
        nroEntidadesYaExisten  NUMBER := 0;
        nroEntidadesInsertadas NUMBER := 0;
    BEGIN

    /* GUARDAR EL INICIO O ARRANQUE DEL PROCESO */
        Pk_Lib.p_actualizar_log_procesos (idProceso, '9', NULL, cedulaUsuario, NULL);

    /* ABRIR EL ARCHIVO A CARGAR */
        IF dir_entradas IS NOT NULL AND archivo_entrada IS NOT NULL THEN

            Pk_Lib.f_get_dir_archivo_BD (dir_entradas, archivo_entrada);

            Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_entradas,
                                                      archivo_entrada,
                                                      'r',
                                                      descriptorArchivo,
                                                      codigoMensaje);
            /* LEER LINEA A LINEA EL ARCHIVO */
            LOOP
                Sipcla_Operacion_Archivos.PR_LEER_LINEA(descriptorArchivo,
                                                       registro,
                                                       finArchivo,
                                                       codigoMensaje);
                IF codigoMensaje <> 0 THEN
                    mensajeRetorno := 'Verifique que el archivo ' || archivo_entrada || ' se encuentra en la ruta: ' || dir_entradas;
                    RETURN;
                END IF;

                IF finArchivo THEN
                    EXIT;
                END IF;

                IF registro IS NULL OR LTRIM(registro) IS NULL THEN
                    codigoMensaje:= 483;
                    RETURN;
                END IF;

                BEGIN
                    p_insertar_entidad (registro,
                                        idProceso,
                                        tipoEntidad,
                                        nroEntidadesYaExisten,
                                        nroEntidadesInsertadas,
                                        cedulaUsuario);

                    contCommit := contCommit + 1;

                    nRegistros := nRegistros + 1;

                    IF contCommit > 50 THEN
                        contCommit := 0;
                        COMMIT;
                    END IF;

                EXCEPTION
                    WHEN OTHERS THEN
                        error := SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros || ': '|| SUBSTR(registro,1,120);
                        INSERT INTO LOG_ERRORES (id_proceso,
                                                fecha,
                                                error,
                                                USUARIO
                                                ) VALUES (
                                                idProceso,
                                                SYSDATE,
                                                error,
                                                cedulaUsuario);
                        COMMIT;
                END;
            END LOOP;

            COMMIT;

    /* CERRAR ARCHIVO CARGADO */
            Sipcla_Operacion_Archivos.PR_CERRAR_ARCHIVO(descriptorArchivo,
                                                        codigoMensaje);
        END IF;
        mensajeRetorno := 'Registros leidos: ' || nRegistros || '<br>Registros Insertados: ' || nroEntidadesInsertadas ||
                          '<br>Registros que ya existían: ' || nroEntidadesYaExisten;
    /* ACTUALIZAR HISTORICO CON DURACION Y ESTADISTICAS */
        Pk_Lib.p_actualizar_log_procesos(idProceso, '8', nRegistros, cedulaUsuario, codigoMensaje);

    END p_cargar;


/******************************************************************************************
                                  P_CARGAR_LISTAS

      INSERTA EN LA TABLA PERSONAS_REPORTADAS, VALIDANDO:
      - TIPO IDENTIFICACION (QUEMADO EN CÓDIGO) 'C','T','L','R','N'.
      - SI TIPO IDENTIFICACION O NUMERO DE IDENTIFICACION VIENEN EN BLANCO, PONE TI = 'S' Y NI EL CONSECUTIVO + 1
        DE TODAS LAS PERSONAS REPORTADAS CUYO TIPO DE IDENTIFICACION ES 'S'.
      - SI EL TIPO DE LISTA ES REPORTADOS QUE EL TIPO DE REPORTE EXISTA EN SIPCLA (TABLA LISTA_VALORES CAMPO TIPO_DATO=4)
        Y QUE EL NUMERO DE ROS NO EXISTA EN SIPCLA.
******************************************************************************************/

    PROCEDURE p_insertar_entidad (regEntidad             IN VARCHAR2,
                                  idProceso              IN LOG_PROCESOS.id_proceso%TYPE,
                                  tipoEntidad            IN VARCHAR2,
                                  nroEntidadesYaExisten  IN OUT NUMBER,
                                  nroEntidadesInsertadas IN OUT NUMBER,
                                  cedulaUsuario          IN  USUARIO.cedula%TYPE) IS

        tipoId              ENTIDADES_EXCLUIDAS.TIPO_IDENTIFICACION%TYPE;
        numeroId            ENTIDADES_EXCLUIDAS.NUMERO_IDENTIFICACION%TYPE;
		tTipoEntidad        VARCHAR2(2);
        flags               ENTIDADES_EXCLUIDAS.FLAGS_TIPOS%TYPE := '00000000';
        flagsIniciales      ENTIDADES_EXCLUIDAS.FLAGS_TIPOS%TYPE := '00000000';
        obligarCarga        ENTIDADES_EXCLUIDAS.OBLIGAR_CARGA%TYPE := '0';
        nombreEntidad       ENTIDADES_EXCLUIDAS.NOMBRE%TYPE;
        fechaActualizacion  ENTIDADES_EXCLUIDAS.FECHA_ACTUALIZACION%TYPE;
		sFechaActualizacion VARCHAR2(8);

        mensajeError        LOG_ERRORES.error%TYPE;

    BEGIN
        tipoId              := TRIM(SUBSTR(regEntidad,1,1));
        numeroId            := TRIM(SUBSTR(regEntidad,2,11));
        nombreEntidad       := TRIM(SUBSTR(regEntidad,13,40));
        sFechaActualizacion := SUBSTR(regEntidad,53,8);

        BEGIN
            IF tipoId IS NULL OR numeroId IS NULL OR tipoId = '' OR numeroId = '' THEN

                mensajeError := 'Error al verificar el registro. TI: '||tipoId||'  NI: '||numeroId||' TI O NI NULOS';
                INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                COMMIT;
                RETURN;

            /* VALIDAR TIPO DE IDENTIFICACION */
            ELSE
                 BEGIN
				     SELECT CODIGO INTO tipoId
				     FROM LISTA_VALORES
				     WHERE TIPO_DATO = '17'
				     AND CODIGO = tipoId;
				 EXCEPTION
				     WHEN OTHERS THEN
                    /* SI TI NO VALIDO, REGISTRAR EN EL LOG DE ERRORES Y PASAR A LA SIGUIENTE LÍNEA */
                    mensajeError := 'Error al validar el registro. TI: '||tipoId||'  NI: '||numeroId||' TI NO EXISTE EN SIPCLA';
                    INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                    VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                    COMMIT;
                    RETURN;
                END;

				BEGIN
				     SELECT CODIGO INTO tTipoEntidad
				     FROM LISTA_VALORES
				     WHERE TIPO_DATO = '24'
				     AND CODIGO = tipoEntidad;
				 EXCEPTION
				     WHEN OTHERS THEN
                    /* SI Tipo Entidad NO VALIDO, REGISTRAR EN EL LOG DE ERRORES Y PASAR A LA SIGUIENTE LÍNEA */
                    mensajeError := 'Error al validar el registro. TI: '||tipoId||'  NI: '||numeroId||' TIPO ENTIDAD NO EXISTE EN SIPCLA';
                    INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                    VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                    COMMIT;
                    RETURN;
                END;
            END IF;

            BEGIN

                BEGIN
                    SELECT TO_DATE(sFechaActualizacion, 'YYYYMMDD') INTO fechaActualizacion FROM DUAL;
                EXCEPTION WHEN OTHERS THEN
                    fechaActualizacion := SYSDATE;
                END;

				BEGIN
				    p_genera_flag(flagsIniciales, tipoEntidad, flags);
				EXCEPTION
			        WHEN OTHERS THEN
                        mensajeError := SUBSTR('Error al generar primer flag. TI: '||tipoId||'  NI: '||numeroId||' FLAG: '|| SQLERRM,1,200);
                        INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                        VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                        COMMIT;
                        RETURN;

				END;

                /* INSERTAR EN ENTIDADES_EXCLUIDAS LOS VALORES LEIDOS */
                BEGIN
                    INSERT INTO ENTIDADES_EXCLUIDAS(
                        TIPO_IDENTIFICACION,
                        NUMERO_IDENTIFICACION,
                        FLAGS_TIPOS,
                        OBLIGAR_CARGA,
                        NOMBRE,
                        FECHA_ACTUALIZACION
                        ) VALUES(
                        tipoId,
                        numeroId,
                        flags,
						obligarCarga,
                        nombreEntidad,
                        fechaActualizacion
                        );
                        nroEntidadesInsertadas := nroEntidadesInsertadas + 1;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN

						SELECT FLAGS_TIPOS INTO flagsIniciales
						FROM ENTIDADES_EXCLUIDAS
						WHERE TIPO_IDENTIFICACION = tipoId
						AND NUMERO_IDENTIFICACION = numeroId;

				        BEGIN
				            p_genera_flag(flagsIniciales, tipoEntidad, flags);
				        EXCEPTION
			                WHEN OTHERS THEN
                            mensajeError := SUBSTR('Error al buscar registro. TI: '||tipoId||'  NI: '||numeroId||' FLAG: '|| SQLERRM,1,200);
                            INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                            VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                            COMMIT;
                            RETURN;
          				END;
						IF flags != flagsIniciales THEN

						    UPDATE ENTIDADES_EXCLUIDAS
						    SET NOMBRE = nombreEntidad,
						        FLAGS_TIPOS = flags,
						        FECHA_ACTUALIZACION = fechaActualizacion
						    WHERE TIPO_IDENTIFICACION = tipoId
						      AND NUMERO_IDENTIFICACION = numeroId;

							nroEntidadesInsertadas := nroEntidadesInsertadas + 1;

						ELSE

                            nroEntidadesYaExisten := nroEntidadesYaExisten + 1;

					    END IF;

                    WHEN OTHERS THEN
                        mensajeError := SUBSTR('Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId|| '-'|| SQLERRM,1,200);
                        INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                        VALUES (idProceso, SYSDATE, mensajeError , cedulaUsuario);
                        COMMIT;
                END;

            EXCEPTION
                WHEN OTHERS THEN
                    mensajeError := SUBSTR('Error final al procesar el registro. TI: '||tipoId||'  NI: '||numeroId|| '-'|| SQLERRM,1,200);
                    INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                    VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                    COMMIT;
            END;

        EXCEPTION
            WHEN OTHERS THEN
                mensajeError := SUBSTR('Error final al insertar el registro. TI: '||tipoId||'  NI: '||numeroId|| '-'|| SQLERRM,1,200);
                INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                COMMIT;
        END;

    END p_insertar_entidad;

	PROCEDURE p_genera_flag(campoInicial IN VARCHAR2,
	                        tipoEntidad  IN NUMBER,
					        campoFlags   OUT VARCHAR2) IS

	longitudCampoInicial NUMBER      := 0;
	temporal             VARCHAR2(8) := '';
	BEGIN
		 longitudCampoInicial := LENGTH(campoInicial);
		 FOR I in 1..longitudCampoInicial LOOP
		 	 temporal := SUBSTR(campoInicial,I,1);
		 	 IF ( I = tipoEntidad ) THEN
			 	temporal := '1';
			 END IF;
			 campoFlags := campoFlags || temporal;
		 END LOOP;
	END p_genera_flag;

END Pk_Cargue_Entidades;
/


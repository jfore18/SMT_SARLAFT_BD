PROMPT CREATE OR REPLACE PACKAGE BODY pk_cargue_listas_cruce
CREATE OR REPLACE PACKAGE BODY pk_cargue_listas_cruce IS

/******************************************************************************************
                                  P_CARGAR_LISTAS
     Lee del directorio de entradas de la base de datos, el archivo con la lista a cargar.
     Los nombres del directorio de entradas y del archivo se leen de la vista V_RUTAS_BD.
     Parametros:
           - tipoLista : refiere el tipo de lista de cruce a cargar, debe hacer match con la vista
             V_TIPO_MOTIVO (TIPO_DATO 16)
           - cedulaUsuario : persona que ejecuta el cargue
******************************************************************************************/


    PROCEDURE p_cargar_listas   (tipoLista             IN VARCHAR2,
                                 cedulaUsuario         IN  USUARIO.cedula%TYPE,
                                 mensajeRetorno        OUT VARCHAR2) IS

        idProceso           LOG_PROCESOS.id_proceso%TYPE := NULL;

        dir_entradas        V_RUTAS_BD.descripcion%TYPE := 'IDL'; --INPUT DIRECTORY LIST
        archivo_entrada     V_RUTAS_BD.descripcion%TYPE := 'ILC';  -- INPUT LISTA CRUCE
        descriptorArchivo   UTL_FILE.File_Type;
        codigoMensaje       NUMBER;
        registro            VARCHAR2(1000);
        finArchivo          BOOLEAN;
        nRegistros          NUMBER := 0;
        contCommit          NUMBER := 0;
        error               LOG_ERRORES.error%TYPE;

        --CONTADORES PARA MOSTRAR AL FINAL DEL PROCESO
        nroPersonasYaExisten NUMBER := 0;
        nroPersonasInsertadas NUMBER := 0;
    BEGIN

    /* GUARDAR EL INICIO O ARRANQUE DEL PROCESO */
        Pk_Lib.p_actualizar_log_procesos (idProceso, '8', NULL, cedulaUsuario, NULL);

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
                    p_insertar_persona (registro,
                                        idProceso,
                                        tipoLista,
                                        nroPersonasYaExisten,
                                        nroPersonasInsertadas,
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
        mensajeRetorno := 'Registros leidos: ' || nRegistros || '<br>Registros Insertados: ' || nroPersonasInsertadas ||
                          '<br>Registros que ya existían: ' || nroPersonasYaExisten;
    /* ACTUALIZAR HISTORICO CON DURACION Y ESTADISTICAS */
        Pk_Lib.p_actualizar_log_procesos(idProceso, '8', nRegistros, cedulaUsuario, codigoMensaje);

    END p_cargar_listas;


/******************************************************************************************
                                  P_CARGAR_LISTAS

      INSERTA EN LA TABLA PERSONAS_REPORTADAS, VALIDANDO:
      - TIPO IDENTIFICACION (QUEMADO EN CÓDIGO) 'C','T','L','R','N'.
      - SI TIPO IDENTIFICACION O NUMERO DE IDENTIFICACION VIENEN EN BLANCO, PONE TI = 'S' Y NI EL CONSECUTIVO + 1
        DE TODAS LAS PERSONAS REPORTADAS CUYO TIPO DE IDENTIFICACION ES 'S'.
      - SI EL TIPO DE LISTA ES REPORTADOS QUE EL TIPO DE REPORTE EXISTA EN SIPCLA (TABLA LISTA_VALORES CAMPO TIPO_DATO=4)
        Y QUE EL NUMERO DE ROS NO EXISTA EN SIPCLA.
******************************************************************************************/

    PROCEDURE p_insertar_persona (regPersona            IN VARCHAR2,
                                  idProceso             IN LOG_PROCESOS.id_proceso%TYPE,
                                  tipoLista             IN VARCHAR2,
                                  nroPersonasYaExisten  IN OUT NUMBER,
                                  nroPersonasInsertadas IN OUT NUMBER,
                                  cedulaUsuario         IN  USUARIO.cedula%TYPE) IS

        tipoId              PERSONAS_REPORTADAS.TIPO_IDENTIFICACION%TYPE;
        numeroId            PERSONAS_REPORTADAS.NUMERO_IDENTIFICACION%TYPE;
        nombresPersona      PERSONAS_REPORTADAS.NOMBRES_RAZON_COMERCIAL%TYPE;
        apellidosPersona    PERSONAS_REPORTADAS.APELLIDOS_RAZON_SOCIAL%TYPE;
        aliasPersona        PERSONAS_REPORTADAS.ALIAS%TYPE;
        comentarioPersona   PERSONAS_REPORTADAS.COMENTARIO%TYPE;
        fechaIngreso        PERSONAS_REPORTADAS.FECHA_INGRESO%TYPE;
        tipoReporte         PERSONAS_REPORTADAS.TIPO_REPORTE%TYPE;
        rosPersona          PERSONAS_REPORTADAS.ROS%TYPE;
        sFechaIngreso       VARCHAR2(8);

        existeRosSIPCLA     REPORTE.ROS_RELACIONADO%TYPE;

        mensajeError        LOG_ERRORES.error%TYPE;

    BEGIN
        tipoId              := TRIM(SUBSTR(regPersona,1,1));
        numeroId            := TRIM(SUBSTR(regPersona,2,11));
        apellidosPersona    := TRIM(SUBSTR(regPersona,13,60));
        nombresPersona      := TRIM(SUBSTR(regPersona,73,60));
        aliasPersona        := TRIM(SUBSTR(regPersona,133,20));
        comentarioPersona   := TRIM(SUBSTR(regPersona,153,100));
        tipoReporte         := TRIM(SUBSTR(regPersona,253,1));
        rosPersona          := TRIM(SUBSTR(regPersona,254,10));
        sFechaIngreso       := SUBSTR(regPersona,264,8);

        BEGIN
            /* SI EL TIPO O NUMERO DE IDENTIFICACION SON NULOS, SE CREA TIPO 'S' Y CON CONSECUTIVO */
            IF tipoId IS NULL OR numeroId IS NULL OR tipoId = '' OR numeroId = '' THEN

                tipoId := 'S';
				BEGIN
                    SELECT NVL(MAX(TO_NUMBER(NUMERO_IDENTIFICACION)),0) + 1 INTO numeroId
                    FROM PERSONAS_REPORTADAS
                    WHERE TIPO_IDENTIFICACION = 'S';
				EXCEPTION
				    WHEN OTHERS THEN
					     numeroId := 1;
			    END;

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
                    mensajeError := 'Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId||' TI NO EXISTE EN SIPCLA';
                    INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                    VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                    COMMIT;
                    RETURN;
			    END;
            END IF;

            BEGIN

                BEGIN
                    SELECT TO_DATE(sFechaIngreso, 'YYYYMMDD') INTO fechaIngreso FROM DUAL;
                EXCEPTION WHEN OTHERS THEN
                    fechaIngreso := SYSDATE;
                END;

                -- VALIDACIONES ESPECIALES CUANDO LA LISTA A CREAR ES DE TIPO REPORTADOS,
                -- YA QUE DEBE GENERAR ERROR SI EXISTE EL ROS EN SIPCLA

                IF tipoLista = '16' THEN

                    BEGIN

                        SELECT CODIGO
                        INTO tipoReporte
                        FROM LISTA_VALORES
                        WHERE TIPO_DATO = '4' AND
                              CODIGO    = tipoReporte;

                        BEGIN

                            SELECT ROS_RELACIONADO
                            INTO existeRosSIPCLA
                            FROM REPORTE
                            WHERE ROS_RELACIONADO = rosPersona;

                            mensajeError := 'Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId||' ROS existe en SIPCLA';
                            INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                            VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                            COMMIT;
                            RETURN;

                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                tipoReporte := tipoReporte;
                                rosPersona  := rosPersona;

                            WHEN OTHERS THEN
                                mensajeError := SUBSTR('Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId||' ros no valido' || rosPersona || SQLERRM,1,200);
                                INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                                VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                                COMMIT;
                                RETURN;
                        END;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            mensajeError := 'Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId||' tipo de reporte no valido';
                            INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                            VALUES (idProceso, SYSDATE, mensajeError, cedulaUsuario);
                            COMMIT;
                            RETURN;
                    END;

                ELSE

                    tipoReporte := NULL;
                    rosPersona  := NULL;

                END IF;

                /* INSERTAR EN PERSONAS_REPORTADAS LOS VALORES LEIDOS */
                BEGIN
                    INSERT INTO PERSONAS_REPORTADAS(
                        CODIGO_MOTIVO_V,
                        TIPO_IDENTIFICACION,
                        NUMERO_IDENTIFICACION,
                        ID_REPORTE,
                        APELLIDOS_RAZON_SOCIAL,
                        NOMBRES_RAZON_COMERCIAL,
                        ALIAS,
                        COMENTARIO,
                        FECHA_INGRESO,
                        TIPO_REPORTE,
                        ROS
                        ) VALUES(
                        tipoLista,
                        tipoId,
                        numeroId,
                        null,
                        apellidosPersona,
                        nombresPersona,
                        aliasPersona,
                        comentarioPersona,
                        fechaIngreso,
                        tipoReporte,
                        rosPersona
                        );
                        nroPersonasInsertadas := nroPersonasInsertadas + 1;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        nroPersonasYaExisten := nroPersonasYaExisten + 1;
                    WHEN OTHERS THEN
                        mensajeError := SUBSTR('Error al insertar el registro. TI: '||tipoId||'  NI: '||numeroId|| '-'|| SQLERRM,1,200);
                        INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
                        VALUES (idProceso, SYSDATE, mensajeError , cedulaUsuario);
                        COMMIT;
                END;

            EXCEPTION
                WHEN OTHERS THEN
                    mensajeError := SUBSTR('Error final al insertar el registro. TI: '||tipoId||'  NI: '||numeroId|| '-'|| SQLERRM,1,200);
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

    END p_insertar_persona;

END Pk_Cargue_Listas_Cruce;
/


PROMPT CREATE OR REPLACE PACKAGE BODY pk_depuracion
CREATE OR REPLACE PACKAGE BODY pk_depuracion IS

PROCEDURE DEPURAR ( mensajeError  OUT    VARCHAR2,
                      cedulaUsuario IN     USUARIO.cedula%TYPE) IS

 CURSOR reporte_depurar (parametro NUMBER) IS
  SELECT ID
  FROM REPORTE
  WHERE fecha_actualizacion < SYSDATE - parametro
  MINUS
  SELECT ID_REPORTE
  FROM CONCEPTO_INICIAL;

 CURSOR reportesNoPasar IS
  SELECT tipo_identificacion, numero_identificacion, id, codigo_cargo
  FROM reporte r
  WHERE EXISTS (SELECT 1
  FROM cargos c
  WHERE r.codigo_cargo = c.codigo
  AND  codigo_perfil_v = '2')
  ORDER BY tipo_identificacion, numero_identificacion, codigo_cargo, fecha_creacion ASC ;

  --Variables de procesamiento
   numeroDias  NUMBER;
   contador    NUMBER;
   niTemp      REPORTE.NUMERO_IDENTIFICACION%TYPE;
   cargoTemp   REPORTE.CODIGO_CARGO%TYPE;

  --Archivo de log
   ubicacionArchivoLog   VARCHAR2(128) ;
   nombreArchivoLog      VARCHAR2(128) ;
   bitacora              UTL_FILE.FILE_TYPE;
   errorArchivo          EXCEPTION;

  --Variables log procesamiento
   idProceso       LOG_PROCESOS.id_proceso%TYPE := NULL;
   totalRegistros  NUMBER;

  -- CVAPD00117151 - GROJAS2 - Ajuste Proceso Depuración SMT
  -- variable que almacena el comando de reconstruccion de base de datos
  actualizar_indice_con_ini  VARCHAR2(50);

  BEGIN
   --INICIALIZACION DE VARIABLES DE PROCESAMIENTO
   --Por omisión se toman 90 dias (3 meses) hacia atras
   Pk_Lib.p_actualizar_log_procesos (idProceso, '11', NULL, cedulaUsuario, NULL);
   totalRegistros  := 0;
   numeroDias      := 90;
   niTemp          := '';
   cargoTemp       := '';
   contador        := 0;
   -- ABRIR ARCHIVO DE LOG
   -- Traer ubicación y nombre archivo de log
    BEGIN
      SELECT NOMBRE_LARGO INTO ubicacionArchivoLog
      FROM LISTA_VALORES
      WHERE TIPO_DATO = '26'
      AND CODIGO      = '2';
    EXCEPTION
     WHEN OTHERS THEN
      ubicacionArchivoLog := 'N:\ENTRADAS\SIPCLA';
    END;

    BEGIN
      SELECT NOMBRE_LARGO || To_Char(SYSDATE, 'YYYY_MM_DD_HH24_MI') || '.txt'
      INTO  nombreArchivoLog
      FROM LISTA_VALORES
      WHERE TIPO_DATO = '26'
      AND CODIGO      = '3';
    EXCEPTION
      WHEN OTHERS THEN
      nombreArchivoLog := 'logDepuracion.txt';
    END;

    BEGIN
      abrirArchivo(ubicacionArchivoLog, nombreArchivoLog, 'w', bitacora);
      escribirArchivo(bitacora, '---------------------------------------------------------');
      escribirArchivo(bitacora, 'DEPURACIÓN: ' || To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'));
      escribirArchivo(bitacora, '---------------------------------------------------------');
      escribirArchivo(bitacora, '');
    EXCEPTION
      WHEN errorArchivo THEN
       RETURN;
      WHEN OTHERS THEN
       NULL;
    END;

    -- Sacar parametro de la tabla correspondiente LISTA VALORES
    BEGIN
     SELECT To_Number(NOMBRE_CORTO) INTO numeroDias
     FROM LISTA_VALORES
     WHERE TIPO_DATO = '26'
     AND CODIGO      = '1';
    EXCEPTION
     WHEN OTHERS THEN
      numeroDias := 90;
    END;

    escribirArchivo(bitacora, 'Numero de dias hacia atras tomados: ' || numeroDias);

    -- Obtencion de reportes que no deben pasar al historico
    FOR repNP IN reportesNoPasar LOOP

      IF niTemp = repNP.NUMERO_IDENTIFICACION AND cargoTemp = repNP.CODIGO_CARGO THEN
         contador := contador + 1;
      ELSE
        --temp es diferente, cambié de cliente, contador a ceros
        contador  := 1;
        niTemp    := repNP.NUMERO_IDENTIFICACION;
        cargoTemp := repNP.CODIGO_CARGO;
      END IF;

    IF contador < 4 THEN
     --insertamos registro en concepto innicial
     BEGIN

      INSERT INTO CONCEPTO_INICIAL (TIPO_IDENTIFICACION, NUMERO_IDENTIFICACION, ID_REPORTE)
      VALUES(repNP.tipo_identificacion, repNP.numero_identificacion, repNP.id);

      -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
      escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') || ' - idrep : '|| repNP.id ||' - tipo_identificacion : '||repNP.tipo_identificacion||' - numero_identificacion : '||repNP.numero_identificacion
      || ' - Codigo_Cargo : ' || repNP.Codigo_Cargo  || ' - MENSAJE :INSERTANDO_EN_CONCEPTO_INICIAL ');
     EXCEPTION
      WHEN OTHERS THEN
        NULL;
     END;
    END IF;

    END LOOP;

    escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - INICIO-PROCESO-DEPURACION:');

    -- Reportes que deben pasar al historico
    FOR rep IN reporte_depurar(numeroDias) LOOP

     IF reporteGestionado(rep.id,bitacora) THEN

      totalRegistros := totalRegistros + 1;
      -- Mover datos reporte
      BEGIN
        moverPreguntasReporte(rep.id, bitacora);
      EXCEPTION
        WHEN OTHERS THEN
          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - excepcion_moverPreguntasReporte. Reporte : ' || rep.id || ' - ERROR :' || SQLERRM );
      END;

      -- Mover reporte
      BEGIN
        moverReporte(rep.id, bitacora);
      EXCEPTION
        WHEN OTHERS THEN
          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - excepcion_moverReporte. Reporte : ' || rep.id || ' - ERROR :' || SQLERRM );
      END;

      -- Mover transacciones
      BEGIN
         moverTransacciones(rep.id, bitacora);
      EXCEPTION
         WHEN OTHERS THEN
          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - excepcion_moverTransacciones. Reporte : ' || rep.id || ' - ERROR :' || SQLERRM );
      END;

      -- CVAPD00117151 - GROJAS2 - Ajuste Proceso Depuración SMT
      -- Se agrega la fecha y la hora de finalizacion del procesamiento del registro
      -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
      escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - REPORTE-EN-HISTORICO  - DATOS : reporte : ' || rep.id);

     END IF;
    END LOOP;

    escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - REPORTES ENVIADOS AL HISTORICO '|| To_Char(totalRegistros));
    -- 03/03/2009. Se agrega procedimiento para pasar todos los registros de la tabla log consultas al histórico
    moverLogConsultas(bitacora, 0);

    -- CVAPD00117151 - GROJAS2 - Ajuste Proceso Depuración SMT
    -- Se reconstruye la tabla de indices de la tabla concepto_inicial
    actualizar_indice_con_ini:='ALTER INDEX IN_REP_CONCEPTO_INICIAL REBUILD';
    execute immediate (actualizar_indice_con_ini);

    escribirArchivo(bitacora, '-----------------------------------------------------------------------------------');
    escribirArchivo(bitacora, '                FIN PROCESAMIENTO ' || To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') );
    escribirArchivo(bitacora, '-----------------------------------------------------------------------------------');
    cerrarArchivo(bitacora);
    mensajeError := 'El proceso terminó exitosamente';
    Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, totalRegistros, NULL, 0);

    EXCEPTION
      WHEN OTHERS THEN
      mensajeError := SUBSTR(SQLERRM,12,50);
      escribirArchivo(bitacora, 'SE PRESENTO UN ERROR: ' || To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') || ' ' ||SQLCODE);
      escribirArchivo(bitacora, SQLERRM );
      cerrarArchivo(bitacora);
      Pk_Lib.p_insertar_mensaje(SQLCODE, mensajeError);
      Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, totalRegistros, NULL, SQLCODE);
    END DEPURAR;

/********************************************************************************************/
  --GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
 FUNCTION reporteGestionado (idReporte IN REPORTE.ID%TYPE, bitacora IN OUT UTL_FILE.FILE_TYPE) RETURN BOOLEAN IS

  CURSOR transacciones_asociadas IS
   SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
   FROM TRANSACCIONES_REP
   WHERE ID_REPORTE = idReporte;

   existe          NUMBER;
   claseReporte    REPORTE.CODIGO_CLASE_REPORTE_V%TYPE;
   estadoReporte   REPORTE.CODIGO_ESTADO_REPORTE_V%TYPE;

   BEGIN
    existe := 0;

    SELECT codigo_clase_reporte_v, codigo_estado_reporte_v
    INTO claseReporte, estadoReporte
    FROM REPORTE
    WHERE id = idReporte;

    -- si es reporte de cliente, sólo se verifica su estado
    IF claseReporte = 3 THEN
       IF estadoReporte IN ('3','4','5') THEN
          existe := 0;
       ELSE
          escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - REPORTE-NO-GESTIONADO - DATOS : reporte tipoCliente : ' || idReporte);
          existe := 1;
       END IF;
    -- si no es reporte de cliente, se verifica el estado de las transacciones asociadas
    ELSE
     FOR tx IN transacciones_asociadas LOOP

      BEGIN
       -- Existe = 0 cuando la transaccion puede pasar al historico
       SELECT 1
       INTO existe
       FROM transacciones_cliente
       WHERE CODIGO_ARCHIVO = tx.CODIGO_ARCHIVO
       AND FECHA_PROCESO = tx.FECHA_PROCESO
       AND ID = tx.ID_TRANSACCION
       AND NOT ((estado_oficina = 'N' AND mayor_riesgo = '0')
               OR (estado_oficina = 'I' AND estado_ducc IN ('S','N','M'))
               OR (estado_oficina = 'N' AND mayor_riesgo = '1' AND estado_ducc IN ('S','N','M')));

       escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - REPORTE-NO-GESTIONADO - DATOS: transaccionPendiente. CODIGO_ARCHIVO '
       || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : '|| tx.FECHA_PROCESO ||' - ID_TRANSACCION : ' || tx.ID_TRANSACCION || ' - idReporte : ' || idReporte);

       EXIT;

      EXCEPTION
        WHEN No_Data_Found THEN
          existe := 0;
          -- Modificado por ABOCANE 26/02/13. Sí la transaccion es candidata a pasar historico, se revisa que no este relacionada
          -- a algún reporte que se encuentre en estudio o revisión.
          if not(transaccionEnReporte(tx.codigo_archivo,tx.fecha_proceso,tx.id_transaccion))then
           existe := 1;
           EXIT;
          end if;

         WHEN OTHERS THEN
             --GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
              escribirArchivo(bitacora, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Excepcion en trasacciones_reporte  codigo_archivo ' ||
              tx.codigo_archivo || ' - fecha_proceso : '|| tx.fecha_proceso ||' - id_transaccion : ' || tx.id_transaccion ||' - existe : ' || existe ||
              ' - MENSAJE : reporte gestionado ' || SQLERRM);
              NULL;
      END;

     END LOOP;
    END IF;

    IF existe = 0 THEN
      RETURN TRUE;
    ELSE
     RETURN FALSE;
   END IF;

END reporteGestionado;


/*** Modificado por ABOCANE 26/02/13. Función para determinar sí una transacción se encuentra en algún reporte
     que este en estudio(1)o en revisión(2), o en un reporte que se encuentre registrado en la estructura concepto_inicial
***/

--GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
FUNCTION transaccionEnReporte(codArchivo IN TRANSACCIONES_CLIENTE.codigo_archivo%type,
                                   fechaP IN TRANSACCIONES_CLIENTE.fecha_proceso%type,
                                   idTransaccion IN TRANSACCIONES_CLIENTE.id%type) RETURN BOOLEAN IS
  CONTADOR number;
  CURSOR reportes_asociados IS
  SELECT ID_REPORTE
  FROM TRANSACCIONES_REP
  WHERE CODIGO_ARCHIVO = codArchivo
  AND FECHA_PROCESO = fechaP
  AND ID_TRANSACCION = idTransaccion;

  estado_reporte    reporte.codigo_estado_reporte_v%TYPE;

  begin
   CONTADOR :=0;
   FOR rp in reportes_asociados loop
     SELECT codigo_estado_reporte_v into estado_reporte FROM REPORTE WHERE ID= rp.ID_REPORTE;
     -- Si el estado es '1' revision o '2' en estudio, no se pruede enviar a historico.
     if((estado_reporte = '1') or (estado_reporte = '2')) then
      RETURN FALSE;
     END if;

    -- Determinamos si el reporte se encuentra relacionado en la estructura concepto_inicial
    BEGIN
     SELECT 1 INTO CONTADOR FROM CONCEPTO_INICIAL WHERE ID_REPORTE = RP.ID_REPORTE;
    EXCEPTION
     WHEN No_Data_Found THEN
      CONTADOR:=0;
    END;

    IF CONTADOR= 1 THEN
     RETURN FALSE;
    END IF;
   END LOOP;

   RETURN TRUE;
END  transaccionEnReporte;

/********************************************************************************************/
PROCEDURE moverPreguntasReporte ( idReporte IN REPORTE.ID%TYPE,
                                    archivo   IN OUT UTL_FILE.FILE_TYPE) IS
    CURSOR txAsociadas IS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM TRANSACCIONES_REP
      WHERE ID_REPORTE = idReporte
      MINUS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID
      FROM SISCLA_HIS.TRANSACCIONES_CLIENTE
      WHERE (CODIGO_ARCHIVO, FECHA_PROCESO, ID) IN (
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM TRANSACCIONES_REP
      WHERE ID_REPORTE = idReporte);

    tabla         ARCHIVOS.tabla_detalle%TYPE;
    sqlInsercion  VARCHAR2(4000);

    BEGIN

    FOR tx IN txAsociadas LOOP
        BEGIN
          INSERT INTO SISCLA_HIS.TRANSACCIONES_CLIENTE
          SELECT TC.*
          FROM TRANSACCIONES_CLIENTE TC
          WHERE
          TC.CODIGO_ARCHIVO = tx.CODIGO_ARCHIVO
          AND TC.FECHA_PROCESO = tx.FECHA_PROCESO
          AND TC.ID = tx.ID_TRANSACCION;
        EXCEPTION
        WHEN Dup_Val_On_Index THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.TRANSACCIONES_CLIENTE - ERROR : ' || SQLERRM );
        WHEN OTHERS THEN
          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.TRANSACCIONES_CLIENTE - ERROR : ' || SQLERRM );
          --

        END;

        /* INSERTAR EN TABLAS DETALLE SEGÚN CORRESPONDA */
        BEGIN
          SELECT tabla_detalle INTO tabla
          FROM archivos
          WHERE codigo = tx.CODIGO_ARCHIVO;
        EXCEPTION
        WHEN No_Data_Found THEN
          SELECT tabla_detalle INTO tabla
          FROM archivos
          WHERE codigo = (SELECT codigo_archivo
          FROM siscla_his.transacciones_cliente tc
          WHERE
          TC.CODIGO_ARCHIVO = tx.CODIGO_ARCHIVO
          AND TC.FECHA_PROCESO = tx.FECHA_PROCESO
          AND TC.ID = tx.ID_TRANSACCION);
        END;

        sqlInsercion := ' INSERT INTO SISCLA_HIS.' || tabla  ||
                        ' SELECT * FROM ' || tabla ||
                        ' WHERE CODIGO_ARCHIVO = ''' || tx.codigo_archivo || '''' ||
                        ' AND FECHA_PROCESO = ''' || tx.fecha_proceso||'''' ||
                        ' AND ID_TRANSACCION = ' || tx.id_transaccion;

        BEGIN
         ejecutarSentencia(sqlInsercion, archivo);
        EXCEPTION

        WHEN Dup_Val_On_Index THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.' || tabla || ' - ERROR : ' || SQLERRM);
        WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.' || tabla || ' - ERROR : ' || SQLERRM);
        END;

        /* COPIAR HISTORICO DE ESTADOS */
        BEGIN
          INSERT INTO SISCLA_HIS.HISTORICO_ESTADOS_TR
          SELECT * FROM HISTORICO_ESTADOS_TR
          WHERE CODIGO_ARCHIVO = tx.CODIGO_ARCHIVO AND
          FECHA_PROCESO = tx.FECHA_PROCESO AND
          ID_TRANSACCION = tx.ID_TRANSACCION;

        EXCEPTION
          WHEN Dup_Val_On_Index THEN

           -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
           escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
           idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
           '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.HISTORICO_ESTADOS_TR - ERROR : ' || SQLERRM);

        WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.HISTORICO_ESTADOS_TR - ERROR : ' || SQLERRM);

        END;

        /* COPIAR CRITERIOS DE TRANSACCION */
        BEGIN
          INSERT INTO SISCLA_HIS.CRITERIOS_TRANSACCION
          SELECT * FROM CRITERIOS_TRANSACCION
          WHERE CODIGO_ARCHIVO = tx.CODIGO_ARCHIVO AND
          FECHA_PROCESO = tx.FECHA_PROCESO AND
          ID_TRANSACCION = tx.ID_TRANSACCION;

        EXCEPTION
          WHEN Dup_Val_On_Index THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.CRITERIOS_TRANSACCION - ERROR : ' || SQLERRM);

          WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - CODIGO_ARCHIVO : ' || tx.CODIGO_ARCHIVO || ' - FECHA_PROCESO : ' || tx.FECHA_PROCESO || ' - ID_TRANSACCION : ' || tx.ID_TRANSACCION ||
          '- MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.CRITERIOS_TRANSACCION - ERROR : ' || SQLERRM);
         END;
         COMMIT;
      END LOOP;

      /* INSERTAR RELACION TRANSACCIONES REPORTE */
      BEGIN
        INSERT INTO SISCLA_HIS.TRANSACCIONES_REP
        SELECT * FROM TRANSACCIONES_REP
        WHERE ID_REPORTE = idReporte;

     EXCEPTION
      WHEN Dup_Val_On_Index THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.TRANSACCIONES_REP - ERROR : ' || SQLERRM);
      WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
          idReporte || ' - MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.TRANSACCIONES_REP - ERROR : ' || SQLERRM);
      END;

      /*INSERTAR REPORTE */
      BEGIN
        INSERT INTO SISCLA_HIS.REPORTE
        SELECT * FROM REPORTE
        WHERE ID = idReporte;

      EXCEPTION
        WHEN Dup_Val_On_Index THEN

             -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
             escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
             idReporte || ' - MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.REPORTE - ERROR : ' || SQLERRM);
        WHEN OTHERS THEN

             -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
             escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
             idReporte || ' - MENSAJE : No se pudo insertar la transaccion en SISCLA_HIS.REPORTE - ERROR : ' || SQLERRM);
      END;
      COMMIT;

      BEGIN
        INSERT INTO SISCLA_HIS.RTAS_BOOLEAN_REP
        SELECT *
        FROM RTAS_BOOLEAN_REP
        WHERE ID_REPORTE = idReporte;

        /* ELIMINAR RESPUESTAS A REPORTE DE LA TABLA TRANSACCIONAL*/
        DELETE RTAS_BOOLEAN_REP
        WHERE ID_REPORTE = idReporte;
        COMMIT;

      EXCEPTION
        WHEN No_Data_Found THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.REPORTE o Eliminar la transaccion en REPORTE - ERROR : ' || SQLERRM);
      WHEN OTHERS THEN
        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.REPORTE o Eliminar la transaccion en REPORTE - ERROR : ' || SQLERRM);
      END;

      /* COPIAR RESPUESTAS TEXTO A REPORTE A LA TABLA HISTORICA */
      BEGIN
        INSERT INTO SISCLA_HIS.RTAS_TEXT_REP
        SELECT *
        FROM RTAS_TEXT_REP
        WHERE ID_REPORTE = idReporte;

         /* ELIMINAR RESPUESTAS A REPORTE DE LA TABLA TRANSACCIONAL*/
        DELETE RTAS_TEXT_REP
        WHERE ID_REPORTE = idReporte;
        COMMIT;

      EXCEPTION

        WHEN No_Data_Found THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.RTAS_TEXT_REP o Eliminar la transaccion en RTAS_TEXT_REP - ERROR : ' || SQLERRM);
        WHEN OTHERS THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.RTAS_TEXT_REP o Eliminar la transaccion en RTAS_TEXT_REP - ERROR : ' || SQLERRM);

      END;

    EXCEPTION
    WHEN OTHERS THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : Error al Mover las respuestas - ERROR : ' || SQLERRM);
END moverPreguntasReporte;

/********************************************************************************************/
  PROCEDURE moverReporte          ( idReporte IN REPORTE.ID%TYPE,
                                    archivo   IN OUT UTL_FILE.FILE_TYPE) IS

    BEGIN

     /* MOVER DETALLE ANALISIS */
      BEGIN
        INSERT INTO SISCLA_HIS.DETALLE_ANALISIS_REP
        SELECT * FROM DETALLE_ANALISIS_REP
        WHERE ID_REPORTE = idReporte;

        DELETE DETALLE_ANALISIS_REP
        WHERE ID_REPORTE = idReporte;

      EXCEPTION
       WHEN No_Data_Found THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.DETALLE_ANALISIS_REP o Eliminar la transaccion en DETALLE_ANALISIS_REP - ERROR : ' || SQLERRM);
       WHEN OTHERS THEN
         -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
         escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
         idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.DETALLE_ANALISIS_REP o Eliminar la transaccion en DETALLE_ANALISIS_REP - ERROR : ' || SQLERRM);

       END;

      /* MOVER PERSONAS_REP */
      BEGIN
        INSERT INTO SISCLA_HIS.PERSONAS_REP
        SELECT * FROM PERSONAS_REP
        WHERE ID_REPORTE = idReporte;

        DELETE PERSONAS_REP
        WHERE ID_REPORTE = idReporte;

      EXCEPTION
        WHEN No_Data_Found THEN
         -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
         escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
         idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.PERSONAS_REP o Eliminar la transaccion en PERSONAS_REP - ERROR : ' || SQLERRM);

      WHEN OTHERS THEN
         -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
         escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
         idReporte || ' - MENSAJE : No se pudo insertar en SISCLA_HIS.PERSONAS_REP o Eliminar la transaccion en PERSONAS_REP - ERROR : ' || SQLERRM);
      END;

    EXCEPTION
    WHEN OTHERS THEN

        -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
        escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverPreguntasReporte - Cursor : txAsociadas - DATOS : Reporte : ' ||
        idReporte || ' - MENSAJE : Error al Mover el reporte - ERROR : ' || SQLERRM);
 END moverReporte;

/********************************************************************************************/
  PROCEDURE moverTransacciones   (idReporte IN REPORTE.ID%TYPE,
                                  archivo   IN OUT UTL_FILE.FILE_TYPE) IS

    CURSOR txAsociadas IS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM TRANSACCIONES_REP
      WHERE ID_REPORTE = idReporte
      MINUS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID
      FROM SISCLA_HIS.TRANSACCIONES_CLIENTE
      WHERE (CODIGO_ARCHIVO, FECHA_PROCESO, ID) IN (
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM TRANSACCIONES_REP
      WHERE ID_REPORTE = idReporte);

    CURSOR txMovidas IS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM SISCLA_HIS.TRANSACCIONES_REP
      WHERE ID_REPORTE = idReporte;

    tabla         ARCHIVOS.tabla_detalle%TYPE;
    sqlInsercion  VARCHAR2(4000);
    sqlBorrado    VARCHAR2(4000);

    BEGIN

    FOR tranM IN txMovidas LOOP
        --Dbms_Output.PUT_LINE('2');
        /* BORRAR TABLAS DETALLE SEGÚN CORRESPONDA */
        BEGIN
          SELECT tabla_detalle INTO tabla
          FROM archivos
          WHERE codigo = tranM.CODIGO_ARCHIVO;

        EXCEPTION
        WHEN No_Data_Found THEN
          SELECT tabla_detalle INTO tabla
          FROM archivos
          WHERE codigo = (SELECT codigo_archivo
          FROM siscla_his.transacciones_cliente tc
          WHERE
          TC.CODIGO_ARCHIVO = tranM.CODIGO_ARCHIVO
          AND TC.FECHA_PROCESO = tranM.FECHA_PROCESO
          AND TC.ID = tranM.ID_TRANSACCION);
        END;

               --Dbms_Output.PUT_LINE('3');
        sqlBorrado := ' DELETE ' || tabla  ||
                      ' WHERE CODIGO_ARCHIVO = ''' || tranM.codigo_archivo || '''' ||
                      ' AND FECHA_PROCESO = ''' || tranM.fecha_proceso ||'''' ||
                      ' AND ID_TRANSACCION = ' || tranM.id_transaccion;

        BEGIN
          --Dbms_Output.PUT_LINE('4');
          ejecutarSentencia(sqlBorrado, archivo);
          --Dbms_Output.PUT_LINE('5');

       EXCEPTION
        WHEN No_Data_Found THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverTransacciones - Cursor : txMovidas - DATOS : Reporte : ' ||
          idReporte || ' - tabla : ' || tabla || ' - codigo_archivo : '|| tranM.codigo_archivo || ' - fecha_proceso : ' || tranM.fecha_proceso || ' - id_transaccion : ' ||  tranM.id_transaccion  ||
          ' - MENSAJE : Error al Eliminar el registro de la tabla : ' || tabla ||' - ERROR : ' || SQLERRM );
          NULL;
        WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverTransacciones - Cursor : txMovidas - DATOS : Reporte : ' ||
          idReporte || ' - tabla : ' || tabla || ' - codigo_archivo : '|| tranM.codigo_archivo || ' - fecha_proceso : ' || tranM.fecha_proceso || ' - id_transaccion : ' ||  tranM.id_transaccion  ||
          ' - MENSAJE : Error al Eliminar el registro de la tabla : ' || tabla ||' - ERROR : ' || SQLERRM );
          --

          --Dbms_Output.PUT_LINE('QUÉ HAGO?');
          NULL;
        END;


        /* BORRAR HISTORICO ESTADOS */
        DELETE HISTORICO_ESTADOS_TR
        WHERE CODIGO_ARCHIVO = tranM.CODIGO_ARCHIVO
        AND FECHA_PROCESO = tranM.FECHA_PROCESO
        AND ID_TRANSACCION = tranM.ID_TRANSACCION;

        /* BORRAR CRITERIOS INUSUALIDAD */
        DELETE CRITERIOS_TRANSACCION
        WHERE CODIGO_ARCHIVO = tranM.CODIGO_ARCHIVO
        AND FECHA_PROCESO = tranM.FECHA_PROCESO
        AND ID_TRANSACCION = tranM.ID_TRANSACCION;

        /*BORRAR RELACION TRANSACCIONES REPORTE */
        DELETE TRANSACCIONES_REP
        WHERE CODIGO_ARCHIVO = tranM.CODIGO_ARCHIVO
        AND FECHA_PROCESO = tranM.FECHA_PROCESO
        AND ID_TRANSACCION = tranM.ID_TRANSACCION
        AND ID_REPORTE = idReporte;
        COMMIT;

        /*BORRAR TRANSACCION */
        BEGIN
          DELETE TRANSACCIONES_CLIENTE
          WHERE CODIGO_ARCHIVO = tranM.CODIGO_ARCHIVO
          AND FECHA_PROCESO = tranM.FECHA_PROCESO
          AND ID = tranM.ID_TRANSACCION;
          COMMIT;
        EXCEPTION
        WHEN OTHERS THEN

          -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
          escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverTransacciones - Cursor : txMovidas - DATOS : Reporte : ' ||
          idReporte || ' - tabla : ' || tabla || ' - codigo_archivo : '|| tranM.codigo_archivo || ' - fecha_proceso : ' || tranM.fecha_proceso || ' - id_transaccion : ' ||  tranM.id_transaccion  ||
          ' - MENSAJE : Error al Eliminar el registro de la tabla : TRANSACCIONES_CLIENTE - ERROR : ' || SQLERRM );
        END;
      END LOOP;

     /*BORRAR REPORTE */
      DELETE REPORTE
      WHERE ID = idReporte;

   EXCEPTION
    WHEN OTHERS THEN

      -- GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
      escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - Procedimiento : DEPURAR - Cursor : reporte_depurar - Procedimiento : moverTransacciones - EXCEPTION : WHEN OTHERS - DATOS : Reporte : ' ||
      idReporte || ' - MENSAJE : Error al Mover la transaccion - ERROR : ' || SQLERRM );
      --

      --escribirArchivo(archivo, 'Rep: ' || idReporte || ' ERROR EN MOVER TRANSACCION ' || idReporte || SQLERRM );
    END moverTransacciones;

/********************************************************************************************/
  PROCEDURE abrirArchivo (ubicacion     IN     VARCHAR2,
                          nombre        IN     VARCHAR2,
                          modoApertura  IN     VARCHAR2,
                          archivo       OUT    UTL_FILE.FILE_TYPE) IS

    errorArchivo    EXCEPTION;

    BEGIN
      BEGIN
        archivo := UTL_FILE.FOPEN(ubicacion,nombre,modoApertura);
      EXCEPTION
      WHEN OTHERS THEN
        RAISE errorArchivo;
      END;

    END abrirArchivo;

  PROCEDURE escribirArchivo       (archivo       IN  OUT UTL_FILE.FILE_TYPE,
                                  mensaje       IN  VARCHAR2) IS
    BEGIN
      UTL_FILE.PUT_LINE(archivo, mensaje);
    EXCEPTION
    WHEN OTHERS THEN
      NULL;
    END escribirArchivo;

  PROCEDURE cerrarArchivo         (archivo       IN OUT UTL_FILE.FILE_TYPE) IS

    BEGIN
      BEGIN
        UTL_FILE.FCLOSE(archivo);
      EXCEPTION
      WHEN OTHERS THEN
        NULL;
      END;
    END cerrarArchivo;

  PROCEDURE ejecutarSentencia     (sentencia     IN VARCHAR2,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE) IS
    BEGIN
      BEGIN
        EXECUTE IMMEDIATE (sentencia);
        --Dbms_Output.PUT_LINE('BORRÉ TX DETALLE');
      EXCEPTION
      WHEN OTHERS THEN
        escribirArchivo(archivo, 'Sentencia no pudo ser ejecutada: ' || sentencia);
      END;
    END ejecutarSentencia;

/********************************************************************************************/
  PROCEDURE borrarTxnNormales     (nroDias       IN NUMBER,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE) IS

    TYPE T_codArchivo   IS TABLE OF TRANSACCIONES_CLIENTE.CODIGO_ARCHIVO%TYPE;
    TYPE T_fechaProceso IS TABLE OF TRANSACCIONES_CLIENTE.FECHA_PROCESO%TYPE;
    TYPE T_idTx         IS TABLE OF TRANSACCIONES_CLIENTE.ID%TYPE;

    codArchivo    T_codArchivo;
    fechaProceso  T_fechaProceso;
    idTx          T_idTx;

    BEGIN
      escribirArchivo(archivo, '-----------------------------------');
      escribirArchivo(archivo, ' TRANSACCIONES NORMALES FILTRADAS');
      escribirArchivo(archivo, '-----------------------------------');
      escribirArchivo(archivo, 'FECHA_PROCESO|CODIGO_ARCHIVO|ID');
      escribirArchivo(archivo, '-----------------------------------');

      /*SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID
      BULK COLLECT INTO codArchivo, fechaProceso, idTx
      FROM TRANSACCIONES_CLIENTE
      WHERE ESTADO_OFICINA = 'N'
      AND FILTRO_OFICINA = 1
      AND MAYOR_RIESGO = 0
      AND FECHA_PROCESO < SYSDATE - nroDias
      MINUS
      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
      FROM TRANSACCIONES_REP; */

      SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID
      BULK COLLECT INTO codArchivo, fechaProceso, idTx
      FROM TRANSACCIONES_CLIENTE T
      WHERE ESTADO_OFICINA = 'N'
      AND FILTRO_OFICINA = 1
      AND MAYOR_RIESGO = 0
      AND FECHA_PROCESO < SYSDATE - nroDias
      AND NOT EXISTS (SELECT 1
      FROM TRANSACCIONES_REP TEMP
      WHERE TEMP.CODIGO_ARCHIVO = T.CODIGO_ARCHIVO
      AND TEMP.FECHA_PROCESO = T.FECHA_PROCESO
      AND TEMP.ID_TRANSACCION = T.ID);

      IF codArchivo.first IS NOT NULL THEN

        FOR i IN codArchivo.first .. codArchivo.last LOOP
          --    Dbms_Output.put_line('borrar' || codArchivo(i) || ' ' || fechaProceso(i) || ' ' || idTx(i));
          /* COPIAR HISTORICO DE ESTADOS */
          INSERT INTO SISCLA_HIS.HISTORICO_ESTADOS_TR
          SELECT * FROM HISTORICO_ESTADOS_TR
          WHERE CODIGO_ARCHIVO = codArchivo(i)
          AND FECHA_PROCESO = fechaProceso(i)
          AND ID_TRANSACCION = idTx(i);

          /* COPIAR CRITERIOS DE TRANSACCION */
          INSERT INTO SISCLA_HIS.CRITERIOS_TRANSACCION
          SELECT * FROM CRITERIOS_TRANSACCION
          WHERE CODIGO_ARCHIVO = codArchivo(i)
          AND FECHA_PROCESO = fechaProceso(i)
          AND ID_TRANSACCION = idTx(i);

          /* BORRAR HISTORICO ESTADOS */
          DELETE HISTORICO_ESTADOS_TR
          WHERE CODIGO_ARCHIVO = codArchivo(i)
          AND FECHA_PROCESO = fechaProceso(i)
          AND ID_TRANSACCION = idTx(i);

          /* BORRAR CRITERIOS DE TRANSACCION */
          DELETE CRITERIOS_TRANSACCION
          WHERE CODIGO_ARCHIVO = codArchivo(i)
          AND FECHA_PROCESO = fechaProceso(i)
          AND ID_TRANSACCION = idTx(i);

          COMMIT;
          --Dbms_Output.put_line('codigo_archivo: ' || codArchivo(i));
          IF codArchivo(i) IN (1,4) THEN

            INSERT INTO SISCLA_HIS.DETALLE_TR_CC
              SELECT * FROM DETALLE_TR_CC
              WHERE CODIGO_ARCHIVO = codArchivo(i)
              AND FECHA_PROCESO = fechaProceso(i)
              AND ID_TRANSACCION = idTx(i);
            --Dbms_Output.put_line('es tipo 1 '|| SQL%ROWCOUNT );
            DELETE DETALLE_TR_CC
            WHERE CODIGO_ARCHIVO = codArchivo(i)
            AND FECHA_PROCESO = fechaProceso(i)
            AND ID_TRANSACCION = idTx(i);
            --Dbms_Output.put_line('es tipo 1 bis'|| SQL%ROWCOUNT );

            COMMIT;
          END IF ;


          IF codArchivo(i) IN (2,5) THEN
            --Dbms_Output.put_line('es tipo 2');
            INSERT INTO SISCLA_HIS.DETALLE_TR_CA
              SELECT * FROM DETALLE_TR_CA
              WHERE CODIGO_ARCHIVO = codArchivo(i)
              AND FECHA_PROCESO = fechaProceso(i)
              AND ID_TRANSACCION = idTx(i);

            DELETE DETALLE_TR_CA
            WHERE CODIGO_ARCHIVO = codArchivo(i)
            AND FECHA_PROCESO = fechaProceso(i)
            AND ID_TRANSACCION = idTx(i);

            COMMIT;
          END IF ;

          IF codArchivo(i) IN (3,6) THEN
            --Dbms_Output.put_line('es tipo 3');
            INSERT INTO SISCLA_HIS.DETALLE_TR_CDT
              SELECT * FROM DETALLE_TR_CDT
              WHERE CODIGO_ARCHIVO = codArchivo(i)
              AND FECHA_PROCESO = fechaProceso(i)
              AND ID_TRANSACCION = idTx(i);

            DELETE DETALLE_TR_CDT
            WHERE CODIGO_ARCHIVO = codArchivo(i)
            AND FECHA_PROCESO = fechaProceso(i)
            AND ID_TRANSACCION = idTx(i);

            COMMIT;
          END IF ;

          /* MOVER CABECERA DE TRANSACCION */
          INSERT INTO SISCLA_HIS.TRANSACCIONES_CLIENTE
            SELECT * FROM TRANSACCIONES_CLIENTE
            WHERE CODIGO_ARCHIVO = codArchivo(i)
            AND FECHA_PROCESO = fechaProceso(i)
            AND ID = idTx(i);

          DELETE TRANSACCIONES_CLIENTE
          WHERE CODIGO_ARCHIVO = codArchivo(i) AND
          FECHA_PROCESO = fechaProceso(i) AND
          ID = idTx(i);

          COMMIT;

          escribirArchivo(archivo, To_Char(fechaProceso(i),'YYYY/MM/DD') || '    ' ||
          codArchivo(i) || '               ' || idTx(i));

        END LOOP;
      END IF;

      escribirArchivo(archivo, '-----------------------------------');
      escribirArchivo(archivo, 'FIN TRANSACCIONES NORMALES FILTRADAS. TOTAL ' || codArchivo.last);
      escribirArchivo(archivo, '-----------------------------------');
    EXCEPTION
    WHEN OTHERS THEN
      escribirArchivo(archivo, 'Se presentó un error: ' || SQLCODE || '-' || SUBSTR(SQLERRM,1,100));
    END borrarTxnNormales;

/********************************************************************************************/
  PROCEDURE moverLogConsultas (archivo    IN OUT UTL_FILE.FILE_TYPE,
                               numeroDias IN NUMBER) IS

    cantidad  NUMBER;

    BEGIN

      SELECT Count(1)
      INTO cantidad
      FROM log_consultas
      WHERE fecha_ejecucion < SYSDATE - numeroDias;

      INSERT INTO siscla_his.log_consultas
              SELECT consecutivo
              , usuario
              , canal
              , nombre_pc
              , fecha_ejecucion
              , query
              , usuario_nt
              , fecha_envio
              , tipo_id
              , numero_id
              , tipo_producto
              , numero_producto
              , tipo_busqueda
              , tipo_transaccion
              , resultado_tx
              , descripcion_rechazo
              , enviado
              , dominio_red
              FROM log_consultas
              WHERE fecha_ejecucion < SYSDATE - numeroDias;

      DELETE log_consultas
      WHERE fecha_ejecucion < SYSDATE - numeroDias;

      COMMIT;

      -- CVAPD00117151 - GROJAS2 - Ajuste Proceso Depuración SMT
      -- Se agrega la fecha y la hora de finalizacion del procesamiento de los registro
      escribirArchivo(archivo, To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' - REGISTROS DEPURADOS LOG CONSULTAS '|| To_Char(cantidad));
   END moverLogConsultas;
  END PK_DEPURACION;
/


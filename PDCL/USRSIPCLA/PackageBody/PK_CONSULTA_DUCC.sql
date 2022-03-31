PROMPT CREATE OR REPLACE PACKAGE BODY pk_consulta_ducc
CREATE OR REPLACE PACKAGE BODY pk_consulta_ducc IS

  PROCEDURE consultar IS
    CURSOR clientesConsulta IS
    SELECT tipo_identificacion, numero_identificacion
    FROM CONSULTA_DUCC;

   CURSOR reportes (ti VARCHAR2, ni VARCHAR2) IS
   SELECT ID,
          CODIGO_CARGO,
          TIPO_IDENTIFICACION,
          NUMERO_IDENTIFICACION,
          JUSTIFICACION_INICIAL,
          JUSTIFICACION_INICIAL_B,
          JUSTIFICACION_INICIAL_C,
          Nvl(CODIGO_CLASE_REPORTE_V, ' ') CODIGO_CLASE_REPORTE_V,
          Nvl(CODIGO_TIPO_REPORTE_V, ' ') CODIGO_TIPO_REPORTE_V,
          Nvl(CODIGO_ESTADO_REPORTE_V, ' ') CODIGO_ESTADO_REPORTE_V,
          ROS_RELACIONADO,
          INDAGACION,
          FECHA_CREACION,
          USUARIO_CREACION,
          FECHA_ACTUALIZACION,
          USUARIO_ACTUALIZACION
   FROM reporte
   WHERE tipo_identificacion = ti AND
   numero_identificacion = ni
   UNION
   SELECT ID,
          CODIGO_CARGO,
          TIPO_IDENTIFICACION,
          NUMERO_IDENTIFICACION,
          JUSTIFICACION_INICIAL,
          JUSTIFICACION_INICIAL_B,
          JUSTIFICACION_INICIAL_C,
          Nvl(CODIGO_CLASE_REPORTE_V, ' ') CODIGO_CLASE_REPORTE_V,
          Nvl(CODIGO_TIPO_REPORTE_V, ' ') CODIGO_TIPO_REPORTE_V,
          Nvl(CODIGO_ESTADO_REPORTE_V, ' ') CODIGO_ESTADO_REPORTE_V,
          ROS_RELACIONADO,
          INDAGACION,
          FECHA_CREACION,
          USUARIO_CREACION,
          FECHA_ACTUALIZACION,
          USUARIO_ACTUALIZACION
   FROM siscla_his.reporte
   WHERE tipo_identificacion = ti AND
   numero_identificacion = ni;

   CURSOR transacciones (idReporte IN NUMBER) IS
   SELECT CODIGO_ARCHIVO,
          FECHA_PROCESO,
          ID,
          CODIGO_OFICINA,
          ESTADO_DUCC,
          ESTADO_OFICINA,
          FECHA,
          TIPO_IDENTIFICACION,
          NUMERO_IDENTIFICACION,
          NUMERO_NEGOCIO,
          CODIGO_TRANSACCION,
          VALOR_TRANSACCION,
          NOMBRE_CLIENTE
   FROM transacciones_cliente
   WHERE (CODIGO_ARCHIVO, FECHA_PROCESO, ID) IN
   (SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
    FROM TRANSACCIONES_REP
    WHERE ID_REPORTE = idReporte)
   UNION
   SELECT CODIGO_ARCHIVO,
          FECHA_PROCESO,
          ID,
          CODIGO_OFICINA,
          ESTADO_DUCC,
          ESTADO_OFICINA,
          FECHA,
          TIPO_IDENTIFICACION,
          NUMERO_IDENTIFICACION,
          NUMERO_NEGOCIO,
          CODIGO_TRANSACCION,
          VALOR_TRANSACCION,
          NOMBRE_CLIENTE
   FROM siscla_his.transacciones_cliente
   WHERE (CODIGO_ARCHIVO, FECHA_PROCESO, ID) IN
   (SELECT CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION
    FROM siscla_his.TRANSACCIONES_REP
    WHERE ID_REPORTE = idReporte);

--Archivo de log
    ubicacionArchivoLog   VARCHAR2(128) ;
    nombreArchivoLog      VARCHAR2(128) ;
    bitacora              UTL_FILE.FILE_TYPE;
	  errorArchivo          EXCEPTION;

--Manejo saltos de linea conceptos
   justificacionCompletaA VARCHAR2(4000);
   justificacionCompletaB VARCHAR2(4000);
   justificacionCompletaC VARCHAR2(4000);

--Otras variables usadas consulta
   nombreCliente          CLIENTES.NOMBRE_RAZON_SOCIAL%TYPE;
   descrClase             LISTA_VALORES.NOMBRE_LARGO%TYPE;
   descrTipo              LISTA_VALORES.NOMBRE_LARGO%TYPE;
   descrEstado            LISTA_VALORES.NOMBRE_LARGO%TYPE;
   nombreProducto         LISTA_VALORES.NOMBRE_LARGO%TYPE;
   estadoOficina          LISTA_VALORES.NOMBRE_CORTO%TYPE;
   estadoDucc             LISTA_VALORES.NOMBRE_CORTO%TYPE;
   BEGIN
      /* Traer ubicación y nombre archivo de log */
    BEGIN
      SELECT NOMBRE_LARGO INTO ubicacionArchivoLog
      FROM LISTA_VALORES
      WHERE TIPO_DATO = '26'
      AND CODIGO = '2';
    EXCEPTION
      WHEN OTHERS THEN
      ubicacionArchivoLog := 'N:\ENTRADAS\SIPCLA';
    END;
    FOR mCliente IN clientesConsulta LOOP
      BEGIN
        SELECT Nvl(NOMBRE_RAZON_SOCIAL, 'SIN NOMBRE CRM')
        INTO nombreCliente
        FROM CLIENTES
        WHERE TIPO_IDENTIFICACION = mCliente.tipo_identificacion
        AND NUMERO_IDENTIFICACION = mCliente.numero_identificacion;
      EXCEPTION
        WHEN No_Data_Found THEN
          nombreCliente := 'SIN NOMBRE CRM';
      END;

      BEGIN
        abrirArchivo(ubicacionArchivoLog, 'consultaCliente'||mCliente.tipo_identificacion||
                      mCliente.numero_identificacion||
                      To_Char(SYSDATE, 'YYYY-MM-DD') || '.txt', 'w', bitacora);

        escribirArchivo(bitacora, RPad('-', 100, '-'));

		    escribirArchivo(bitacora, ' TI: ' || mCliente.tipo_identificacion ||
                      ' NI:' || mCliente.numero_identificacion ||' ' ||
                      nombreCliente || ' Fecha Consulta: ' ||
                      To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'));

        escribirArchivo(bitacora, RPad('-', 100, '-'));
		    escribirArchivo(bitacora, '');
      EXCEPTION
		    WHEN errorArchivo THEN
        RETURN;
		  WHEN OTHERS THEN
		    NULL;
      END;



      escribirArchivo(bitacora,'ID_REPORTE' || ' ' ||
                               'CARGO' || ' ' ||
                               RPad('CLASE', 15, ' ') || ' ' ||
                               RPad('TIPO', 15, ' ') || ' ' ||
                               RPad('ESTADO', 15, ' ') || ' ' ||
                               --'T.I' || ' ' ||
                               --'NUM.IDENTIF' || ' ' ||
                                --RPad('NOMBRE', 40, ' ') || ' ' ||
                                RPad('F_CREA', 16, ' ') || ' ' ||
                                RPad('U_CREA', 10, ' ') || ' ' ||
                                'CONCEPTO');
      FOR miReporte IN reportes(mCliente.tipo_identificacion, mCliente.numero_identificacion) LOOP

        justificacionCompletaA := miReporte.justificacion_inicial;
        justificacionCompletaB := miReporte.justificacion_inicial_b;
        justificacionCompletaC := miReporte.justificacion_inicial_c;

        BEGIN
          SELECT NOMBRE_LARGO
          INTO descrClase
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '7'
          AND CODIGO = miReporte.codigo_clase_reporte_v;
        EXCEPTION
          WHEN No_Data_Found THEN
            descrClase := ' ';
        END;

        BEGIN
          SELECT NOMBRE_LARGO
          INTO descrTipo
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '4'
          AND CODIGO = miReporte.codigo_tipo_reporte_v;
        EXCEPTION
          WHEN No_Data_Found THEN
            descrTipo := ' ';
        END;

        BEGIN
          SELECT NOMBRE_LARGO
          INTO descrEstado
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '9'
          AND CODIGO = miReporte.codigo_estado_reporte_v;
        EXCEPTION
          WHEN No_Data_Found THEN
            descrEstado := ' ';
        END;

        formatoConcepto(justificacionCompletaA);
        formatoConcepto(justificacionCompletaB);
        formatoConcepto(justificacionCompletaC);

        escribirArchivo(bitacora, ' ');
        escribirArchivo(bitacora, RPad(miReporte.id, 10,' ') ||
                                  ' ' ||
                                  miReporte.codigo_cargo ||
                                  ' ' ||
                                  --RPad(miReporte.codigo_clase_reporte_v, 5,' ') ||
                                  RPad(descrClase, 15,' ') ||
                                  ' ' ||
                                  --RPad(miReporte.codigo_tipo_reporte_v, 4, ' ') ||
                                  RPad(descrTipo, 15, ' ') ||
                                  ' ' ||
                                  --RPad(miReporte.codigo_estado_reporte_v, 3, ' ') ||
                                  RPad(descrEstado, 15, ' ') ||
                                  ' ' ||
                                  --RPad(miReporte.tipo_identificacion, 3,' ') ||
                                  --' ' ||
                                  --RPad(miReporte.numero_identificacion, 11, ' ') ||
                                  --' ' ||
                                  --RPad(nombreCliente,40, ' ') ||
                                  --' ' ||
                                  To_Char(miReporte.fecha_creacion, 'YYYY-MM-DD HH24:MI') ||
                                  ' ' ||
                                  RPad(To_Char(miReporte.usuario_creacion), 10, ' ') ||
                                  ' ' ||
                                  justificacionCompletaA ||
                                  justificacionCompletaB ||
                                  justificacionCompletaC
                                );
        escribirArchivo(bitacora,LPad('***DETALLE DE TRANSACCIONES***', 34, ' ' ));
        escribirArchivo(bitacora,LPad(RPad('FECHA', 10, ' '), 20, ' ') ||
                                 ' ' ||
                                 'ARCHIVO' ||
                                 ' ' ||
                                 RPad('NUMERO_NEGOCIO', 20, ' ') ||
                                 ' ' ||
                                 'COD_TX' ||
                                 ' ' ||
                                 RPad('VALOR', 17, ' ') ||
                                 ' ' ||
                                 'EST_OF' ||
                                 ' ' ||
                                 'EST_DC'
                                 );

        FOR mTx IN transacciones(miReporte.id) LOOP

          SELECT NOMBRE_CORTO
          INTO nombreProducto
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '2'
          AND CODIGO = mTx.codigo_archivo;

          SELECT NOMBRE_CORTO
          INTO estadoOficina
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '11'
          AND CODIGO = mTx.estado_Oficina;

          SELECT NOMBRE_CORTO
          INTO estadoDucc
          FROM LISTA_VALORES
          WHERE TIPO_DATO = '11'
          AND CODIGO = mTx.estado_ducc;

          escribirArchivo(bitacora, LPad(To_Char(mTx.fecha, 'YYYY-MM-DD'), 20, ' ')  ||
                                    ' ' ||
                                    --RPad(To_Char(mTx.codigo_archivo), 6, ' ') ||
                                    RPad(To_Char(nombreProducto), 7, ' ') ||
                                    ' ' ||
                                    RPad(mTx.numero_negocio, 20, ' ') ||
                                    ' ' ||
                                    RPad(mTx.codigo_transaccion, 6, ' ') ||
                                    ' ' ||
                                    LPad(mTx.valor_transaccion, 17)  ||
                                    ' ' ||
                                    --RPad(mTx.estado_Oficina, 6, ' ') ||
                                    RPad(estadoOficina, 6, ' ') ||
                                    ' ' ||
                                    --mTx.estado_ducc
                                    estadoDucc);

        END LOOP;


      END LOOP;
      cerrarArchivo(bitacora);

    END LOOP;
    /* ELIMINAR REGISTRO DE CONSULTA */
    DELETE CONSULTA_DUCC;

    COMMIT;
   END consultar;

  PROCEDURE abrirArchivo          (ubicacion     IN     VARCHAR2,
                                   nombre        IN     VARCHAR2,
                                   modoApertura  IN     VARCHAR2,
		                               archivo       OUT    UTL_FILE.FILE_TYPE) IS
    errorArchivo    EXCEPTION;
  BEGIN
    BEGIN
      archivo := UTL_FILE.FOPEN(ubicacion,nombre,modoApertura,32767);
    EXCEPTION
      WHEN OTHERS THEN
			  RAISE errorArchivo;
    END;
  END abrirArchivo;


  PROCEDURE escribirArchivo       (archivo       IN OUT UTL_FILE.FILE_TYPE,
	                                 mensaje       IN     VARCHAR2) IS
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

  PROCEDURE formatoConcepto       (concepto      IN OUT VARCHAR2) IS
  BEGIN
    concepto := Trim(concepto);
    concepto := REPLACE(concepto, Chr(10),'');
    concepto := REPLACE(concepto, Chr(13),'');
  END formatoConcepto;

END PK_CONSULTA_DUCC;
/


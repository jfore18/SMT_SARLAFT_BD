PROMPT CREATE OR REPLACE PROCEDURE sp_smt_actualizacion_oficina
CREATE OR REPLACE procedure sp_smt_actualizacion_oficina(RESPUESTA OUT VARCHAR2) is
/******************************************************************************************************************************
** NOMBRE: SP_SMT_ACTUALIZACION_OFICINA
**
** PROPOSITO:
** Procedimiento almacenado encargado de actualizar el codigo de oficina  de la transacciones
** pendientes de gestionar en SMT por parte de la oficina. Es utilizado cuando una oficina cierra y
** otra asume sus negocios
** PARAMETROS DE ENTRADA
** RESPUESTA: mensaje retornado por el procedimiento almacenado con el resultado de su ejecución
**
**Construido por :ABOCANE- Ana Maria Bocanegra
**Fecha  Agosto 2020
** Requerimiento CVAPD00521520-Script SMT actualización operaciones sin calificar
***************************************************************************************************************************************/

/*DEFINICION DE VARIABLES*/

 idProceso          LOG_PROCESOS.id_proceso%TYPE;
 codProceso         LOG_PROCESOS.CODIGO_PROCESO%TYPE;
 dir_entradas       V_RUTAS_BD.descripcion%TYPE;
 archivo_entrada    V_RUTAS_BD.descripcion%TYPE;
 error              VARCHAR(200);
 usuario            LOG_PROCESOS.USUARIO%TYPE;

 descriptorArchivo  UTL_FILE.File_Type;
 codigoMensaje      NUMBER;
 registro           VARCHAR2(1000);
 finArchivo         BOOLEAN;

 nRegistros         NUMBER;
 nContador          NUMBER;
 nExisteOficina     NUMBER;
 vOficCierra        VARCHAR(4);
 vOficRecibe        VARCHAR(4);
 alerta             NUMBER;

/*DEFINICION DE CURSORES*/

 CURSOR transacc_cliente(oficina in varchar) IS
 SELECT codigo_archivo,fecha_proceso,id
 FROM transacciones_cliente
 WHERE codigo_oficina=to_number(oficina)
 AND estado_oficina='P';

begin
 /*Inicializacion de variables*/

 idProceso       := NULL;
 codProceso      := '15'; -- HOMOLOGACION OFICINAS
 dir_entradas    := 'IN'; -- DIRECTORIO DE ENTRADAS
 archivo_entrada := 'HOM'; -- ARCHIVO DE HOMOLOGACION DE OFICINAS
 nRegistros      :=  0;
 usuario         := 999999999;-- PROCESOS AUTOMATICOS
 respuesta       := 'OK-FINALIZADO. ';-- PROCESO FINALIZA CORRECTAMENTE
 alerta          :=0; -- PROCESO FINALIZA CON ALERTAS

 -- Formato de fechas DD/MM/YYYY
 EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''DD/MM/YYYY''';

 -- 1.Se registra en el log el inicio del proceso
 Pk_Lib.p_actualizar_log_procesos (idProceso,codProceso,0,usuario, NULL);

 -- 2. Se busca y se abre el archivo en la ruta respectiva
 IF dir_entradas IS NOT NULL AND archivo_entrada IS NOT NULL THEN
  Pk_Lib.f_get_dir_archivo_BD (dir_entradas, archivo_entrada);
  Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_entradas,archivo_entrada,'r',descriptorArchivo, codigoMensaje);

  IF codigoMensaje <> 0 THEN
   error := 'ER-Error al abrir el archivo:'||archivo_entrada ||'. Error' ||codigoMensaje ;
   INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)VALUES (idProceso, SYSDATE, error,usuario);
   Pk_Lib.p_actualizar_log_procesos(idProceso,codProceso,0,usuario,codigoMensaje);
   respuesta:= 'ER-Error al abrir archivo.Verifique en log_errores';
   RETURN;
  END IF;
 END IF;

 -- 3. Se recorre el archivo por liena
 LOOP
  sipcla_Operacion_Archivos.PR_LEER_LINEA(descriptorArchivo,registro,finArchivo,codigoMensaje);


  IF codigoMensaje <> 0 THEN
   error := 'ER-Error al leer linea de archivo: '||nRegistros ||'. Error'|| codigoMensaje ;
   INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)VALUES (idProceso, SYSDATE, error,usuario);
   Pk_Lib.p_actualizar_log_procesos(idProceso,codProceso,0,usuario,codigoMensaje);
   alerta:= alerta +1;
  -- respuesta:= 'AL-Alerta en lectura de registro.Verifique en log_errores';
   continue;
  END IF;

  IF finArchivo THEN
   EXIT;
  END IF;
  nRegistros := nRegistros + 1;

  -- 3.1 Seleccionamos de cada linea del archivo la oficina que cierra y la oficina que recibe las operaciones y las
  -- almacenamos en las variables vOficCierra,vOficRecibe
  BEGIN
   select
   regexp_substr(registro, '[^,]+', 1, 1),
   regexp_substr(registro, '[^,]+', 1, 2)
   into vOficCierra,vOficRecibe
   from dual;

   -- 3.2  Validaciones sobre los datos de entrada
   -- a. Validamos que la oficina que recibe las operaciones se encuentre registrada en SMT-SARLAFT y este  activa
   nExisteOficina:=0;

   SELECT COUNT(*)INTO nExisteOficina
   FROM UNIDADES_NEGOCIO
   WHERE CODIGO=to_number(vOficRecibe) AND ACTIVA='1';

   IF nExisteOficina>0 THEN
    nContador:=0;
    --b. Validamos si las oficinas leidas ya se encuentran registradas en la tabla de oficinas cerradas
    SELECT COUNT(*)INTO nContador
    FROM TBL_SMT_OFICINA_CERRADA
    WHERE OFICINA_CIERRA=to_number(vOficCierra)
    AND OFICINA_RECIBE=to_number(vOficRecibe);

    -- Si no existe adicionamos el registro en la tabla
    IF nContador=0 THEN
     INSERT INTO TBL_SMT_OFICINA_CERRADA(OFICINA_CIERRA,OFICINA_RECIBE,FECHA_REGISTRO)
     VALUES(to_number(vOficCierra),to_number(vOficRecibe),SYSDATE);
     COMMIT;
    ELSE
     -- Dejamos registro en la tabla de LOG, que el registro ya existía
     error := 'La relacion de oficinas:'|| vOficCierra ||','||vOficRecibe||'ya estaba registrada en la aplicación';
     insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,error,usuario);
     alerta:= alerta +1;
     -- respuesta:='AL-Alerta verifique en log_errores';
     commit;
    END IF;

   ELSE
    -- Oficina que recibe las operaciones no existe en SMT. Se debe salir y continuar el loop
    error := 'La Oficina '||vOficRecibe||' que recibe negocio no creada en SMT.' ;
    insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,error,usuario);
    alerta:= alerta +1;
    --respuesta:='AL-Alerta oficina inválida. Verifique en log_errores';
    commit;
    CONTINUE;
   END IF;

  -- 3.3 Seleccionamos las transacciones que se encuentran en la tabla transacciones cliente con oficina
  -- correspondiente a la oficina cerrada y cuyo estado oficina sea igual a Pendiente
  FOR cur_tr IN transacc_cliente(vOficCierra)LOOP
   UPDATE TRANSACCIONES_CLIENTE SET CODIGO_OFICINA=to_number(vOficRecibe)
   WHERE CODIGO_ARCHIVO=cur_tr.codigo_archivo
   AND FECHA_PROCESO=cur_tr.fecha_proceso
   AND ID=cur_tr.id;
   -- Registro en bitacora de la transaccion modificada
   PK_LIB.p_actualizar_log_transaccional(cur_tr.codigo_archivo,cur_tr.fecha_proceso,cur_tr.id,'Transacción actualizada por migración de oficina.Anterior:'||vOficCierra||',Nueva:'||vOficRecibe,idProceso,codProceso);
  END LOOP;

  EXCEPTION WHEN OTHERS THEN
   error := SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros;
   insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,error,usuario);
   respuesta:='ER-Error en  registro. Verifique en log_errores';
   commit;
  END;
 END LOOP;
 -- 4. Cerramos el archivo de homologacion
 sipcla_operacion_archivos.PR_CERRAR_ARCHIVO(descriptorArchivo,codigoMensaje);
 -- 5. Si el proceso termina con alertas. Retornamos el mensaje a la malla de control-m
 if alerta>0 then
   respuesta:= respuesta ||'Proceso con alertas. Revise log.';
 end if;
 -- 6. si el archivo esta vacio. Retornamos error
 if nRegistros=0 then
   insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,'Archivo vacio',usuario);
   respuesta:='ER-Error en archivo. Archivo vacio.';
 end if;
 -- 6. Se marca el fin del proceso
 Pk_Lib.p_actualizar_log_procesos (idProceso,codProceso,0,usuario, NULL);
exception when others then
  error := SUBSTR (SQLERRM,1,60);
  insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,error,usuario);
  commit;
  respuesta:='ER-Error en  proceso. Verifique en log_errores';
END SP_SMT_ACTUALIZACION_OFICINA;
/


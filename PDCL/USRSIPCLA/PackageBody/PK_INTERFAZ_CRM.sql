PROMPT CREATE OR REPLACE PACKAGE BODY pk_interfaz_crm
CREATE OR REPLACE PACKAGE BODY pk_interfaz_crm
IS
   /* Genera en el directorio de salidas de la base de datos, un archivo con
      los tipos y números de indentificación de todos los clientes cargados en
	  SIPCLA durante la carga de transacciones.
	  Los nombres del directorio de salidas y del archivo se leen de la vista
	  V_RUTAS_BD.
   */
   PROCEDURE p_crear_archivo_clientes (cedulaUsuario IN USUARIO.cedula%TYPE) IS

   	   CURSOR cur_clientes IS
         SELECT DISTINCT tipo_identificacion, numero_identificacion
	       FROM TRANSACCIONES_CLIENTE
	      WHERE nueva = 1; --ADD nueva=1 CPB 06AGO2004

	   idProceso          LOG_PROCESOS.id_proceso%TYPE := NULL;
	   dir_salidas        V_RUTAS_BD.descripcion%TYPE  := 'OUT';
	   archivo_salida     V_RUTAS_BD.descripcion%TYPE  := 'OCL';
	   descriptorArchivo  UTL_FILE.File_Type;
	   codigoMensaje      NUMBER;
	   totalRegistros     NUMBER := 0;
       error              VARCHAR2(200);
   BEGIN
       Pk_Lib.p_actualizar_log_procesos (idProceso, '3', NULL, cedulaUsuario, NULL);
       Pk_Lib.f_get_dir_archivo_BD (dir_salidas, archivo_salida);
	   IF dir_salidas IS NOT NULL AND archivo_salida IS NOT NULL THEN
           Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_salidas, --'D:\salidas\siscla',
                                                      archivo_salida, --'CLIENTES.txt',
                                                      'w',
                                                      descriptorArchivo,
                                                      codigoMensaje);
           BEGIN
	           FOR reg_cliente IN cur_clientes LOOP
		           Sipcla_Operacion_Archivos.PR_ESCRIBIR_LINEA(descriptorArchivo,
	                                                      reg_cliente.tipo_identificacion || ',' ||
						    							  reg_cliente.numero_identificacion,
	                                                      codigoMensaje);
			       totalRegistros := totalRegistros + 1;
		       END LOOP;
	       EXCEPTION WHEN OTHERS THEN
	           codigoMensaje := SQLCODE;
		       error := SUBSTR(SQLERRM,1,200);
			   INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
			                    VALUES (idProceso, SYSDATE, error, cedulaUsuario );
			   COMMIT;
	       END;
           Sipcla_Operacion_Archivos.PR_CERRAR_ARCHIVO(descriptorArchivo,
	                                               codigoMensaje);
	   END IF;
       Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, totalRegistros, NULL, codigoMensaje);
   END p_crear_archivo_clientes;
   /* Lee del directorio de entradas de la base de datos, el archivo con la
      información demográfica de clientes devuelto por CRM.
	  Los nombres del directorio de entradas y del archivo se leen de la vista
	  V_RUTAS_BD.
   */
   PROCEDURE p_obtener_datos_clientes ( archivoCargue IN  VARCHAR2, --IMAM 2006-08-23
                                        tipoProceso   IN  VARCHAR2,  --IMAM 2006-08-23
                                        cedulaUsuario IN  USUARIO.cedula%TYPE,
                                        mensaje       OUT VARCHAR2) --IMAM 2006-08-23
                                        IS
	   idProceso          LOG_PROCESOS.id_proceso%TYPE := NULL;
	   dir_entradas       V_RUTAS_BD.descripcion%TYPE := 'IN';
	   --archivo_entrada    V_RUTAS_BD.descripcion%TYPE := 'ICL'; rem IMAM 2006-08-23
    archivo_entrada    V_RUTAS_BD.descripcion%TYPE; --IMAM 2006-08-23
	   descriptorArchivo  UTL_FILE.File_Type;
	   codigoMensaje      NUMBER;
       registro           VARCHAR2(1000);
       finArchivo         BOOLEAN;
	   nRegistros    NUMBER := 0;
	   contCommit    NUMBER := 0;
       error         LOG_ERRORES.error%TYPE;--VARCHAR2(200);
   BEGIN
       --Pk_Lib.p_actualizar_log_procesos (idProceso, '4', NULL, cedulaUsuario, NULL); IMAM 2006-08-23
     Pk_Lib.p_actualizar_log_procesos (idProceso, tipoProceso, NULL, cedulaUsuario, NULL); --IMAM 2006-08-23
     archivo_entrada    := archivoCargue; --IMAM 2006-08-23
	   IF dir_entradas IS NOT NULL AND archivo_entrada IS NOT NULL THEN
           Pk_Lib.f_get_dir_archivo_BD (dir_entradas, archivo_entrada);

           Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_entradas, --'D:\ENTRADAS\SISCLA',
                                                      archivo_entrada, --'ArchSIPCLA.TXT',
                                                      'r',
                                                      descriptorArchivo,
                                                      codigoMensaje);
           IF codigoMensaje <> 0 THEN --IMAM 2006-08-23
            error := 'El archivo de Megabanco no se encuentra, por favor verifique' ;
			       INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
			                    VALUES (idProceso, SYSDATE, error , cedulaUsuario);
             Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, nRegistros, NULL, codigoMensaje);
             mensaje := error;
             RETURN;
           END IF;
           LOOP
               Sipcla_Operacion_Archivos.PR_LEER_LINEA(descriptorArchivo,
                                                       registro,
    			                                       finArchivo,
                                                       codigoMensaje);
               IF codigoMensaje <> 0 THEN
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
	               p_grabar_datos_cliente (registro, idProceso);
			       contCommit := contCommit + 1;
			       nRegistros := nRegistros + 1;
		   	       IF contCommit > 50 THEN
			           contCommit := 0;
				       COMMIT;
			       END IF;
               EXCEPTION WHEN OTHERS THEN --ADD CPB 21MAY2004 Manejo de excepción
			       error := SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros || ': '|| SUBSTR(registro,1,120);
			       INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
			                    VALUES (idProceso, SYSDATE, error , cedulaUsuario);
			       COMMIT;
               END;
	       END LOOP;
	       COMMIT;
           Sipcla_Operacion_Archivos.PR_CERRAR_ARCHIVO(descriptorArchivo,
                                                       codigoMensaje);
     END IF;
       Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, nRegistros, NULL, codigoMensaje);
       mensaje := 'El proceso terminó exitosamente';
   END p_obtener_datos_clientes;
   /* Inserta o actualiza en la tabla CLIENTES, la información demográfica de
      un cliente entregada por CRM.
	  El procedimiento o función que la invoque es responsable de ejecutar COMMIT.
   */
   PROCEDURE p_grabar_datos_cliente (regCliente VARCHAR2, idProceso LOG_PROCESOS.id_proceso%TYPE) IS
       idClienteExiste CLIENTES.numero_identificacion%TYPE;
       tipoId          CLIENTES.tipo_identificacion%TYPE;
       numeroId        CLIENTES.numero_identificacion%TYPE;
       codCIIU         CLIENTES.codigo_actividad_economica%TYPE;
       codSegmento     CLIENTES.codigo_segmento_comercial%TYPE;
       nombreCliente   CLIENTES.nombre_razon_social%TYPE;
       tipoTelefono    CLIENTES.tipo_telefono%TYPE;
       nTelefono       CLIENTES.telefono%TYPE;
       esNegativo      CLIENTES.negativo%TYPE;
       esPeps          CLIENTES.peps%TYPE;
       granContrib     CLIENTES.gran_contribuyente%TYPE;
	   tipoEmpresa	   CLIENTES.tipo_empresa%TYPE;
	   codigoActividad ACTIVIDAD_ECONOMICA.codigo%TYPE;
	   codigoSegmento  SEGMENTOS_COMERCIALES.codigo%TYPE;
	   mensaje_error   LOG_ERRORES.error%TYPE;
   BEGIN
       tipoId        := TRIM(SUBSTR(regCliente,1,1));
       numeroId      := TRIM(SUBSTR(regCliente,2,11));
       codCIIU       := TRIM(SUBSTR(regCliente,84,4));
       codSegmento   := TO_NUMBER(SUBSTR(regCliente,88,3));
       nombreCliente := TRIM(SUBSTR(regCliente,13,40));
       tipoTelefono  := TRIM(SUBSTR(regCliente,53,2));
       nTelefono     := TRIM(SUBSTR(regCliente,55,29));
/*       telefono      := SUBSTR(regCliente,56,3) || TRIM(SUBSTR(regCliente,64,20)) ||
	                    TRIM(SUBSTR(regCliente,84,6));*/
       esNegativo    := TO_NUMBER(SUBSTR(regCliente,91,1));
       esPeps        := TO_NUMBER(SUBSTR(regCliente,92,1));
	   tipoEmpresa   := SUBSTR(regCliente,94,1);
       IF SUBSTR(regCliente,93,1) = 'Y' THEN
	       granContrib := 1;
       ELSE
	       granContrib := 0;
       END IF;
	   BEGIN
           SELECT codigo
             INTO codigoActividad
             FROM ACTIVIDAD_ECONOMICA
            WHERE codigo = codCIIU;
	   EXCEPTION WHEN NO_DATA_FOUND THEN
	       mensaje_error := 'La actividad económica '||codCIIU ||' no existe. Cliente:'||tipoId||'-'||numeroId;
		   INSERT INTO LOG_ERRORES (id_proceso,  fecha, error, USUARIO)
			                VALUES (idProceso, SYSDATE, mensaje_error, 0);
		   codCIIU := '9999';
		   --COMMIT;no hacer commit aquí
	   END;
	   BEGIN
           SELECT codigo
             INTO codigoSegmento
             FROM SEGMENTOS_COMERCIALES
            WHERE codigo = codSegmento;
	   EXCEPTION WHEN NO_DATA_FOUND THEN
	       mensaje_error := 'El segmento comercial '||codSegmento||' no existe. Cliente:'||tipoId||'-'||numeroId;
		   INSERT INTO LOG_ERRORES (id_proceso,  fecha, error, USUARIO)
			                VALUES (idProceso, SYSDATE, mensaje_error, 0);
		   codSegmento := 0;
		   --COMMIT;no hacer commit aquí
	   END;
       SELECT numero_identificacion
         INTO idClienteExiste
         FROM CLIENTES
        WHERE tipo_identificacion = tipoId
          AND numero_identificacion = numeroId;
       UPDATE CLIENTES
          SET codigo_actividad_economica = codCIIU,
              codigo_segmento_comercial  = codSegmento,
              nombre_razon_social   =  nombreCliente,
              tipo_telefono         =  tipoTelefono,
              telefono              =  nTelefono,
              negativo              =  esNegativo,
              peps                  =  esPeps,
              gran_contribuyente    =  granContrib,
              tipo_empresa          =  tipoEmpresa,
              fecha_actualizacion   =  SYSDATE
        WHERE tipo_identificacion   =  tipoId
          AND numero_identificacion =  numeroId;
       EXCEPTION WHEN NO_DATA_FOUND THEN
	       --BEGIN
               INSERT INTO CLIENTES (tipo_identificacion,       numero_identificacion,  codigo_actividad_economica,
                                     codigo_segmento_comercial, nombre_razon_social,    tipo_telefono,
                                     telefono,                  negativo,               peps,
                                     gran_contribuyente,        vigilado_superbancaria, tipo_empresa,
                                     fecha_actualizacion)
                             VALUES (tipoId,      numeroId,      codCIIU,
                                     codSegmento, nombreCliente, tipoTelefono,
                                     nTelefono,   esNegativo,    esPeps,
                                     granContrib, 0,             tipoEmpresa,
                                     SYSDATE);
           --EXCEPTION WHEN OTHERS THEN
			--   INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)
			--                    VALUES (0, SYSDATE, 'Error al insertar el registro. TIPOID: '||tipoId||'  NUMEROID: '||numeroId, 0);
			--   COMMIT;
           --END;
   END p_grabar_datos_cliente;
END;
/


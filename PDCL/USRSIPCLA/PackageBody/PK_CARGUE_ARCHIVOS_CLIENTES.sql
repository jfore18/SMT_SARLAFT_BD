PROMPT CREATE OR REPLACE PACKAGE BODY pk_cargue_archivos_clientes
CREATE OR REPLACE PACKAGE BODY pk_cargue_archivos_clientes
IS
   /*
	  Los nombres del directorio de entradas y de los archivos de carga,
	  corresponden con los códigos definidos en la vista V_RUTAS_BD.
	  Los tipos de entidad corresponden con los códigos definidos en la vista
      V_TIPO_ENTIDAD. Estos códigos corresponden con la posición ocupada en la
	  cadena de caracteres ENTIDADES_EXCLUIDAS.FLAGS_TIPOS (e.g., código 1
	  [Vig. Super.] posición 1; código 2 [Gran Contrib.]) posición 2, etc.).
      Este procedimiento es el que debe invocarse desde la página JSP.
   */
   PROCEDURE p_cargar_entidad_excluida (tipoEntidad   IN  LISTA_VALORES.codigo%TYPE,
                                        cedulaUsuario IN  USUARIO.cedula%TYPE,
										codigoMensaje OUT LOG_ARCHIVOS.codigo_mensaje%TYPE) IS --ADD CPB 29JUN2004

	   idProceso          LOG_PROCESOS.id_proceso%TYPE := NULL;
	   dir_entradas       V_RUTAS_BD.descripcion%TYPE := 'ISD'; --Todos los archivos en el mismo directorio
	   archivo_entrada    V_RUTAS_BD.descripcion%TYPE;
	   descriptorArchivo  UTL_FILE.File_Type;
       registro           VARCHAR2(500);
       finArchivo         BOOLEAN;
	   nRegistros         NUMBER := 0;
	   contCommit         NUMBER := 0;
       error              LOG_ERRORES.error%TYPE;
   BEGIN
       Pk_Lib.p_actualizar_log_procesos (idProceso, '6', NULL, cedulaUsuario, NULL);

	   IF tipoEntidad = '1'    THEN -- Entidad Vigilada por la Superbancaria
	       archivo_entrada := 'ISA';
	   ELSIF tipoEntidad = '2' THEN -- Gran Contribuyente
	       archivo_entrada := 'IGC';
	   ELSIF tipoEntidad = '3' THEN -- Oficial
	       archivo_entrada := 'IOF';
	   ELSE
           Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, 0, NULL, codigoMensaje);
	       RETURN;
	   END IF;

	   IF dir_entradas IS NOT NULL AND archivo_entrada IS NOT NULL THEN
           Pk_Lib.f_get_dir_archivo_BD (dir_entradas, archivo_entrada);
           Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_entradas,
                                                      archivo_entrada,
                                                      'r',
                                                      descriptorArchivo,
                                                      codigoMensaje);
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
	               --p_insertar_cliente (registro, idProceso);
				   p_grabar_entidad_excluida(registro, tipoEntidad, idProceso);
			       contCommit := contCommit + 1;
			       nRegistros := nRegistros + 1;
		   	       IF contCommit > 50 THEN
			           contCommit := 0;
				       COMMIT;
			       END IF;
               EXCEPTION WHEN OTHERS THEN
			       error := SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros || ': '|| SUBSTR(registro,1,100);
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
   END p_cargar_entidad_excluida;


   /* Inserta o actualiza en la tabla ENTIDADES_EXCLUIDAS, los datos suministrados
      a partir de un archivo plano.
	  El procedimiento o función que lo invoque es responsable de ejecutar COMMIT.
   */
   PROCEDURE p_grabar_entidad_excluida (regEntidad  IN VARCHAR2,
                                        tipoEntidad IN LISTA_VALORES.codigo%TYPE,
                                        idProceso   IN LOG_PROCESOS.id_proceso%TYPE) IS

       tipoId       ENTIDADES_EXCLUIDAS.tipo_identificacion%TYPE;
       numeroId     ENTIDADES_EXCLUIDAS.numero_identificacion%TYPE;
       nombre       ENTIDADES_EXCLUIDAS.nombre%TYPE;
       flagsTipos   ENTIDADES_EXCLUIDAS.flags_tipos%TYPE := '00000000';
	   posicion     NUMBER;
   BEGIN

       IF tipoEntidad IS NOT NULL THEN
           posicion := TO_NUMBER(tipoEntidad);
       ELSE
           RETURN;
       END IF;

       tipoId   := TRIM(SUBSTR(regEntidad,  1, 1 ));
       numeroId := TRIM(SUBSTR(regEntidad,  2, 11));
	   nombre   := TRIM(SUBSTR(regEntidad, 13, 40));

       SELECT flags_tipos
         INTO flagsTipos
         FROM ENTIDADES_EXCLUIDAS
        WHERE tipo_identificacion = tipoId
          AND numero_identificacion = numeroId;

       flagsTipos :=   SUBSTR(flagsTipos,1,posicion-1)
                    || '1'
                    || SUBSTR(flagsTipos,posicion+1);

       UPDATE ENTIDADES_EXCLUIDAS
          SET flags_tipos = flagsTipos,
		      fecha_actualizacion = SYSDATE
        WHERE tipo_identificacion   =  tipoId
          AND numero_identificacion =  numeroId;

       EXCEPTION WHEN NO_DATA_FOUND THEN

           flagsTipos :=   SUBSTR(flagsTipos,1,posicion-1)
                        || '1'
                        || SUBSTR(flagsTipos,posicion+1);

           INSERT INTO ENTIDADES_EXCLUIDAS (tipo_identificacion,
                                            numero_identificacion,
                                            flags_tipos,
                                            obligar_carga,
                                            nombre,
                                            fecha_actualizacion)
                                    VALUES (tipoId,
                                            numeroId,
                                            flagsTipos,
                                            0,
                                            nombre,
                                            SYSDATE);
   END p_grabar_entidad_excluida;

END;
/


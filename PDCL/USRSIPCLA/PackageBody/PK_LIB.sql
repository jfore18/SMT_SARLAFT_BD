PROMPT CREATE OR REPLACE PACKAGE BODY pk_lib
CREATE OR REPLACE PACKAGE BODY pk_lib IS
/******************************************************************************************************************************
** NOMBRE: PK_LIB
**
** PROPOSITO: definicion de procedimientos y funciones generales para ser utilizados en los programas de sarlaft
***************************************************************************************************************************************/

/*  1. f_get_dir_archivo_BD:
    Retorna la ruta completa del directorio y archivo cuyo códigos recibe
	  como argumento y que deben corresponder con los definidos en la
	  vista V_RUTAS_BD.
	  Los directorios especificados en V_RUTAS_BD deben corresponder con las
	  rutas de entrada y salida configuradas para la base de datos (archivo INI
	  correspondiente).
*/

PROCEDURE f_get_dir_archivo_BD (codDir IN OUT VARCHAR2, codArchivo IN OUT VARCHAR2) IS

BEGIN
 SELECT dir.descripcion,archivo.descripcion
 INTO codDir, codArchivo
 FROM V_RUTAS_BD  dir,V_RUTAS_BD  archivo
 WHERE dir.codigo     = codDir
 AND archivo.codigo = codArchivo;

EXCEPTION WHEN NO_DATA_FOUND THEN
 codDir     := NULL;
 codArchivo := NULL;

END f_get_dir_archivo_BD;


/* 2. p_actualizar_log_procesos:
   Inserta o actualiza la tabla LOG_PROCESOS dependiendo del valor pasado en el
   parámetro idProceso (si es 0 o null, crea un nuevo registro; de lo contrario
	 actualiza el registro existente con el ID suministrado)
	 Los valores válidos para el parámetro 'codProceso' se pueden consultar en la
	 vista V_PROCESOS.
*/
PROCEDURE p_actualizar_log_procesos(idProceso      IN OUT LOG_PROCESOS.id_proceso%TYPE,
                                    codProceso     LOG_PROCESOS.codigo_proceso%TYPE,
                                    regsProcesados LOG_PROCESOS.registros_procesados%TYPE,
                                    cedulaUsuario  LOG_PROCESOS.USUARIO%TYPE,
                                    codMensaje     LOG_PROCESOS.codigo_mensaje%TYPE) IS
BEGIN
 IF idProceso IS NULL OR idProceso = 0 THEN

  SELECT seq_proceso.NEXTVAL INTO idProceso FROM dual;

  INSERT INTO LOG_PROCESOS
  (id_proceso,codigo_proceso,fecha_hora_inicio,fecha_hora_fin,
   registros_procesados,USUARIO,codigo_mensaje)
   VALUES (idProceso,codProceso,SYSDATE,NULL,0,cedulaUsuario,NULL);
 ELSE
  UPDATE LOG_PROCESOS
	SET fecha_hora_fin       = SYSDATE,
	registros_procesados     = regsProcesados,
	codigo_mensaje           = codMensaje
	WHERE id_proceso         = idProceso;
 END IF;
 COMMIT;
END p_actualizar_log_procesos;


/*3. p_insertar_mensaje:
  Actualiza la tabla de mensajes con posibles mensajes de error
  producidos por la falla de un procedimiento.
*/

PROCEDURE p_insertar_mensaje(codMensaje NUMBER, mensaje VARCHAR2) IS

cod MENSAJES.codigo%TYPE;
BEGIN
 SELECT codigo
 INTO cod
 FROM MENSAJES
 WHERE codigo = codMensaje;

EXCEPTION WHEN NO_DATA_FOUND THEN
 INSERT INTO MENSAJES (codigo, descripcion)
 VALUES (codMensaje, mensaje);
 COMMIT;
END;

/*4. p_actualizar_log_transaccional:
  Inserta log  sobre los eventos realizados sobre las transacciones de la tabla transacciones_cliente
  Ana María Bocanegra
  Agosto 2020
*/
PROCEDURE p_actualizar_log_transaccional(codArchivo  in log_transaccional.codigo_archivo%type,
                                         fechaProc   in log_transaccional.fecha_proceso%type,
                                         idTrans     in log_transaccional.id_transaccion%type,
                                         detalleReg  in log_transaccional.detalle%type,
                                         idenProceso in log_transaccional.id_proceso%type,
                                         codProceso  in log_transaccional.codigo_proceso%type)is
fecha_sistema varchar(20);
hora_sistema varchar(20);
secuencia log_transaccional.secuencia%type;
detalle log_transaccional.detalle%type;

BEGIN
 --1. Obtenemos secuencia de bitacora
 SELECT seq_log_transaccional.NEXTVAL INTO secuencia FROM dual;
 --2. Obtenemos fecha sistema
 SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') INTO FECHA_SISTEMA FROM DUAL;
 --3. Obtenemos la hora del sistema
 SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') INTO HORA_SISTEMA FROM DUAL;
 --4. Delimitamos el campo detalle para que no sobrepase los 100 caracteres
 IF (LENGTH (detalleReg) > 100) THEN
  detalle := SUBSTR(detalleReg, 1, 100);
 else
  detalle:= detalleReg;
 END IF;
 --5. Insertamos el registro
 INSERT INTO LOG_TRANSACCIONAL(SECUENCIA,FECHA_SISTEMA,HORA_SISTEMA,CODIGO_ARCHIVO,FECHA_PROCESO,ID_TRANSACCION,DETALLE,ID_PROCESO,CODIGO_PROCESO)
 VALUES(secuencia,TO_DATE(FECHA_SISTEMA,'DD/MM/YYYY'), TO_DATE(HORA_SISTEMA,'DD/MM/YYYY HH24:MI:SS'),codArchivo,fechaProc,idTrans,detalle,idenProceso,codProceso);
 COMMIT;
END;

/*6.f_get_arreglo:
  Convierte la cadena de caracteres suministrada como parámetro en un arreglo de cadenas, discriminando
  cada subíndice teniendo en cuenta el caracter definido como SEPARADOR.
*/
FUNCTION  f_get_arreglo (lista_multiple VARCHAR2) RETURN tab_arreglo IS

SEPARADOR CONSTANT CHAR := ',';
arreglo   tab_arreglo;
posicion  NUMBER;
i         NUMBER := 1;
cadena    VARCHAR2(500) := lista_multiple;

BEGIN
 posicion := INSTR(cadena, SEPARADOR);
  WHILE (posicion > 0) LOOP
   arreglo(i) :=  SUBSTR (cadena, 1, posicion-1);
	 cadena     :=  SUBSTR (cadena, posicion+1);
	 posicion   :=  INSTR  (cadena, SEPARADOR);
	 i := i+1;
	END LOOP;
	arreglo(i) :=  SUBSTR (cadena, 1);
  RETURN arreglo;
END f_get_arreglo;


/*7.f_valor_existe_en_arreglo:
  Verifica si la cadena suministrada coo primer argumento,
  existe en el arreglo pasado como segundo argumento.
*/
FUNCTION  f_valor_existe_en_arreglo (valor VARCHAR2, arreglo tab_arreglo) RETURN BOOLEAN IS
i NUMBER := 1;
error VARCHAR2(100);
retorno BOOLEAN := FALSE;

BEGIN
 WHILE (i > 0) LOOP
  BEGIN
   IF arreglo(i) = valor THEN
	  retorno := TRUE;
		EXIT;
	 END IF;
	 i := i + 1;
	EXCEPTION WHEN NO_DATA_FOUND THEN
	 EXIT;
	END;
 END LOOP;
 RETURN retorno;
END f_valor_existe_en_arreglo;


/*8.f_valor_en_lista_multiple:
  Verifica si el valor suministrado como primer argumento existe dentro de la
  lista de cadenas suministrada como segundo argumento. La lista múltiple debe
  ser una cadena de cadenas separadas por coma.
*/
FUNCTION f_valor_en_lista_multiple (valor VARCHAR2, lista_multiple VARCHAR2) RETURN BOOLEAN IS
retorno BOOLEAN := FALSE;
arreglo tab_arreglo;
BEGIN
 arreglo := f_get_arreglo (lista_multiple);
 retorno := f_valor_existe_en_arreglo (valor, arreglo);
 RETURN retorno;
END f_valor_en_lista_multiple;


/*9.f_get_perfil_cargo:
    Retorna el código del perfil correspondiente al cargo suministrado como
    argumento.
*/
FUNCTION f_get_perfil_cargo (codigoCargo CARGOS.codigo%TYPE) RETURN NUMBER IS
codPerfil  CARGOS.codigo_perfil_v%TYPE := NULL;
BEGIN
 BEGIN
  SELECT codigo_perfil_v
  INTO codPerfil
  FROM CARGOS
  WHERE codigo = codigoCargo;
 EXCEPTION WHEN NO_DATA_FOUND THEN
  codPerfil := ' ';
 END;
 RETURN codPerfil;
END f_get_perfil_cargo;
END;
/


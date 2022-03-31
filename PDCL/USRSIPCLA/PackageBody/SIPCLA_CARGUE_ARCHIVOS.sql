PROMPT CREATE OR REPLACE PACKAGE BODY sipcla_cargue_archivos
CREATE OR REPLACE PACKAGE BODY sipcla_cargue_archivos IS
-- Autor:Yolanda Leguizamon L.  - Banco de Bogota
-- Fecha:Enero 15 de 2004
-- Modifica:
-- Fecha:
-- Descripcion: Realiza cargue de archivos de aplicaciones
PROCEDURE PR_LOG_CARGUE(Pv_usuario                     IN     NUMBER,
                        Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                        Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                        Pn_TotalRegistrosReportados    IN OUT LOG_ARCHIVOS.REGISTROS_REPORTADOS%TYPE,
                        Pn_TotalRegistrosProcesados    IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                        Pd_CodigoMensaje               IN OUT NUMBER) IS

BEGIN
  BEGIN
    SELECT TO_NUMBER(SUBSTR(registro,2,7))
    INTO  Pn_totalRegistrosReportados
    FROM CARGUE_TOTAL
    WHERE SUBSTR(registro,1,1) = '9'
    AND   fecha_proceso        = Pd_FechaProceso
    AND   codigo_archivo       = Pn_Codigo;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      Pn_totalRegistrosReportados  := 0;
    WHEN OTHERS THEN
      Pn_totalRegistrosReportados  := 0;
  END;

/*******************************************************************************
 * Modifica: Mauricio Zuluaga
 * Fecha:    08/07/2009
 * Descripcion: Conocer la cantidad de registros reportados por Clementine
 * ****************************************************************************/
  BEGIN
    SELECT COUNT(1)
    INTO Pn_totalRegistrosReportados
    FROM cargue_total
    WHERE fecha_proceso   = Pd_FechaProceso
    AND   codigo_archivo  = Pn_Codigo;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      Pn_totalRegistrosReportados  := 0;
    WHEN OTHERS THEN
      Pn_totalRegistrosReportados  := 0;
  END;
/* Fin Modificacion */

  BEGIN
    INSERT INTO LOG_ARCHIVOS
      (codigo_archivo
       , fecha_proceso
       , codigo_mensaje
       , registros_reportados
       , registros_procesados
       , usuario_creacion
       , fecha_creacion
      )
    VALUES
      (Pn_Codigo
       , Pd_FechaProceso
       , Pd_CodigoMensaje
       , Pn_TotalRegistrosReportados
       , Pn_TotalRegistrosProcesados
       , Pv_usuario
       , SYSDATE
      );
  EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    BEGIN
      UPDATE LOG_ARCHIVOS
      SET codigo_mensaje      = Pd_CodigoMensaje
      , registros_reportados  = Pn_TotalRegistrosReportados
      , registros_procesados  = Pn_TotalRegistrosProcesados
      WHERE fecha_proceso = Pd_FechaProceso
      AND codigo_archivo  = Pn_Codigo;
    END;
  END;
  COMMIT;
END PR_LOG_CARGUE;

PROCEDURE PR_CARGUE(Pd_FechaProceso             IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                    Pv_Registro                 IN     VARCHAR2,
                    Pn_Codigo                   IN     ARCHIVOS.CODIGO%TYPE,
                    Pn_TotalRegistrosProcesados IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                    Pd_CodigoMensaje            IN OUT NUMBER) IS

  registro  VARCHAR2(2000); --IMAM 2004/07/14
  esEntidad BOOLEAN;--IMAM 2004/07/26

BEGIN
  registro := SUBSTR(Pv_registro,1,2000); --IMAM 2004/07/14
  IF SUBSTR(registro,1,1) = '1'
    AND (validarEntidadExcluida(registro, Pn_Codigo)
          OR validarOficinaInactiva(registro, Pn_Codigo))  --CPB 02AGO2004
      THEN
-- No hace nada, porque el cliente es entidad vigilada y no se debe cargar la transacción IMAM 2004/07/26
        RETURN;
  ELSE
    Pn_TotalRegistrosProcesados := Pn_TotalRegistrosProcesados + 1;
    BEGIN
      IF SUBSTR(registro,1,1) = '1' THEN
        validarTipoTransaccion(registro, Pn_Codigo);
      END IF;
      registro := REPLACE(registro,CHR(39),CHR(124)); --IMAM 2004/07/14
      INSERT INTO CARGUE_TOTAL
        (fecha_proceso
         , codigo_archivo
         , secuencia_transaccion
         , registro
        )
      VALUES
        (Pd_FechaProceso
         , Pn_Codigo
         , Pn_TotalRegistrosProcesados
         , -- SUBSTR(Pv_registro,1,2000));  --IMAM 2004/07/14
           registro); --IMAM 2004/07/14 antes iba SUBSTR(Pv_registro,1,2000)
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
      BEGIN
        UPDATE CARGUE_TOTAL
        --  SET    REGISTRO               = SUBSTR(Pv_registro,1,2000) --IMAM 2004/07/14
        SET REGISTRO = registro  --IMAM 2004/07/14
        WHERE  fecha_proceso         = Pd_FechaProceso
        AND   codigo_archivo         = Pn_Codigo
        AND   secuencia_transaccion  = Pn_TotalRegistrosProcesados;
      END;
    END;
  END IF;
END PR_CARGUE;

PROCEDURE PR_ARCHIVO_EN_SERVIDOR (Pv_usuario                  IN     NUMBER,
                                  Pd_FechaProceso             IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                                  Pv_UbicacionEntrada         IN     ARCHIVOS.UBICACION%TYPE,
                                  Pv_ArchivoDatos             IN     ARCHIVOS.NOMBRE%TYPE,
                                  Pn_Codigo                   IN     ARCHIVOS.CODIGO%TYPE,
                                  Pv_TablaDetalle             IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                                  Pn_TotalRegistrosReportados IN OUT LOG_ARCHIVOS.REGISTROS_REPORTADOS%TYPE,
                                  Pn_TotalRegistrosProcesados IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                                  Pd_CodigoMensaje            OUT    NUMBER) IS

  Lv_Mensaje            VARCHAR2(250);
  Lt_DescriptorArchivo  Utl_File.File_Type;
  Lv_Registro           VARCHAR2(2000);
  -- Variables BOOLEAN
  Lb_FinArchivo         BOOLEAN;

BEGIN
  Sipcla_Operacion_Estructuras.PR_BORRA_TABLA_FECHA(Pd_FechaProceso, Pn_Codigo, 'CARGUE_TOTAL', Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;
--Se abre el archivo fuente de información que se encuentra en el servidor
  Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(Pv_UbicacionEntrada, Pv_ArchivoDatos, 'r', Lt_DescriptorArchivo, Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;
-- Recorre el archivo, valida e inserta en la tabla.
-- Se inicializan las variables temporales de los registros
  LOOP
--Capturar una linea del archivo
    Sipcla_Operacion_Archivos.PR_LEER_LINEA(Lt_DescriptorArchivo, Lv_Registro, Lb_FinArchivo, Pd_CodigoMensaje);

    IF Pd_CodigoMensaje <> 0 THEN
      RETURN;
    END IF;
--Si es fin del archivo se sale del loop
    IF Lb_FinArchivo THEN
      EXIT;
    END IF;
--Si la linea capturada es nula se origina un mensaje de error
    IF Lv_Registro IS NULL OR LTRIM(Lv_Registro) IS NULL THEN
      Pd_CodigoMensaje:= 483;
      RETURN;
    END IF;
-- Valida el registro y los ingresa a la tabla correspondiente
    Sipcla_Cargue_Archivos.PR_CARGUE(Pd_FechaProceso, Lv_Registro, Pn_Codigo, Pn_TotalRegistrosProcesados, Pd_CodigoMensaje);
  END LOOP;

  Sipcla_Operacion_Archivos.PR_CERRAR_ARCHIVO(Lt_DescriptorArchivo, Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;

END PR_ARCHIVO_EN_SERVIDOR;

PROCEDURE PR_AUTOMATIZACION_PROCESOS (Pn_codigo_tipo_archivo IN  NUMBER,
                                      Pn_codigo_producto     IN  NUMBER,
                                      Pv_fecha_archivo       IN  VARCHAR2,
                                      Pv_usuario             IN  NUMBER,
                                      Pd_CodigoMensaje       OUT NUMBER) IS

--  Lv_NombreArchivo        ARCHIVOS.NOMBRE%TYPE; --IMAM
  Lv_NombreArchivo        VARCHAR2(50); --IMAM
  Lv_TablaDetalle         ARCHIVOS.TABLA_DETALLE%TYPE;
  Lv_UbicacionEntrada     ARCHIVOS.UBICACION%TYPE;
  Ln_Codigo               ARCHIVOS.CODIGO%TYPE;
  Ld_FechaProceso         CONTROL_ENTIDAD.FECHA_PROCESO%TYPE;
  Ln_RegistrosReportados  LOG_ARCHIVOS.REGISTROS_REPORTADOS%TYPE := 0;
  Ln_RegistrosProcesados  LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE := 0;
  idProceso               LOG_PROCESOS.id_proceso%TYPE := NULL;  --ADD CPB 11AGO2004

BEGIN

  BEGIN
    SELECT fecha_proceso
    INTO Ld_FechaProceso
    FROM CONTROL_ENTIDAD;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    Ld_FechaProceso := SYSDATE;
  END;

  BEGIN
    SELECT nombre
    , ubicacion
    , codigo
    , tabla_detalle
    INTO Lv_NombreArchivo
    , Lv_UbicacionEntrada
    , Ln_Codigo
    , Lv_TablaDetalle
    FROM ARCHIVOS
    WHERE CODIGO_TIPO_ARCHIVO = Pn_codigo_tipo_archivo
    AND   CODIGO_PRODUCTO_V   = Pn_codigo_producto;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    Pd_CodigoMensaje :=  385;
    RETURN;
  END;

  IF Lv_UbicacionEntrada IS NULL THEN
    Pd_CodigoMensaje :=  900;
    RETURN;
  END IF;

  Pk_Lib.p_actualizar_log_procesos(idProceso, '1', NULL, Pv_usuario, NULL);--ADD CPB 11AGO2004
  Ln_RegistrosProcesados := 0;
  Lv_NombreArchivo       := Lv_NombreArchivo || Pv_fecha_archivo || '.txt';

  Sipcla_Cargue_Archivos.PR_ARCHIVO_EN_SERVIDOR(Pv_usuario
                                                , Ld_FechaProceso
                                                , Lv_UbicacionEntrada
                                                , Lv_NombreArchivo
                                                , Ln_Codigo
                                                , Lv_TablaDetalle
                                                , Ln_RegistrosReportados
                                                , Ln_RegistrosProcesados
                                                , Pd_CodigoMensaje);

  Sipcla_Cargue_Archivos.PR_LOG_CARGUE (Pv_usuario
                                        , Ld_FechaProceso
                                        , Ln_Codigo
                                        , Ln_RegistrosReportados
                                        , Ln_RegistrosProcesados
                                        , Pd_CodigoMensaje);

  Sipcla_Parte_Archivos.PR_PROCESA_ARCHIVO (Pv_usuario
                                            , Ld_FechaProceso
                                            , Ln_Codigo
                                            , Lv_TablaDetalle
                                            , Pd_CodigoMensaje);

  Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, Ln_RegistrosProcesados, NULL, Pd_CodigoMensaje);

END PR_AUTOMATIZACION_PROCESOS;

/*
Ingrid Marcela Alonso Morales
2004/07/26
validarEntidadExcluida valida si el tipo y numero de identificación parametrizado en DISENO_ARCHIVO para el archivo actual
se encuentra en la tabla ENTIDADES_EXCLUIDAS, de ser así retorna verdadero, de lo contrario devuelve falso.
*/
FUNCTION validarEntidadExcluida(registroCargue  IN VARCHAR2
                                , codArchivo    IN NUMBER) RETURN BOOLEAN AS

  ti            VARCHAR2(1);
  ni            VARCHAR2(11);
  existeEntidad NUMBER := 0;

  CURSOR datos IS
    SELECT D.SECUENCIA_CAMPO
    , D.POSICION_INICIAL
    , D.POSICION_FINAL
    , D.NOMBRE_COLUMNA
  FROM DISENO_ARCHIVO D
  , TIPO_CAMPO T
  WHERE  D.CODIGO_ARCHIVO = codArchivo
  AND    T.CODIGO         = D.CODIGO
  AND    D.NOMBRE_COLUMNA IN ('TIPO_IDENTIFICACION', 'NUMERO_IDENTIFICACION')
  AND    D.FIJO           = 1
  ORDER BY D.SECUENCIA_CAMPO;

BEGIN

  FOR datosTransaccion IN datos LOOP
    IF datosTransaccion.NOMBRE_COLUMNA = 'TIPO_IDENTIFICACION' THEN
      ti := SUBSTR(registroCargue,datosTransaccion.Posicion_inicial,
                                  datosTransaccion.Posicion_final-
                                  datosTransaccion.Posicion_inicial+1);
    END IF;

    IF datosTransaccion.NOMBRE_COLUMNA = 'NUMERO_IDENTIFICACION' THEN
      ni := SUBSTR(registroCargue,datosTransaccion.Posicion_inicial,
                                  datosTransaccion.Posicion_final-
                                  datosTransaccion.Posicion_inicial+1);
    END IF;
  END LOOP;

  IF ni IS NOT NULL THEN
    ni := LTRIM(ni,'0');
    ti := TRIM(ti);
    BEGIN
      SELECT COUNT(*)
      INTO existeEntidad
      FROM ENTIDADES_EXCLUIDAS
      WHERE TIPO_IDENTIFICACION = ti
      AND NUMERO_IDENTIFICACION = ni
      AND OBLIGAR_CARGA         = 0;
    EXCEPTION
      WHEN OTHERS THEN
        existeEntidad := 0;
    END;

    IF existeEntidad = 1 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END IF;
END validarEntidadExcluida;


/* CPB 02AGO2004
validarOficina valida si la oficina a la que pertenece la transacción, está inactiva.
*/
FUNCTION validarOficinaInactiva(registroCargue  IN VARCHAR2
                                , codArchivo    IN NUMBER) RETURN BOOLEAN AS

  oficina       VARCHAR2(4);
  oficinaActiva UNIDADES_NEGOCIO.activa%TYPE;
  mensaje_Error log_errores.ERROR%TYPE;
  idProceso     LOG_ERRORES.ID_PROCESO%TYPE;
  existeMensaje NUMBER;

  CURSOR datos IS
  SELECT D.SECUENCIA_CAMPO
  , D.POSICION_INICIAL
  , D.POSICION_FINAL
  , D.NOMBRE_COLUMNA
  FROM   DISENO_ARCHIVO D
  , TIPO_CAMPO T
  WHERE  D.CODIGO_ARCHIVO = codArchivo
  AND    T.CODIGO         = D.CODIGO
  AND    D.NOMBRE_COLUMNA = 'CODIGO_OFICINA'
  AND    D.FIJO           = 1
  ORDER BY D.SECUENCIA_CAMPO;

BEGIN
  FOR datosTransaccion IN datos LOOP
    IF datosTransaccion.NOMBRE_COLUMNA = 'CODIGO_OFICINA' THEN
      oficina := SUBSTR(registroCargue,datosTransaccion.Posicion_inicial,
                                        datosTransaccion.Posicion_final-
                                        datosTransaccion.Posicion_inicial+1);
    END IF;
  END LOOP;
--REM IMAM 2004-12-01
/*    IF oficina IS NOT NULL THEN
BEGIN
SELECT ACTIVA
INTO oficinaActiva
FROM UNIDADES_NEGOCIO
WHERE CODIGO = oficina
AND ACTIVA = 0;

RETURN TRUE;
EXCEPTION WHEN NO_DATA_FOUND THEN
RETURN FALSE;
WHEN OTHERS THEN
RETURN FALSE;
END;
ELSE
RETURN FALSE;
END IF;*/

  IF oficina IS NOT NULL THEN
  BEGIN
    SELECT ACTIVA
    INTO oficinaActiva
    FROM UNIDADES_NEGOCIO
    WHERE CODIGO = oficina;

    IF oficinaActiva = 1 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      mensaje_error := 'La oficina '||oficina ||' no ha sido creada.';
      SELECT MAX(ID_PROCESO)
      INTO idProceso
      FROM LOG_PROCESOS;
      BEGIN
        SELECT 1
        INTO existeMensaje
        FROM LOG_ERRORES
        WHERE ID_PROCESO = idProceso
        AND ERROR = mensaje_error;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO LOG_ERRORES
          (id_proceso
           , fecha
           , error
           , USUARIO)
        VALUES (idProceso
                , SYSDATE
                , mensaje_error
                , 0);
      END;
      RETURN TRUE;
    WHEN OTHERS THEN
      RETURN TRUE;
    END;
  END IF;
END validarOficinaInactiva;

PROCEDURE validarTipoTransaccion (registroCargue  IN VARCHAR2
                                  , codArchivo    IN NUMBER) AS

  mensaje_Error         log_errores.ERROR%TYPE;
  idProceso             LOG_ERRORES.ID_PROCESO%TYPE;
  tipoTransaccion       TIPOS_TRANSACCION.CODIGO_TRANSACCION%TYPE;
  existeTipoTransaccion NUMBER;
  nombreArchivo         ARCHIVOS.NOMBRE%TYPE;
  existeMensaje         NUMBER;

  CURSOR datos IS
    SELECT D.SECUENCIA_CAMPO
    , D.POSICION_INICIAL
    , D.POSICION_FINAL
    , D.NOMBRE_COLUMNA
    FROM DISENO_ARCHIVO D
    , TIPO_CAMPO T
    WHERE  D.CODIGO_ARCHIVO = codArchivo
    AND    T.CODIGO         = D.CODIGO
    AND    D.NOMBRE_COLUMNA = 'CODIGO_TRANSACCION'
    AND    D.FIJO           = 1
    ORDER BY D.SECUENCIA_CAMPO;

BEGIN
  FOR datosTransaccion IN datos LOOP
    IF datosTransaccion.NOMBRE_COLUMNA = 'CODIGO_TRANSACCION' THEN
      tipoTransaccion := SUBSTR(registroCargue,datosTransaccion.Posicion_inicial,
                                                datosTransaccion.Posicion_final-
                                                datosTransaccion.Posicion_inicial+1);
    END IF;
  END LOOP;

  BEGIN
    SELECT 1
    , A.NOMBRE
    INTO existeTipoTransaccion
    , nombreArchivo
    FROM TIPOS_TRANSACCION T
    , ARCHIVOS A
    WHERE A.CODIGO_PRODUCTO_V = T.CODIGO_PRODUCTO_V
    AND A.CODIGO = codArchivo
    AND CODIGO_TRANSACCION = tipoTransaccion;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    mensaje_error := 'Tipo de Transaccion: '||tipoTransaccion ||' para el archivo ' || nombreArchivo ||' no ha sido creado';
    SELECT MAX(ID_PROCESO)
    INTO idProceso
    FROM LOG_PROCESOS;
    BEGIN
      SELECT 1
      INTO existeMensaje
      FROM LOG_ERRORES
      WHERE ID_PROCESO = idProceso
      AND ERROR = mensaje_error;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      INSERT INTO LOG_ERRORES (id_proceso,  fecha, error, USUARIO)
      VALUES (idProceso, SYSDATE, mensaje_error, 0);
    END;
  END;
END validarTipoTransaccion;
END Sipcla_Cargue_Archivos;
/


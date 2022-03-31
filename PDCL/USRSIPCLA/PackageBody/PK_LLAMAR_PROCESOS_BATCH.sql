PROMPT CREATE OR REPLACE PACKAGE BODY pk_llamar_procesos_batch
CREATE OR REPLACE PACKAGE BODY pk_llamar_procesos_batch IS
/*******************************************************************************
 * Realiza el primer análisis a las transaccion transacciones cargadas, que
 * incluye la aplicación de criterios de inusualidad, marcar las transacciones
 * de mayor riesgo para el analista y aplicar los filtros definidos por los
 * usuarios.
 * *****************************************************************************
 * Requerimiento 285038
 * Modificado por ABOCANE
 * Marzo de 2017.
 * Optimizacion logica procesamiento alertas individuales y consolidadas
 ******************************************************************************/
PROCEDURE p_analizar_transacciones (codArchivo      IN  ARCHIVOS.codigo%TYPE
                                    , cedulaUsuario IN  USUARIO.cedula%TYPE
                                    , codigoMensaje OUT LOG_ARCHIVOS.codigo_mensaje%TYPE) IS

 CURSOR cur_tr IS
    SELECT *
    FROM transacciones_cliente
    WHERE codigo_archivo    = codArchivo
    AND procesada_criterios = 0;

-- GROJAS2 - CVAPD00205535 Modificación de Filtros para el Sistema de Monitoreo Transaccional SMT Colombia
-- Se modifica el cursor cur_transacciones_filtro para que consulte los filtros en estado 1
 CURSOR cur_transacciones_filtro IS
    SELECT tr.codigo_archivo
    , tr.fecha_proceso
    , tr.id id_transaccion
    , tr.valor_transaccion
    , fi.id id_filtro
    , fi.codigo_cargo
    , tr.procesada_filtros
    FROM transacciones_cliente tr
    , filtros fi
    , archivos ar
    , control_entidad e
    WHERE tr.codigo_archivo       = codarchivo
    AND tr.fecha_proceso          = e.fecha_proceso
    AND tr.procesada_filtros      = 0
    AND tr.tipo_identificacion    = fi.tipo_identificacion
    AND tr.numero_identificacion  = fi.numero_identificacion
    AND tr.numero_negocio         = fi.numero_negocio
    AND ar.codigo                 = tr.codigo_archivo
    AND fi.codigo_producto        = ar.codigo_producto_v
    --AND ( fi.vigente_hasta IS NULL OR fi.vigente_hasta >= tr.fecha_proceso);
    AND FI.ESTADO_FILTRO = 1 AND FI.VIGENTE_HASTA IS NULL; -- CVAPD00205535


/*******************************************************************************
* Modifica: Mauricio Zuluaga
* Fecha:    10/10/2011
* Descripcion: Se modifica el cursor C_clementine para que devuelva las transac
*              ciones de acuerdo al tipo de alerta.
*              1 = Alertas Consolidadas
*              2 = Alertas Individuales

* Modifica: Mauricio Zuluaga
* Fecha:    13/04/2012
* Descripcion: Se modifica el cursor C_clem1 para que devuelva el criterio de
*              inusualidad asociado (dc.criterios_inusualidad).
*******************************************************************************/
  -- Alertas consolidadas
  CURSOR C_clem1(fechaProceso IN DATE) IS
    SELECT
    tc.codigo_archivo,
    tc.numero_negocio,
    tc.fecha_proceso,
    tc.codigo_transaccion,
    tc.valor_transaccion,
    tc.id,
    dc.criterios_inusualidad
    FROM transacciones_cliente tc,detalle_tr_cle dc
    WHERE tc.codigo_archivo          = DECODE(dc.tipo_cuenta,'CTE',1,'CAH',2,'CDT',3) --DMAP Se incluye el Tipo de Cuenta 3 'CDT' 20140319
    AND tc.fecha_proceso             = fechaProceso
    AND TO_NUMBER(tc.numero_negocio) = TO_NUMBER(dc.numero_cuenta)
    AND dc.fecha_proceso             = tc.fecha_proceso
    AND dc.nivel_criticidad          = 'C'
    AND tc.codigo_transaccion        = TRIM(dc.codigo_transaccion)
    AND dc.tipo_alerta               = '1';

  -- Alertas individuales
  CURSOR C_clem2(fechaProceso IN DATE) IS
    SELECT DECODE(c.tipo_cuenta,'CTE',1,'CAH',2,'CDT',3) tipo_cuenta  --DMAP Se incluye el Tipo de Cuenta 3 'CDT' 20140319
    , c.numero_cuenta
    , c.fecha_proceso
    , c.codigo_transaccion
    , c.valor_transaccion
    , c.criterios_inusualidad
    , c.id_transaccion
    FROM detalle_tr_cle c
    WHERE c.codigo_archivo=codarchivo
    AND c.fecha_proceso    = fechaProceso
    AND c.tipo_cuenta IN('CTE','CAH','CDT') --DMAP Se incluye el Tipo de Cuenta 'CDT' 20140319
    AND c.tipo_alerta      = '2';

  CURSOR C_split(criterios IN VARCHAR2) IS
    SELECT column_value criterio
    FROM TABLE(SPLIT(criterios));

  CURSOR C_idTx(fechaProceso IN DATE, tipoCuenta IN NUMBER, numeroCuenta IN VARCHAR2, codigoTx IN VARCHAR2, valorTx IN NUMBER) IS
    SELECT id
    FROM transacciones_cliente
    WHERE fecha_proceso               = fechaProceso
    AND codigo_archivo                = tipoCuenta
    AND TO_NUMBER(numero_negocio)     = TO_NUMBER(numeroCuenta)
    AND codigo_transaccion            = TRIM(codigoTx)
    AND valor_transaccion             = valorTx;

  idProceso             log_procesos.id_proceso%TYPE := NULL;
  totalRegistros        NUMBER    := 0;
  existe                NUMBER(1) := 0;
  error                 VARCHAR2(50);
  fechaPoliticaFiltros  DATE;
  fechaProceso          DATE;

  -- Escritura en LOG.
  ruta varchar2(50);
  bitacora UTL_FILE.FILE_TYPE;
  modeler UTL_FILE.FILE_TYPE;
  y number;
  --FIN AJUSTE

BEGIN

--ADD CPB 15FEB2005
--Forza el separador decimal para que acepte punto(.), ya que los usuarios
--están creando filtros con este caracter. Si no se forza el punto como
--separador decimal y la BD toma otro (e.g. coma(,)), se genera el error
--"ORA-6502: numeric or value error", que interrumpe todo el proceso

  DBMS_SESSION.set_nls('NLS_NUMERIC_CHARACTERS','''.,''');

  SELECT fecha_proceso
  INTO fechaProceso
  FROM control_entidad;

  Pk_Lib.p_actualizar_log_procesos(idProceso, '2', NULL, cedulaUsuario, NULL);

  SELECT codigo_producto_v
  INTO g_codigo_producto
  FROM archivos
  WHERE codigo = codarchivo;

  g_codigo_archivo := codArchivo;
  g_cedula_usuario := cedulaUsuario;

  IF codArchivo IN (1, 2, 3) THEN

    Pk_Aplicar_Criterios_Inus.p_crear_sqls_dinamicos(g_codigo_producto);
    Pk_Tr_Mayor_Riesgo.p_cargar_arr_tr_riesgosas(g_codigo_producto);

    -- Escritura en log
    SELECT nombre_largo
    INTO ruta
    FROM lista_valores
    WHERE tipo_dato = 23
    AND codigo = 'OUT';
    sipcla_operacion_archivos.PR_ABRIR_ARCHIVO(ruta,'salidaLog' || codArchivo || '.txt','w',bitacora,y);
    sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Inicio Log: ' || sysdate,y);

    BEGIN
     sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Antes de FOR transacciones - levanta transacciones' || sysdate,y);
     FOR reg_tr IN cur_tr LOOP
      sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora, 'cod_archivo,' || REG_tr.Codigo_Archivo || ', id_tx, ' || reg_tr.id ,y);
      pk_aplicar_criterios_inus.p_evaluar_criterios_tr (reg_tr, bitacora );
      --pk_tr_mayor_riesgo.p_marcar_tr_mayor_riesgo (reg_tr, valortope);
      pk_tr_mayor_riesgo.p_marcar_tr_mayor_riesgo (reg_tr);
      totalregistros := totalregistros + 1;
      UPDATE transacciones_cliente
      SET  no_criterios     = reg_tr.no_criterios
      , mayor_riesgo        = reg_tr.mayor_riesgo
      , procesada_criterios = 1
      WHERE  codigo_archivo = reg_tr.codigo_archivo
      AND  fecha_proceso    = reg_tr.fecha_proceso
      AND  id               = reg_tr.id;
      COMMIT;
     END LOOP;
     sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Despues de FOR transacciones' || sysdate,y);
     sipcla_operacion_archivos.PR_CERRAR_ARCHIVO(bitacora,y);

      Pk_Aplicar_Criterios_Inus.p_crear_sqls_dinamicos(g_codigo_producto, 1);
      Pk_Aplicar_Criterios_Grupales.p_evaluar_criterios;

      FOR reg_tr_filtro IN cur_transacciones_filtro LOOP
        IF reg_tr_filtro.procesada_filtros = 0 THEN--IMAM01 SE COLOCA ESTA VALIDACION POR SI DOS FILTROS
          --HABILITAN MÁS DE UNA VEZ LA MISMA TRANSACCION
          Pk_Aplicar_Filtros.p_evaluar_filtro_tr (reg_tr_filtro.codigo_archivo
                                                  , reg_tr_filtro.fecha_proceso
                                                  , reg_tr_filtro.id_transaccion
                                                  , reg_tr_filtro.valor_transaccion
                                                  , reg_tr_filtro.id_filtro
                                                  , reg_tr_filtro.codigo_cargo);
          COMMIT;
        END IF;
      END LOOP;

--Actualiza las transacciones no consideradas dentro del análisis de filtros
      UPDATE transacciones_cliente
      SET procesada_filtros = 1
      WHERE codigo_archivo  = codArchivo
      AND procesada_filtros = 0;
      COMMIT;

-- Determinar la fecha a partir de la cual se cuenta el vencimiento de los filtros
      SELECT ADD_MONTHS(SYSDATE, -6)
      INTO fechaPoliticaFiltros
      FROM DUAL;

-- Setear los filtros que deben ser confirmados

/* GROJAS2 - CVAPD00205535 Modificación de Filtros para el Sistema de Monitoreo Transaccional SMT Colombia
   Se ajusta la lógica que determina si un filtro se debe confirmar
   1. Caso 1: El filtro nunca ha sido confirmado(campo confirmado esta en blanco),fecha de vigencia desde
   es menor a seis meses y el filtro esta aprobado.
   2. Caso 2: El filtro ya fue confirmado (campo confirmado esta en cero(0)), esta aprobado y su fecha
   de confirmación es menor a seis meses.
*/

     /* UPDATE FILTROS
      SET CONFIRMAR = 1
      WHERE confirmar = 0
      AND vigente_desde <  fechaPoliticaFiltros
      AND ( vigente_hasta IS NULL OR vigente_hasta > SYSDATE )
      AND ( fecha_confirmacion IS NULL OR fecha_confirmacion < fechaPoliticaFiltros  );
      COMMIT;
      */

      UPDATE FILTROS SET CONFIRMAR = 1
      WHERE ESTADO_FILTRO= 1
      AND(
          (CONFIRMAR IS NULL AND VIGENTE_DESDE < fechaPoliticaFiltros)
          OR(CONFIRMAR=0 AND fecha_confirmacion < fechaPoliticaFiltros)
          );
      COMMIT;

    EXCEPTION WHEN OTHERS THEN
      ROLLBACK;
      error := SUBSTR(SQLERRM,1,50);
      codigoMensaje := SQLCODE;
      sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Excepcion: codigo- ' || codigoMensaje || ' - Mensaje - ' || SUBSTR(SQLERRM,1,200) ,y);
      Pk_Lib.p_insertar_mensaje(codigoMensaje, error);
    END;

/***********************************************************************************************************************
*** ANALIS ALERTAS MODELER ***
***********************************************************************************************************************
* Modifica: Mauricio Zuluaga
* Fecha:    10/10/2011
* Descripcion: Se ajusta la ejecución del siguiente código de acuerdo a los a ajustes del requerimiento CVAPD00003137
* (Req. Modificación Alertas SMT-CLEMENTINE).
***********************************************************************************************************************
* Modifica: Mauricio Zuluaga
* Fecha:    13/04/2012
* Descripcion: Se ajustan las alertas consolidadas para que almacenen el código del criterio de inusualidad que
* le corresponde y no solamente para el codigo 85. Req CVAPD00016043.
***********************************************************************************************************************
* Modifica: Ana María Bocanegra
* Fecha: Marzo de 2017
* Requerimiento 285038: 1. Procesamiento mas de un criterio modeler alertas consolidadas
/************************************************************************************************************************/

ELSE
 totalRegistros := 0;
 -- Escritura en log
 SELECT nombre_largo INTO ruta FROM lista_valores WHERE tipo_dato=23 AND codigo='OUT';
 sipcla_operacion_archivos.PR_ABRIR_ARCHIVO(ruta,'salidaModeler'|| '.txt','w',modeler,y);

 -- Alertas Consolidadas
 sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM')||' Inicio alertas consolidadas: ',y);
 FOR r_clementine IN C_clem1(fechaProceso) LOOP
  totalRegistros := totalRegistros + 1;
  sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' '||r_clementine.codigo_archivo ||',' || fechaProceso||','||r_clementine.id,y);

  BEGIN
   UPDATE transacciones_cliente tc
   SET    tc.mayor_riesgo = 1
   WHERE  tc.codigo_archivo    = r_clementine.codigo_archivo
   AND    tc.fecha_proceso       = fechaProceso
   AND    tc.id                  = r_clementine.id
   AND    tc.codigo_transaccion  = r_clementine.codigo_transaccion
   AND    tc.numero_negocio      = r_clementine.numero_negocio;

   FOR r_criterios in c_split(r_clementine.criterios_inusualidad) LOOP
    sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Seleccion criterio:'||r_criterios.criterio,y);
    BEGIN
      --Valida si la transacción ya tiene asignado el criterio de inusualidad*/
      SELECT DISTINCT 1
      INTO existe
      FROM criterios_transaccion
      WHERE codigo_archivo        = r_clementine.codigo_archivo
      AND fecha_proceso           = fechaproceso
      AND id_transaccion          = r_clementine.id
      AND id_criterio_inusualidad = r_criterios.criterio;
    EXCEPTION WHEN NO_DATA_FOUND THEN
     /*asigna el criterio si no existe*/
     BEGIN
      INSERT INTO criterios_transaccion
      VALUES(r_clementine.codigo_archivo,fechaproceso,r_clementine.id,
      r_criterios.criterio,NULL,cedulausuario,fechaproceso);
      sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Insertando criterio:'||r_criterios.criterio ||',' ||r_clementine.codigo_archivo||','||r_clementine.id,y);
     EXCEPTION
      WHEN OTHERS THEN
       sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Excepcion alerta consolidada: '||r_clementine.id ||', '||SQLERRM,y);
     END;
    END;
   END LOOP;
   COMMIT;
  EXCEPTION WHEN OTHERS THEN
   ROLLBACK;
   error := SUBSTR(SQLERRM,1,50);
   codigoMensaje := SQLCODE;
   Pk_Lib.p_insertar_mensaje(codigoMensaje, ERROR);
   sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Excepcion alerta consolidada: '||r_clementine.id ||', '||SQLERRM,y);
  END;
 END LOOP;

 --Alertas Individuales
 sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Inicio alertas Individuales ',y);

 FOR r_clem2 IN C_clem2(fechaProceso) LOOP
  totalRegistros := totalRegistros + 1;
  sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM')||' Selecccion en detalle_tr_cle: '||r_clem2.id_transaccion,y);
  BEGIN
   --transacciones asociadas a la alerta
   FOR r_idTx in c_idTx(fechaProceso, r_clem2.tipo_Cuenta, r_clem2.numero_Cuenta, TRIM(r_clem2.codigo_transaccion), r_clem2.valor_Transaccion) LOOP
    sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Selecccion en transacciones_cliente:'||r_clem2.tipo_Cuenta||','||r_idTx.Id,y);
    BEGIN
     -- Seleccion de los criterios de inusualidad
     FOR r_criterios in c_split(r_clem2.criterios_inusualidad) LOOP
      sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Seleccion criterio:'||r_criterios.criterio,y);
      BEGIN
       --valida si la transacción ya tiene asignado el criterio de inusualidad*/
       SELECT DISTINCT 1
       INTO existe
       FROM criterios_transaccion
       WHERE codigo_archivo        = r_clem2.tipo_cuenta
       AND fecha_proceso           = fechaproceso
       AND id_transaccion          = r_idTx.Id
       AND id_criterio_inusualidad = r_criterios.criterio;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        -- asignación del criterio de inusualidad
        BEGIN
            INSERT INTO criterios_transaccion
            VALUES(r_clem2.tipo_cuenta,fechaproceso,
                   r_idtx.id,r_criterios.criterio,
                   NULL,cedulausuario,fechaproceso);
            sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Insertando criterio:'||r_criterios.criterio ||',' ||r_clem2.tipo_cuenta ||','||r_idTx.Id,y);
        EXCEPTION
         WHEN OTHERS THEN
          sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Excepcion alerta individual: '||r_clem2.id_transaccion||', '||SQLERRM,y);
        END;
      END;
     END LOOP;
     -- Actualizamos la transaccion como de mayor riesgo
     UPDATE transacciones_cliente
     SET   mayor_riesgo                = 1
     WHERE codigo_archivo              = r_clem2.tipo_cuenta
     AND fecha_proceso                 = r_clem2.fecha_proceso
     AND id                            = r_idTx.Id
     AND TO_NUMBER(numero_negocio)     = TO_NUMBER(r_clem2.numero_cuenta)
     AND codigo_transaccion            = TRIM(r_clem2.codigo_transaccion)
     AND valor_transaccion             = r_clem2.valor_transaccion;
     sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Actualizacion transacciones_cliente mayor riesgo:'||r_clem2.tipo_cuenta ||','||r_idTx.Id,y);
     COMMIT;

    EXCEPTION WHEN OTHERS THEN
     error := SUBSTR(SQLERRM,1,50);
     codigoMensaje := SQLCODE;
     Pk_Lib.p_insertar_mensaje(codigoMensaje, ERROR);
     sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Excepcion alerta individual: '||r_clem2.id_transaccion||', '||SQLERRM,y);
    END;
   END LOOP;
  EXCEPTION WHEN OTHERS THEN
   ROLLBACK;
   error := SUBSTR(SQLERRM,1,50);
   codigoMensaje := SQLCODE;
   Pk_Lib.p_insertar_mensaje(codigoMensaje, ERROR);
   sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(modeler,To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') ||' Excepcion alerta individual: '||r_clem2.id_transaccion||', '||SQLERRM,y);
  END;
 END LOOP;
END IF;

Pk_Lib.p_actualizar_log_procesos(idProceso, NULL, totalRegistros, NULL, codigoMensaje);
sipcla_operacion_archivos.PR_CERRAR_ARCHIVO(modeler,y);

END p_analizar_transacciones;
/***********************************************************************************
 * Procedimiento encargado del cargue de transacciones en SMT
************************************************************************************/
PROCEDURE p_cargar_transacciones (tipoArchivo       IN  archivos.codigo_tipo_archivo%TYPE
                                  , codigoProducto  IN  archivos.codigo_producto_v%TYPE
                                  , fechaArchivo    IN  VARCHAR2
                                  , cedulaUsuario   IN  usuario.cedula%TYPE
                                  , codigoMensaje   OUT log_archivos.codigo_mensaje%TYPE) IS

cod_archivo ARCHIVOS.codigo%TYPE;
BEGIN
 IF tipoArchivo IS NULL OR codigoProducto IS NULL THEN
  codigoMensaje := 200;
  RETURN;
 END IF;
 BEGIN
  SELECT codigo
  INTO cod_archivo
  FROM archivos
  WHERE codigo_tipo_archivo = tipoArchivo
  AND codigo_producto_v     = codigoProducto;
 EXCEPTION WHEN NO_DATA_FOUND THEN
  codigoMensaje := 201;
 END;

 Sipcla_Cargue_Archivos.PR_AUTOMATIZACION_PROCESOS(tipoArchivo,
                                                   codigoProducto,
                                                   fechaArchivo,
                                                   cedulaUsuario,
                                                   codigoMensaje);
END p_cargar_transacciones;
END;
/


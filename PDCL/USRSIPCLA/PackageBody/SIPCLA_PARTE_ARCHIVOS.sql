PROMPT CREATE OR REPLACE PACKAGE BODY sipcla_parte_archivos
CREATE OR REPLACE PACKAGE BODY sipcla_parte_archivos IS

/*********************************************************************************************
-- Autor:	Yolanda Leguizamon L.  - Banco de Bogota
-- Fecha:	Marzo 8 de 2004
-- Modifica:
-- Fecha:
-- Descripcion: Realiza la distribucion de archivo de acuerdo a la aplicacion
************************************************************************************************
 MODIFICACIONES
 Modificado por Ana Maria Bocanegra
 Fecha: Mayo 2021
 Requerimiento:CVAPD00582379- Inclusion campo descripcion transaccion
 Ajuste en el programa para el cargue de un nuevo campo (descripcion de la transaccion)
************************************************************************************************/

PROCEDURE PR_PROCESA_ORIGEN(Pv_usuario        IN     NUMBER,
                            Pd_FechaProceso   IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                            Pn_Codigo         IN     ARCHIVOS.CODIGO%TYPE,
                            Pv_TablaDetalle   IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                            Pd_CodigoMensaje  IN OUT NUMBER) IS

  Lv_Comando_Instruccion VARCHAR2(50);
  Lv_Comando_Campos      VARCHAR2(2000);
  Lv_Comando_Datos       VARCHAR2(2000);
  Lv_Comando             VARCHAR2(5000);
  Lv_Registro            VARCHAR2(2000);
  --ADD CPB 31MAR2004
  Lv_Dato                VARCHAR2(200);
  Lv_No_Decimales        NUMBER;

  CURSOR C_archivos IS
    SELECT  REGISTRO
    , SECUENCIA_TRANSACCION
    FROM   CARGUE_TOTAL
    WHERE SUBSTR(REGISTRO,1,1) = '1'
    AND   FECHA_PROCESO        = Pd_FechaProceso
    AND   CODIGO_ARCHIVO       = Pn_Codigo;

/*******************************************************************************
 * Modifica: Mauricio Zuluaga
 * Fecha:    08/07/2009
 * Descripcion: Levantar los de registros reportados por Clementine
 * ****************************************************************************/
  CURSOR C_clementine IS
    SELECT  REGISTRO
    , SECUENCIA_TRANSACCION
    FROM   CARGUE_TOTAL
    WHERE FECHA_PROCESO  = Pd_FechaProceso
    AND   CODIGO_ARCHIVO = Pn_codigo;
 /* Fin Modificacion */

/* Cursor de diseno parte fija */
  CURSOR C_diseno_fijo IS
    SELECT ROWNUM
    , D.SECUENCIA_CAMPO
    , D.POSICION_INICIAL
    , D.POSICION_FINAL
    , D.REQUERIDO
    , D.FIJO
    , D.NOMBRE_COLUMNA
    , T.CODIGO_TIPO_DATO
    , T.FORMATO
    FROM DISENO_ARCHIVO D
    , TIPO_CAMPO T
    WHERE  D.CODIGO_ARCHIVO = Pn_codigo
    AND    T.CODIGO         = D.CODIGO
    AND    D.NOMBRE_COLUMNA IS NOT NULL
    AND    D.FIJO           = 1
    ORDER BY D.SECUENCIA_CAMPO;

/* Cursor de diseno parte variable */
  CURSOR C_diseno_variable IS
    SELECT ROWNUM
    , D.SECUENCIA_CAMPO
    , D.POSICION_INICIAL
    , D.POSICION_FINAL
    , D.REQUERIDO
    , D.FIJO
    , D.NOMBRE_COLUMNA
    , T.CODIGO_TIPO_DATO
    , T.FORMATO
    FROM DISENO_ARCHIVO D
    , TIPO_CAMPO T
    WHERE  D.CODIGO_ARCHIVO = Pn_codigo
    AND    T.CODIGO         = D.CODIGO
    AND    D.NOMBRE_COLUMNA IS NOT NULL
    AND    D.FIJO           = 0
    ORDER BY D.SECUENCIA_CAMPO;

BEGIN

  IF Pn_codigo IN (1, 2, 3) THEN

    FOR C1 IN C_Archivos  LOOP
      Lv_Registro := C1.Registro;
  --        Instrucciones parte fija .... tablas transacciones cliente...
      BEGIN
        Lv_Comando_Instruccion := NULL;
        Lv_Comando_Campos      := NULL;
        Lv_Comando_Datos       := NULL;
        Lv_Comando             := NULL;

        FOR C2 IN C_Diseno_fijo  LOOP
          IF C2.ROWNUM = 1 THEN
            Lv_Comando_Instruccion := 'INSERT INTO TRANSACCIONES_CLIENTE';
            Lv_Comando_Campos      := '(CODIGO_ARCHIVO,'            ||
                                      ' FECHA_PROCESO, '            ||
                                      ' ID, '                       ||
                                      ' CODIGO_ACTIVIDAD_ECONOMICA,'||
                                      ' ESTADO_DUCC,'               ||
                                      ' ESTADO_OFICINA, '           ||
                                      ' FILTRO_DUCC,'               ||
                                      ' FILTRO_OFICINA,'            ||
                                      ' MAYOR_RIESGO,'              ||
                                      ' NUEVA,'                     ||
                                      ' PROCESADA_CRITERIOS,'       ||
                                      ' PROCESADA_FILTROS,'         ||
                                      ' PROCESADA_PITUFEO,'         ||
                                      ' NO_COMENTARIOS, '           ||
                                      ' NO_COMENTARIOS_DUCC,'       ||
                                      ' NO_CRITERIOS,'              ||
                                      ' USUARIO_CREACION,'          ||
                                      ' USUARIO_ACTUALIZACION,'     ||
                                      --                                              ' FECHA_ACTUALIZACION'; -- REM IMAM 2004/07/21
                                      ' FECHA_ACTUALIZACION' || Lv_Comando_Campos; --IMAM 2004/07/21

            Lv_Comando_Datos := ' VALUES( '||
                                Pn_Codigo||','||                 --CODIGO_ARCHIVO
                                CHR(39)||Pd_FechaProceso||CHR(39)||','|| --FECHA_PROCESO
                                C1.SECUENCIA_TRANSACCION||','||  --ID
                                CHR(39)||NULL||CHR(39)||','||    --CODIGO_ACTIVIDAD_ECONOMICA
                                CHR(39)||'P'||CHR(39)||','||     --ESTADO_DUCC
                                CHR(39)||'P'||CHR(39)||','||     --ESTADO_OFICINA
                                0||','||                         --FILTRO_DUCC
                                0||','||                         --FILTRO_OFICINA
                                0||','||                         --MAYOR_RIESGO
                                1||','||                         --NUEVA
                                0||','||                         --PROCESADA_CRITERIOS
                                0||','||                         --PROCESADA_FILTROS
                                0||','||                         --PROCESADA_PITUFEO
                                0||','||                         --NO_COMENTARIOS
                                0||','||                         --NO_COMENTARIOS_DUCC
                                0||','||                         --NO_CRITERIOS
                                Pv_usuario||','||                --USUARIO_CREACION
                                CHR(39)||NULL||CHR(39)||','||    --USUARIO_ACTUALIZACION
  --                              CHR(39)||NULL||CHR(39);         REM IMAM 2007/07/21
                                CHR(39)||NULL||CHR(39) || Lv_Comando_Datos;          --FECHA_ACTUALIZACION IMAM 2004/07/21
          END IF;
          Lv_Comando_Campos := Lv_Comando_Campos||','||C2.NOMBRE_COLUMNA;
          Lv_Comando_Datos  := Lv_Comando_Datos||',';
  --ADD CPB 31MAR04
          Lv_Dato := SUBSTR(C1.Registro,C2.Posicion_inicial,C2.Posicion_final-C2.Posicion_inicial+1);
  --ADD CPB 01FEB2005 Inicio
  --Condici¢n que permite insertar un valor NULL en la columna CODIGO_OFICINA_ORIGEN
  --cuando dicha columna viene llena con espacios en blanco.
  --Aplica inicialmente para las transacciones tipo 0012, pero se dej¢ gen¿rico
          IF C2.CODIGO_TIPO_DATO = 1
            AND C2.NOMBRE_COLUMNA = 'CODIGO_OFICINA_ORIGEN'
            AND RTRIM(Lv_Dato) IS NULL THEN
              Lv_Dato := CHR(39)||NULL||CHR(39);
          END IF;
  --ADD CPB 01FEB2005 Fin

          IF C2.CODIGO_TIPO_DATO = 1
            AND  --Formato Numero
              C2.FORMATO IS NOT NULL THEN
              Lv_No_Decimales := TO_NUMBER(SUBSTR(C2.FORMATO,INSTR(C2.FORMATO,g_SEPARADOR_DECIMAL)+1));
              Lv_Dato         := SUBSTR(Lv_Dato, 1, LENGTH(Lv_Dato) - Lv_No_Decimales)
                                  || g_SEPARADOR_DECIMAL
                                  || SUBSTR(Lv_Dato, -Lv_No_Decimales);
          END IF;
          IF C2.CODIGO_TIPO_DATO = 2 THEN
            Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
            IF (C2.NOMBRE_COLUMNA = 'NOMBRE_CLIENTE' OR C2.NOMBRE_COLUMNA = 'DESCRIPCION_TRANSACCION') THEN  --ADD CPB 13AGO2004
              Lv_Dato := RTRIM(Lv_Dato);
            END IF;
          END IF;
          IF C2.CODIGO_TIPO_DATO = 3
            AND C2.FORMATO IS NOT NULL THEN
              Lv_Comando_Datos := Lv_Comando_Datos||'TO_DATE('||CHR(39);
          END IF;
  /* REM CPB 31MAR04
  Lv_Comando_Datos :=Lv_Comando_Datos||SUBSTR(C1.Registro,
  C2.Posicion_inicial,
  C2.Posicion_final-
  C2.Posicion_inicial+1);*/
          Lv_Comando_Datos := Lv_Comando_Datos || Lv_Dato; --ADD CPB 31MAR04
          IF C2.CODIGO_TIPO_DATO = 2 THEN
            Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
          END IF;
          IF C2.CODIGO_TIPO_DATO = 3
            AND C2.FORMATO IS NOT NULL THEN
              Lv_Comando_Datos := Lv_Comando_Datos||CHR(39)||','|| CHR(39)||C2.FORMATO||CHR(39)||')';
          END IF;
        END LOOP;
        Lv_Comando_Campos := Lv_Comando_Campos||')';
        Lv_Comando_Datos  := Lv_Comando_Datos||')';
        Lv_Comando        := RTRIM(LTRIM(Lv_Comando_Instruccion))||' '||
                             RTRIM(LTRIM(Lv_Comando_Campos))||' '||
  --											 RTRIM(LTRIM(Lv_Comando_Datos)); --REM IMAM 2004/07/14
                             RTRIM(LTRIM(REPLACE(Lv_Comando_Datos,CHR(124),CHR(39)||CHR(39)))); --IMAM 2004/07/14
  --             dbms_output.put_line(SUBSTR(Lv_Comando,1,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,81,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,161,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,241,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,321,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,401,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,481,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,561,80));
        EXECUTE IMMEDIATE Lv_Comando;
        COMMIT;
      END;
  --        Instrucciones parte variable .... tablas de detalle..
      BEGIN
        Lv_Comando_Instruccion := NULL;
        Lv_Comando_Campos      := NULL;
        Lv_Comando_Datos       := NULL;
        Lv_Comando             := NULL;
        FOR C3 IN C_Diseno_variable  LOOP
          IF C3.ROWNUM = 1 THEN
            Lv_Comando_Instruccion := 'INSERT  INTO '||Pv_TablaDetalle;
            Lv_Comando_Campos      := '(CODIGO_ARCHIVO,'||
                                      ' FECHA_PROCESO, '||
  --                                              ' ID_TRANSACCION ';-- REM IMAM 2004/07/21
                                      ' ID_TRANSACCION ' || Lv_Comando_Campos; --IMAM 2004/07/21
            Lv_Comando_Datos       := ' VALUES( '||
                                      Pn_Codigo||','||
                                      CHR(39)||Pd_FechaProceso||CHR(39)||','||
  --                                              C1.SECUENCIA_TRANSACCION; -- REM IMAM 2004/07/21
                                      C1.SECUENCIA_TRANSACCION || Lv_Comando_Datos; --IMAM 2004/07/21
          END IF;
          Lv_Comando_Campos := Lv_Comando_Campos||','||C3.NOMBRE_COLUMNA;
          Lv_Comando_Datos  := Lv_Comando_Datos||',';
          Lv_Dato           := SUBSTR(C1.Registro,C3.Posicion_inicial,C3.Posicion_final-C3.Posicion_inicial+1); --ADD CPB 31MAR04
          IF C3.CODIGO_TIPO_DATO = 1
            AND  /* Formato Numero */
              C3.FORMATO IS NOT NULL THEN
  --Lv_Comando_Datos := Lv_Comando_Datos||'TO_CHAR('; REM CPB 31MAR04
  --ADD CPB 31MAR04:
              Lv_No_Decimales  := TO_NUMBER(SUBSTR(C3.FORMATO,INSTR(C3.FORMATO,g_SEPARADOR_DECIMAL)+1));
              Lv_Dato := SUBSTR(Lv_Dato, 1, LENGTH(Lv_Dato) - Lv_No_Decimales)
                        || g_SEPARADOR_DECIMAL
                        || SUBSTR(Lv_Dato, -Lv_No_Decimales);
          END IF;
          IF C3.CODIGO_TIPO_DATO = 2 THEN /* Formato String */
            Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
          END IF;
          IF C3.CODIGO_TIPO_DATO = 3 AND  /* Formato Fecha  */
            C3.FORMATO IS NOT NULL THEN
              Lv_Comando_Datos := Lv_Comando_Datos||'TO_DATE('||CHR(39);
          END IF;
  /*Lv_Comando_Datos :=Lv_Comando_Datos||SUBSTR(C1.Registro,
  C3.Posicion_inicial,
  C3.Posicion_final-
  C3.Posicion_inicial+1);*/ --REM CPB 31MAR04
          Lv_Comando_Datos := Lv_Comando_Datos || Lv_Dato; --ADD CPB 31MAR04
  /* REM CPB 31MAR04
  IF C3.CODIGO_TIPO_DATO = 1 AND  -- Formato Numero
  C3.FORMATO IS NOT NULL THEN
  Lv_Comando_Datos := Lv_Comando_Datos||','||CHR(39);
  Lv_Comando_Datos := Lv_Comando_Datos||
  LPAD('0',
  FLOOR(C3.FORMATO) - (MOD(C3.FORMATO,FLOOR(C3.FORMATO))*10),
  '0')||
  '.'||
  LPAD('0',
  (MOD(C3.FORMATO,FLOOR(C3.FORMATO))*10),
  '0')||
  CHR(39)||')';
  END IF;*/
          IF C3.CODIGO_TIPO_DATO = 2 THEN
            Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
          END IF;
          IF C3.CODIGO_TIPO_DATO = 3
            AND C3.FORMATO IS NOT NULL THEN
              Lv_Comando_Datos := Lv_Comando_Datos||CHR(39)||','||
                                  CHR(39)||C3.FORMATO||CHR(39)||')';
          END IF;
        END LOOP;
        Lv_Comando_Campos := Lv_Comando_Campos||')';
        Lv_Comando_Datos  := Lv_Comando_Datos||')';
        Lv_Comando        := RTRIM(LTRIM(Lv_Comando_Instruccion))||' '||
                             RTRIM(LTRIM(Lv_Comando_Campos))||' '||
  --                                  RTRIM(LTRIM(Lv_Comando_Datos)); REM IMAM 2004/07/21
                             RTRIM(LTRIM(REPLACE(Lv_Comando_Datos,CHR(124),CHR(39)||CHR(39)))); --IMAM 2004/07/21
  --             dbms_output.put_line(SUBSTR(Lv_Comando,1,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,81,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,161,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,241,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,321,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,401,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,481,80));
  --             dbms_output.put_line(SUBSTR(Lv_Comando,561,80));
          EXECUTE IMMEDIATE Lv_Comando;
          COMMIT;
        END;
      END LOOP;

  --CPB 05AGO2004
  --Las tarjetas de identidad (T) migradas a CRM fueron justificadas con
  --ceros a la izquierda. Estos ceros no son tomados por el cargue de SIPCLA
  --ya que el numero de identificaci¢n se lee con formato num¿rico. Por esto
  --es necesario restaurar los ceros de las Tarjetas de Identidad:
      UPDATE TRANSACCIONES_CLIENTE
      SET numero_identificacion = LPAD(numero_identificacion, 11, '0')
      WHERE fecha_proceso     = Pd_FechaProceso
      AND codigo_archivo      = Pn_Codigo
      AND tipo_identificacion = 'T';

      COMMIT;

  ELSE

/*******************************************************************************
 * Modifica: Mauricio Zuluaga
 * Fecha:    08/07/2009
 * Descripcion: Levantar los de registros reportados por Clementine
 * ****************************************************************************/

    FOR Ccle IN C_clementine LOOP
      Lv_Registro := Ccle.Registro;

      Lv_Comando_Instruccion := NULL;
      Lv_Comando_Campos      := NULL;
      Lv_Comando_Datos       := NULL;
      Lv_Comando             := NULL;


      FOR Cvble IN C_Diseno_variable  LOOP
        IF Cvble.ROWNUM = 1 THEN
          Lv_Comando_Instruccion := 'INSERT  INTO '||Pv_TablaDetalle;
          Lv_Comando_Campos      := '(CODIGO_ARCHIVO,'||
                                    ' FECHA_PROCESO, '||
                                    ' ID_TRANSACCION ' || Lv_Comando_Campos;
          Lv_Comando_Datos       := ' VALUES( '||
                                    Pn_Codigo||','||
                                    CHR(39)||Pd_FechaProceso||CHR(39)||','||
                                    Ccle.Secuencia_Transaccion || Lv_Comando_Datos;
        END IF;
        Lv_Comando_Campos := Lv_Comando_Campos||','||Cvble.NOMBRE_COLUMNA;
        Lv_Comando_Datos  := Lv_Comando_Datos||',';
        Lv_Dato           := SUBSTR(Ccle.Registro,Cvble.Posicion_inicial,Cvble.Posicion_final-Cvble.Posicion_inicial+1);
        IF Cvble.CODIGO_TIPO_DATO = 1
          AND  /* Formato Numero */
            Cvble.FORMATO IS NOT NULL THEN
            Lv_No_Decimales  := TO_NUMBER(SUBSTR(Cvble.FORMATO,INSTR(Cvble.FORMATO,g_SEPARADOR_DECIMAL)+1));
            Lv_Dato := SUBSTR(Lv_Dato, 1, LENGTH(Lv_Dato) - Lv_No_Decimales)
                      || g_SEPARADOR_DECIMAL
                      || SUBSTR(Lv_Dato, -Lv_No_Decimales);
        END IF;
        IF Cvble.CODIGO_TIPO_DATO = 2 THEN /* Formato String */
          Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
        END IF;
        IF Cvble.CODIGO_TIPO_DATO = 3 AND  /* Formato Fecha  */
          Cvble.FORMATO IS NOT NULL THEN
            Lv_Comando_Datos := Lv_Comando_Datos||'TO_DATE('||CHR(39);
        END IF;

        Lv_Comando_Datos := Lv_Comando_Datos || Lv_Dato; --ADD CPB 31MAR04
        IF Cvble.CODIGO_TIPO_DATO = 2 THEN
          Lv_Comando_Datos := Lv_Comando_Datos||CHR(39);
        END IF;
        IF Cvble.CODIGO_TIPO_DATO = 3
          AND Cvble.FORMATO IS NOT NULL THEN
            Lv_Comando_Datos := Lv_Comando_Datos||CHR(39)||','||
                                CHR(39)||Cvble.FORMATO||CHR(39)||')';
        END IF;
      END LOOP;

      Lv_Comando_Campos := Lv_Comando_Campos||')';
      Lv_Comando_Datos  := Lv_Comando_Datos||')';
      Lv_Comando        := RTRIM(LTRIM(Lv_Comando_Instruccion))||' '||
                           RTRIM(LTRIM(Lv_Comando_Campos))||' '||
                           RTRIM(LTRIM(REPLACE(Lv_Comando_Datos,CHR(124),CHR(39)||CHR(39))));

      EXECUTE IMMEDIATE Lv_Comando;
      COMMIT;



    END LOOP;

  END IF;
 /* Fin Modificacion */

END PR_PROCESA_ORIGEN;

PROCEDURE PR_PROCESA_ARCHIVO (Pv_usuario       IN     NUMBER,
                              Pd_FechaProceso  IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                              Pn_Codigo        IN     ARCHIVOS.CODIGO%TYPE,
                              Pv_TablaDetalle  IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                              Pd_CodigoMensaje IN OUT NUMBER) IS

BEGIN
--ADD CPB 13AGO2004
  Sipcla_Operacion_Estructuras.PR_BORRA_TABLA_FECHA(Pd_FechaProceso
                                                    , Pn_Codigo
                                                    , 'CRITERIOS_TRANSACCION'
                                                    , Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;

  Sipcla_Operacion_Estructuras.PR_BORRA_TABLA_FECHA(Pd_FechaProceso
                                                    , Pn_Codigo
                                                    , Pv_TablaDetalle
                                                    , Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;

  Sipcla_Operacion_Estructuras.PR_BORRA_TABLA_FECHA(Pd_FechaProceso
                                                    , Pn_Codigo
                                                    , 'TRANSACCIONES_CLIENTE'
                                                    , Pd_CodigoMensaje);

  IF Pd_CodigoMensaje <> 0 THEN
    RETURN;
  END IF;

  Sipcla_Parte_Archivos.PR_PROCESA_ORIGEN(Pv_usuario
                                          , Pd_FechaProceso
                                          , Pn_Codigo
                                          , Pv_TablaDetalle
                                          , Pd_CodigoMensaje);
END PR_PROCESA_ARCHIVO;
END Sipcla_Parte_Archivos;
/


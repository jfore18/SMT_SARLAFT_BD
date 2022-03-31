PROMPT CREATE OR REPLACE PROCEDURE pr_generar_log
CREATE OR REPLACE PROCEDURE pr_generar_log (usuario IN  NUMBER
                                            , error OUT NUMBER) IS

  CURSOR cur_registros IS
    SELECT *
    FROM log_consultas
    WHERE enviado = 0
    ORDER BY consecutivo;

  cantidad        NUMBER := 0;

  canal           VARCHAR2(4000);
  registro_log    VARCHAR2(1000);
  ubicacion       VARCHAR2(100);
  mensaje         VARCHAR2(50);
  nombre_archivo  VARCHAR2(30);

  tipo_prod       CHAR(6);
  nemotecnico     CHAR(3) := 'SLA';
  tipo_doc        CHAR(1);

  idProceso       LOG_PROCESOS.id_proceso%TYPE := NULL;

  archivo         UTL_FILE.file_type;

BEGIN

  PK_LIB.P_ACTUALIZAR_LOG_PROCESOS(idProceso, '13', NULL, usuario, NULL);

  SELECT ubicacion
  , nombre
  INTO ubicacion
  , nombre_archivo
  FROM archivos
  WHERE codigo = 8;

  nombre_archivo := replace(nombre_archivo,'fecha', nemotecnico || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'));

  SIPCLA_OPERACION_ARCHIVOS.PR_ABRIR_ARCHIVO(ubicacion, nombre_archivo, 'w', archivo, error);

  IF error != 0 THEN
    RETURN;
  END IF;

  FOR reg_registros IN cur_registros LOOP

    registro_log := LPAD(NVL(TRIM(reg_registros.usuario_nt), TO_CHAR(reg_registros.usuario)), 12);
    registro_log := registro_log || RPAD(NVL(reg_registros.dominio_red, ' '), 16);
    registro_log := registro_log || RPAD(NVL(reg_registros.nombre_pc, ' '), 16);
    registro_log := registro_log || nemotecnico;
    registro_log := registro_log || TO_CHAR(reg_registros.fecha_ejecucion, 'YYYYMMDDHH24MISS');

    tipo_doc := NVL(reg_registros.tipo_id, ' ');

    IF tipo_doc IN ('C', 'N', 'T', 'P', 'E', 'L', 'R', ' ') THEN
      registro_log := registro_log || tipo_doc;
    ELSE
      registro_log := registro_log || 'O';
    END IF;

    registro_log := registro_log || LPAD(NVL(reg_registros.numero_id, '0'), 12, '0');

    SELECT
      CASE NVL(reg_registros.tipo_producto, ' ')
        WHEN '1' THEN RPAD('CCT', 6)
        WHEN '2' THEN RPAD('CAH', 6)
        WHEN '3' THEN RPAD('CDT', 6)
        ELSE RPAD(' ',6)
      END
    INTO tipo_prod
    FROM dual;

    registro_log := registro_log || tipo_prod;

    registro_log := registro_log || RPAD(NVL(reg_registros.numero_producto, ' '), 16);
    registro_log := registro_log || RPAD(SUBSTR(NVL(reg_registros.canal, ' '), INSTR(NVL(reg_registros.canal, ' '), -1)), 30);
    registro_log := registro_log || nemotecnico;
    registro_log := registro_log || NVL(reg_registros.tipo_busqueda, '0');

    SELECT REPLACE(NVL(reg_registros.query, ' '), CHR(13) || CHR(10), ' ')
      INTO canal
    FROM dual;

    IF LENGTH(canal) < 500 THEN
      canal := RPAD(canal, 500);
    END IF;

    registro_log := registro_log || RPAD(canal, 500);
    registro_log := registro_log || NVL(reg_registros.tipo_transaccion, '0');
    registro_log := registro_log || NVL(reg_registros.resultado_tx, '0');
    registro_log := registro_log || RPAD(NVL(reg_registros.descripcion_rechazo, ' '), 20);
    registro_log := registro_log || RPAD(' ', 20);

    SIPCLA_OPERACION_ARCHIVOS.PR_ESCRIBIR_LINEA(archivo, registro_log, error);

    IF error != 0 THEN
      RETURN;
    END IF;

    BEGIN
      UPDATE log_consultas
      SET enviado = 1
      , fecha_envio = SYSDATE
      WHERE consecutivo = reg_registros.consecutivo;

    EXCEPTION WHEN OTHERS THEN
      ROLLBACK;
      error := SQLCODE;
      mensaje := SUBSTR(SQLERRM, 1, 50);
      Pk_Lib.p_insertar_mensaje(error, mensaje);
      RETURN;
    END;

    cantidad := cantidad + 1;

  END LOOP;

  SIPCLA_OPERACION_ARCHIVOS.PR_CERRAR_ARCHIVO(archivo, error);

  IF error != 0 THEN
    RETURN;
    ROLLBACK;
  END IF;

  COMMIT;

  PK_LIB.P_ACTUALIZAR_LOG_PROCESOS(idProceso, '13', cantidad, usuario, error);

END PR_GENERAR_LOG;
/


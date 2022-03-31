PROMPT CREATE OR REPLACE PROCEDURE pr_reporte_normal
CREATE OR REPLACE procedure pr_reporte_normal(idReporte IN REPORTE.ID%TYPE, cargoActualizacion IN CARGOS.CODIGO%TYPE, salida OUT VARCHAR2) is
  rolActualizacion CARGOS.CODIGO_PERFIL_V%TYPE;
  usuarioActualizacion USUARIO.CEDULA%TYPE;
  NORMAL VARCHAR2(1) := 'N';

  CURSOR transacciones IS
         SELECT T.ID_TRANSACCION,
                T.CODIGO_ARCHIVO,
                T.FECHA_PROCESO,
                TC.ESTADO_DUCC,
                TC.ESTADO_OFICINA
         FROM TRANSACCIONES_REP T,
              TRANSACCIONES_CLIENTE TC
         WHERE T.ID_TRANSACCION = TC.ID AND
               T.CODIGO_ARCHIVO = TC.CODIGO_ARCHIVO AND
               T.FECHA_PROCESO = TC.FECHA_PROCESO AND
               ID_REPORTE = idReporte;
begin
     SELECT CODIGO_USUARIO, CODIGO_PERFIL_V
     INTO usuarioActualizacion, rolActualizacion
     FROM CARGOS
     WHERE CODIGO = cargoActualizacion;
     IF rolActualizacion = '2' THEN
       FOR tr IN transacciones LOOP
           INSERT INTO HISTORICO_ESTADOS_TR (
           ID, CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION,
           CODIGO_ESTADO_V,CODIGO_CARGO,
           USUARIO_ACTUALIZACION,FECHA_ACTUALIZACION)
           VALUES(
           SEQ_HISTORICO_ESTADO.NEXTVAL, tr.CODIGO_ARCHIVO, tr.FECHA_PROCESO, tr.ID_TRANSACCION,
           tr.ESTADO_OFICINA, cargoActualizacion,
           usuarioActualizacion, sysdate);
           UPDATE TRANSACCIONES_CLIENTE
           SET ESTADO_OFICINA = NORMAL,
           USUARIO_ACTUALIZACION = usuarioActualizacion,
           FECHA_ACTUALIZACION = sysdate
           WHERE ID = tr.ID_TRANSACCION AND
                 FECHA_PROCESO = tr.FECHA_PROCESO AND
                 CODIGO_ARCHIVO = tr.CODIGO_ARCHIVO;
       END LOOP;
     END IF;
     IF rolActualizacion = '5' THEN
       FOR tr IN transacciones LOOP
           INSERT INTO HISTORICO_ESTADOS_TR (
           ID, CODIGO_ARCHIVO, FECHA_PROCESO, ID_TRANSACCION,
           CODIGO_ESTADO_V,CODIGO_CARGO,
           USUARIO_ACTUALIZACION,FECHA_ACTUALIZACION)
           VALUES(
           SEQ_HISTORICO_ESTADO.NEXTVAL, tr.CODIGO_ARCHIVO, tr.FECHA_PROCESO, tr.ID_TRANSACCION,
           tr.ESTADO_DUCC, cargoActualizacion,
           usuarioActualizacion, sysdate
           );
           UPDATE TRANSACCIONES_CLIENTE
           SET ESTADO_DUCC = NORMAL,
           USUARIO_ACTUALIZACION = usuarioActualizacion,
           FECHA_ACTUALIZACION = sysdate
           WHERE ID = tr.ID_TRANSACCION AND
                 FECHA_PROCESO = tr.FECHA_PROCESO AND
                 CODIGO_ARCHIVO = tr.CODIGO_ARCHIVO;
       END LOOP;
    END IF;
    COMMIT;
    salida := '';
EXCEPTION
         WHEN OTHERS THEN
              ROLLBACK;
              DELETE TRANSACCIONES_REP WHERE ID_REPORTE = idReporte;
              DELETE REPORTE WHERE ID = idReporte;
              COMMIT;
              salida := 'Ocurrio un error, no se creo el reporte ' || sqlerrm;
end PR_REPORTE_NORMAL;
/


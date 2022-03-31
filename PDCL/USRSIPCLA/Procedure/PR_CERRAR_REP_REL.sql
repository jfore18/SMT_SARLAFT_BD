PROMPT CREATE OR REPLACE PROCEDURE pr_cerrar_rep_rel
CREATE OR REPLACE procedure pr_cerrar_rep_rel(idReporte IN REPORTE.ID%TYPE,
                                              salida OUT VARCHAR2) is
  actualizar BOOLEAN;
  CURSOR reportes IS
      SELECT R.ID
      FROM reporte R,
      CARGOS C
      WHERE R.ID IN (
          SELECT ID_REPORTE
          FROM transacciones_rep t
          WHERE (id_transaccion, codigo_archivo, fecha_proceso) IN (
          SELECT id_transaccion, codigo_archivo, fecha_proceso
          FROM Transacciones_rep
          WHERE id_reporte = idReporte  )
      )
      AND R.ID <> idReporte
      AND R.CODIGO_CLASE_REPORTE_V IN ('1','2')
      AND R.CODIGO_ESTADO_REPORTE_V = '1'
      AND R.FECHA_CREACION < (SELECT FECHA_CREACION
                              FROM REPORTE WHERE ID = idReporte)
      AND R.codigo_cargo = C.codigo
      AND C.codigo_perfil_v = '2';

  CURSOR transaccionesReporte (idRep REPORTE.ID%TYPE) IS
         SELECT T.ID_TRANSACCION,
                T.CODIGO_ARCHIVO,
                T.FECHA_PROCESO,
                TC.ESTADO_DUCC
         FROM TRANSACCIONES_REP T,
              TRANSACCIONES_CLIENTE TC
         WHERE T.ID_TRANSACCION = TC.ID AND
               T.CODIGO_ARCHIVO = TC.CODIGO_ARCHIVO AND
               T.FECHA_PROCESO = TC.FECHA_PROCESO AND
               ID_REPORTE = idRep AND
               TC.ESTADO_DUCC NOT IN ('M','S','N');
BEGIN
    FOR rep IN reportes LOOP

        actualizar := TRUE;

        FOR tx IN transaccionesReporte(rep.ID) LOOP

           actualizar := FALSE;

        END LOOP;

        IF actualizar THEN

          UPDATE reporte
          SET CODIGO_ESTADO_REPORTE_V = '5'
          WHERE ID = rep.ID;

        END IF;

       END LOOP;

    COMMIT;

    salida := '';
EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      salida := 'Ocurrio un error, no se cerraron los rep. relacionados ' || sqlerrm;
end PR_CERRAR_REP_REL;
/


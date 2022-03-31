PROMPT CREATE OR REPLACE PACKAGE BODY sipcla_operacion_estructuras
CREATE OR REPLACE PACKAGE BODY sipcla_operacion_estructuras IS

PROCEDURE PR_BORRA_TABLA_FECHA  (Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                                 Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                                 Pv_Tabla                       IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                                 Pd_CodigoMensaje               IN OUT NUMBER)
IS
 Lv_Comando             VARCHAR2(5000);
BEGIN
    Lv_Comando := NULL;
    Lv_Comando := 'DELETE '||Pv_tabla||
                  ' WHERE FECHA_PROCESO = '||CHR(39)||Pd_FechaProceso||CHR(39)||
                  ' AND   CODIGO_ARCHIVO = '||Pn_Codigo;
    BEGIN
       EXECUTE IMMEDIATE Lv_Comando;
       EXCEPTION WHEN OTHERS THEN
              Pd_CodigoMensaje :=  777;
              RETURN;
    END;
    COMMIT;
END PR_BORRA_TABLA_FECHA;


END Sipcla_Operacion_Estructuras;
/


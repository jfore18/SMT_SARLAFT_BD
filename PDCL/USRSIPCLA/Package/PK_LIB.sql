PROMPT CREATE OR REPLACE PACKAGE pk_lib
CREATE OR REPLACE PACKAGE pk_lib IS

   TYPE tab_arreglo IS TABLE OF VARCHAR2(200)
     INDEX BY BINARY_INTEGER;

   PROCEDURE f_get_dir_archivo_BD (codDir IN OUT VARCHAR2, codArchivo IN OUT VARCHAR2);
   PROCEDURE p_actualizar_log_procesos(idProceso      IN OUT LOG_PROCESOS.id_proceso%TYPE,
                                       codProceso     LOG_PROCESOS.codigo_proceso%TYPE,
                                       regsProcesados LOG_PROCESOS.registros_procesados%TYPE,
                                       cedulaUsuario  LOG_PROCESOS.USUARIO%TYPE,
                                       codMensaje     LOG_PROCESOS.codigo_mensaje%TYPE);

   PROCEDURE p_actualizar_log_transaccional(codArchivo  in log_transaccional.codigo_archivo%type,
                                            fechaProc   in log_transaccional.fecha_proceso%type,
                                            idTrans     in log_transaccional.id_transaccion%type,
                                            detalleReg  in log_transaccional.detalle%type,
                                            idenProceso in log_transaccional.id_proceso%type,
                                            codProceso  in log_transaccional.codigo_proceso%type);



   PROCEDURE p_insertar_mensaje (codMensaje NUMBER, mensaje VARCHAR2);
   FUNCTION  f_get_arreglo (lista_multiple VARCHAR2) RETURN tab_arreglo;
   FUNCTION  f_valor_existe_en_arreglo (valor VARCHAR2, arreglo tab_arreglo) RETURN BOOLEAN;
   FUNCTION  f_valor_en_lista_multiple (valor VARCHAR2, lista_multiple VARCHAR2) RETURN BOOLEAN;
   FUNCTION  f_get_perfil_cargo (codigoCargo CARGOS.codigo%TYPE) RETURN NUMBER;

END;
/


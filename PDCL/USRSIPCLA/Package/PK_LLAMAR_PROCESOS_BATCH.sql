PROMPT CREATE OR REPLACE PACKAGE pk_llamar_procesos_batch
CREATE OR REPLACE PACKAGE pk_llamar_procesos_batch IS

/* Cada procesos batch se ejecuta por archivo; es decir, no se ejecutará un
   proceso total para todos los archivos de todos los productos cargados en
   un día
*/
g_cedula_usuario   USUARIO.cedula%TYPE;
g_codigo_producto  ARCHIVOS.codigo_producto_v%TYPE;
g_codigo_archivo   ARCHIVOS.codigo%TYPE;  --ADD CPB 09JUN2004 -para pitufeo

PROCEDURE p_analizar_transacciones (codArchivo      IN  ARCHIVOS.codigo%TYPE
                                    , cedulaUsuario IN  USUARIO.cedula%TYPE
                                    , codigoMensaje OUT LOG_ARCHIVOS.codigo_mensaje%TYPE);

PROCEDURE p_cargar_transacciones (tipoArchivo       IN  ARCHIVOS.codigo_tipo_archivo%TYPE
                                  , codigoProducto  IN  ARCHIVOS.codigo_producto_v%TYPE
                                  , fechaArchivo    IN  VARCHAR2
                                  , cedulaUsuario   IN  USUARIO.cedula%TYPE
                                  , codigoMensaje   OUT LOG_ARCHIVOS.codigo_mensaje%TYPE);
END;
/


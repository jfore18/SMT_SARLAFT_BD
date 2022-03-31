PROMPT CREATE OR REPLACE PACKAGE pk_depuracion
CREATE OR REPLACE PACKAGE pk_depuracion IS

  PROCEDURE depurar               (mensajeError  OUT    VARCHAR2,
                                   cedulaUsuario IN     USUARIO.cedula%TYPE);

  PROCEDURE moverPreguntasReporte (idReporte     IN     REPORTE.ID%TYPE,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE) ;

  PROCEDURE moverReporte          (idReporte     IN     REPORTE.ID%TYPE,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE) ;

  PROCEDURE moverTransacciones    (idReporte     IN     REPORTE.ID%TYPE,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE) ;

  PROCEDURE abrirArchivo          (ubicacion     IN     VARCHAR2,
                                   nombre        IN     VARCHAR2,
                                   modoApertura  IN     VARCHAR2,
		                               archivo       OUT    UTL_FILE.FILE_TYPE);

  PROCEDURE escribirArchivo       (archivo       IN OUT UTL_FILE.FILE_TYPE,
	                                 mensaje       IN     VARCHAR2);

  PROCEDURE cerrarArchivo         (archivo       IN OUT UTL_FILE.FILE_TYPE);

  PROCEDURE ejecutarSentencia     (sentencia     IN VARCHAR2,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE);

  PROCEDURE borrarTxnNormales     (nroDias       IN NUMBER,
                                   archivo       IN OUT UTL_FILE.FILE_TYPE);

  PROCEDURE moverLogConsultas     (archivo       IN OUT UTL_FILE.FILE_TYPE,
                                   numeroDias    IN NUMBER);

  --GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
  FUNCTION reporteGestionado      (idReporte     IN REPORTE.ID%TYPE, bitacora IN OUT UTL_FILE.FILE_TYPE) RETURN BOOLEAN;

  --GROJAS2 - CVAPD00262210 - Enriquecer log que genera la herramienta durante proceso de depuración de las tablas en línea para identificar el error
  FUNCTION transaccionEnReporte   (codArchivo IN TRANSACCIONES_CLIENTE.codigo_archivo%type,
                                   fechaP IN TRANSACCIONES_CLIENTE.fecha_proceso%type,
                                   idTransaccion IN TRANSACCIONES_CLIENTE.id%type) RETURN BOOLEAN;


END;
/


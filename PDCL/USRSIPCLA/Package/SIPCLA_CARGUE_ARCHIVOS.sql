PROMPT CREATE OR REPLACE PACKAGE sipcla_cargue_archivos
CREATE OR REPLACE PACKAGE sipcla_cargue_archivos IS
-- Autor:	Yolanda Leguizamon L.  - Banco de Bogota
-- Fecha:	Enero 15 de 2004
-- Modifica:
-- Fecha:
-- Descripcion: Realiza cargue de archivos de aplicaciones
PROCEDURE PR_LOG_CARGUE( Pv_Usuario                     IN     NUMBER,
                         Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                         Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
          	         Pn_TotalRegistrosReportados    IN OUT LOG_ARCHIVOS.REGISTROS_REPORTADOS%TYPE,
                         Pn_TotalRegistrosProcesados    IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                         Pd_CodigoMensaje               IN OUT NUMBER);
PROCEDURE PR_CARGUE(  Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                      Pv_Registro                    IN     VARCHAR2,
                      Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                      Pn_TotalRegistrosProcesados    IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                      Pd_CodigoMensaje               IN OUT NUMBER);
PROCEDURE PR_ARCHIVO_EN_SERVIDOR(  Pv_usuario                     IN     NUMBER,
                                   Pd_FechaProceso 	          IN 	 CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
				   Pv_UbicacionEntrada 	          IN 	 ARCHIVOS.UBICACION%TYPE,
                                   Pv_ArchivoDatos                IN     ARCHIVOS.NOMBRE%TYPE,
                                   Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                                   Pv_TablaDetalle                IN     ARCHIVOS.TABLA_DETALLE%TYPE,
          	                   Pn_TotalRegistrosReportados    IN OUT LOG_ARCHIVOS.REGISTROS_REPORTADOS%TYPE,
                                   Pn_TotalRegistrosProcesados    IN OUT LOG_ARCHIVOS.REGISTROS_PROCESADOS%TYPE,
                                   Pd_CodigoMensaje  	    	  OUT 	 NUMBER);
PROCEDURE PR_AUTOMATIZACION_PROCESOS(Pn_codigo_tipo_archivo	IN  NUMBER,
                                     Pn_codigo_producto  	IN  NUMBER,
												 Pv_fecha_archivo      IN VARCHAR2,
                                     Pv_usuario                 IN  NUMBER,
           	                     Pd_CodigoMensaje           OUT NUMBER);

FUNCTION validarEntidadExcluida (registroCargue IN VARCHAR2, codArchivo IN NUMBER) RETURN BOOLEAN;
FUNCTION validarOficinaInactiva (registroCargue IN VARCHAR2, codArchivo IN NUMBER) RETURN BOOLEAN;
PROCEDURE validarTipoTransaccion (registroCargue IN VARCHAR2, codArchivo IN NUMBER);
END Sipcla_Cargue_Archivos ;
/


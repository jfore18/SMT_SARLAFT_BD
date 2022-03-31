PROMPT CREATE OR REPLACE PACKAGE sipcla_parte_archivos
CREATE OR REPLACE PACKAGE sipcla_parte_archivos IS
-- Autor:	Yolanda Leguizamon L.  - Banco de Bogota
-- Fecha:	Marzo 8 de 2004
-- Modifica:
-- Fecha:
-- Descripcion: Realiza la distribucion de archivo de acuerdo a la aplicacion
g_SEPARADOR_DECIMAL CONSTANT VARCHAR2(1) := '.'; --ADD CPB 31MAR04
PROCEDURE PR_PROCESA_ORIGEN(Pv_usuario                 IN     NUMBER,
                         Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                         Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                         Pv_TablaDetalle                IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                         Pd_CodigoMensaje               IN OUT NUMBER);
PROCEDURE PR_PROCESA_ARCHIVO (Pv_usuario                     IN     NUMBER,
                                 Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                                 Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                                 Pv_TablaDetalle                IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                                 Pd_CodigoMensaje               IN OUT NUMBER) ;
END Sipcla_Parte_Archivos ;
/


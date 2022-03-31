PROMPT CREATE OR REPLACE PACKAGE sipcla_operacion_estructuras
CREATE OR REPLACE PACKAGE sipcla_operacion_estructuras IS
/* Aqui se encuentra todos los procedimientos y funciones que permiten
   manipular estructuras como delete, analyze y otros comandos
   AUTOR : Yolanda Leguizamon    FECHA : 15-01-2004
*/


/* Procedimiento que lee una linea de un archivo abierto para lectura
   PARAMETROS: Pd_FechaProceso      = Fecha de la Tabla Control Entidad
               Pn_Codigo            = Codigo_Archivo
               Pv_Tabla             = Variable nombre de tabla a borrar
               Pd_CodigoMensaje     = Error presentado en el procedimiento
*/

PROCEDURE PR_BORRA_TABLA_FECHA  (Pd_FechaProceso                IN     CONTROL_ENTIDAD.FECHA_PROCESO%TYPE,
                                 Pn_Codigo                      IN     ARCHIVOS.CODIGO%TYPE,
                                 Pv_Tabla                       IN     ARCHIVOS.TABLA_DETALLE%TYPE,
                                 Pd_CodigoMensaje               IN OUT NUMBER);

END Sipcla_Operacion_Estructuras;
/


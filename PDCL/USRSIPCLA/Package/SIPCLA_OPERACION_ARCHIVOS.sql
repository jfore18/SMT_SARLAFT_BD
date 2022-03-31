PROMPT CREATE OR REPLACE PACKAGE sipcla_operacion_archivos
CREATE OR REPLACE PACKAGE sipcla_operacion_archivos IS
/* Aqui se encuentra todos los procedimientos y funciones que permiten
   manipular archivos  tipo texto en el SERVIDOR
   AUTOR : Yolanda Leguizamon    FECHA : 15-01-2004
*/


/* Procedimiento que abre un archivo especifico en el servidor y en la forma que usted
   solicite
   PARAMETROS: Pv_UbicacionArchivo=  Path o ubicación del archivo
               Pv_NombreArchivo= Nombre del archivo con su extensión
               Pv_FormaApertura= Indica la forma de apertura del archivo
                                 ('a' Append, 'r' Lectura, 'w' Escritura)
               Pt_DescriptorArchivo= Descriptor del archivo abierto con los cuales
                                     se pueden hacer otro tipo de operaciones como lectura
                                     o escritura
               Pd_CodigoMensaje:      Error presentado en el procedimiento
*/

PROCEDURE PR_ABRIR_ARCHIVO(Pv_UbicacionArchivo   IN VARCHAR2,
                           Pv_NombreArchivo      IN VARCHAR2,
                           Pv_FormaApertura      IN VARCHAR2,
                           Pt_DescriptorArchivo  OUT Utl_File.FILE_TYPE,
                           Pd_CodigoMensaje      OUT NUMBER);

/* Procedimiento que cierra un archivo especifico en el servidor
   PARAMETROS: Pt_DescriptorArchivo= Descriptor del archivo que se va a cerrar
               Pd_CodigoMensaje: Error presentado en el procedimiento
*/

PROCEDURE PR_CERRAR_ARCHIVO(Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                            Pd_CodigoMensaje OUT NUMBER);

/* Procedimiento que cierra todos los archivo abiertos en el servidor
   PARAMETROS: Pd_CodigoMensaje: Error presentado en el procedimiento
*/

PROCEDURE PR_CERRAR_TODOS(Pd_CodigoMensaje            OUT NUMBER);


/* Procedimiento que escribe una linea en un archivo abierto para escritura
   PARAMETROS: Pt_DescriptorArchivo = Descriptor del archivo abierto para escritura
               Pv_Linea             = Cadena de caracteres a escribir en el archivo correspondiente a una linea
               Pd_CodigoMensaje      = Error presentado en el procedimiento
*/

PROCEDURE PR_ESCRIBIR_LINEA (Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                             Pv_Linea             IN     VARCHAR2,
                             Pd_CodigoMensaje     OUT    NUMBER);

/* Procedimiento que lee una linea de un archivo abierto para lectura
   PARAMETROS: Pt_DescriptorArchivo = Descriptor del archivo abierto para lectura
               Pv_Linea             = Cadena de caracteres leida
               Pb_FinArchivo        = Variable booleana que indica si es fin de archivo o no
               Pd_CodigoMensaje     = Error presentado en el procedimiento
*/

PROCEDURE PR_LEER_LINEA (Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                         Pv_Linea                OUT VARCHAR2,
                         Pb_FinArchivo           OUT BOOLEAN,
                         Pd_CodigoMensaje        OUT NUMBER);


END Sipcla_Operacion_Archivos;
/


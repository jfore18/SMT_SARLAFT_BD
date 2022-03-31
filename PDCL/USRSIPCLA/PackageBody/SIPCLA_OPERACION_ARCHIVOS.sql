PROMPT CREATE OR REPLACE PACKAGE BODY sipcla_operacion_archivos
CREATE OR REPLACE PACKAGE BODY sipcla_operacion_archivos IS

PROCEDURE PR_ABRIR_ARCHIVO(Pv_UbicacionArchivo   IN VARCHAR2,
                           Pv_NombreArchivo      IN VARCHAR2,
                           Pv_FormaApertura      IN VARCHAR2,
                           Pt_DescriptorArchivo  OUT Utl_File.FILE_TYPE,
                           Pd_CodigoMensaje      OUT NUMBER)
IS
BEGIN
  Pd_CodigoMensaje:=0;
  --Validar la obligatoriedad de los parámetros de entrada
  IF Pv_UbicacionArchivo IS NULL OR Pv_NombreArchivo IS NULL OR Pv_FormaApertura IS NULL THEN
     Pd_CodigoMensaje:= 570;
     RETURN;
  END IF;
  --Validar que los parametros contengan datos validos
  IF Pv_FormaApertura NOT IN ('a','w','r') THEN
     Pd_CodigoMensaje:= 571;
     RETURN;
  END IF;
  --Se abre el archivo en la forma solicitada devolviendo el descriptor de archivo
  Pt_DescriptorArchivo := Utl_File.Fopen(Pv_UbicacionArchivo,
                                         Pv_NombreArchivo,
                                         Pv_FormaApertura);
  EXCEPTION
      WHEN UTL_FILE.INVALID_OPERATION THEN
         Pd_CodigoMensaje:= 178;
      WHEN UTL_FILE.INVALID_PATH THEN
         Pd_CodigoMensaje:= 437;
      WHEN UTL_FILE.INVALID_MODE THEN
         Pd_CodigoMensaje:= 176;
      WHEN UTL_FILE.INTERNAL_ERROR THEN
         Pd_CodigoMensaje:= 181;
      WHEN OTHERS THEN
         Pd_CodigoMensaje:= 999;
END PR_ABRIR_ARCHIVO;

PROCEDURE PR_CERRAR_ARCHIVO(Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                            Pd_CodigoMensaje OUT NUMBER)
IS
BEGIN
  Pd_CodigoMensaje:=0;
  --Se cierra el archivo
  Utl_File.Fclose(Pt_DescriptorArchivo);
  EXCEPTION
      WHEN UTL_FILE.WRITE_ERROR THEN
         Pd_CodigoMensaje:= 180;
      WHEN UTL_FILE.INTERNAL_ERROR THEN
         Pd_CodigoMensaje:= 181;
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         Pd_CodigoMensaje:= 177;
      WHEN OTHERS THEN
         Pd_CodigoMensaje:= 999;
END PR_CERRAR_ARCHIVO;

PROCEDURE PR_CERRAR_TODOS(Pd_CodigoMensaje OUT NUMBER)
IS
BEGIN
  Pd_CodigoMensaje:=0;
  --Se cierra todos los archivos abiertos
  Utl_File.Fclose_All;
  EXCEPTION
     WHEN UTL_FILE.WRITE_ERROR THEN
         Pd_CodigoMensaje:= 180;
     WHEN UTL_FILE.INTERNAL_ERROR THEN
         Pd_CodigoMensaje:= 181;
     WHEN OTHERS THEN
         Pd_CodigoMensaje:= 999;
END PR_CERRAR_TODOS;


PROCEDURE PR_ESCRIBIR_LINEA (Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                             Pv_Linea IN VARCHAR2,
                             Pd_CodigoMensaje OUT NUMBER)
IS
BEGIN
  Pd_CodigoMensaje:=0;
  --Se escribe la linea en el archivo abierto
  Utl_File.Put_Line(Pt_DescriptorArchivo,Pv_Linea);
  EXCEPTION
     WHEN UTL_FILE.WRITE_ERROR THEN
         Pd_CodigoMensaje:= 180;
     WHEN UTL_FILE.INTERNAL_ERROR THEN
         Pd_CodigoMensaje:= 181;
     WHEN UTL_FILE.INVALID_OPERATION THEN
         Pd_CodigoMensaje:= 178;
     WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         Pd_CodigoMensaje:= 177;
     WHEN OTHERS THEN
         Pd_CodigoMensaje:= 999;
END PR_ESCRIBIR_LINEA;

PROCEDURE PR_LEER_LINEA (Pt_DescriptorArchivo IN OUT Utl_File.FILE_TYPE,
                         Pv_Linea                OUT VARCHAR2,
                         Pb_FinArchivo           OUT BOOLEAN,
                         Pd_CodigoMensaje        OUT NUMBER) IS
BEGIN
  Pd_CodigoMensaje:=0;
  Pv_Linea:=NULL;
  Pb_FinArchivo:=FALSE;
  --Se lee la linea
  Utl_File.get_line(Pt_DescriptorArchivo,Pv_Linea);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         Pb_FinArchivo:=TRUE;
     WHEN VALUE_ERROR THEN
         Pd_CodigoMensaje:= 998;
     WHEN UTL_FILE.INTERNAL_ERROR THEN
         Pd_CodigoMensaje:= 181;
     WHEN UTL_FILE.READ_ERROR THEN
         Pd_CodigoMensaje:= 179;
     WHEN UTL_FILE.INVALID_OPERATION THEN
         Pd_CodigoMensaje:= 178;
     WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         Pd_CodigoMensaje:= 177;
     WHEN OTHERS THEN
         Pd_CodigoMensaje:= 999;
END PR_LEER_LINEA;

END Sipcla_Operacion_Archivos;
/


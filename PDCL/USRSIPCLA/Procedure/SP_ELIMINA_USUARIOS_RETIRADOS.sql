PROMPT CREATE OR REPLACE PROCEDURE sp_elimina_usuarios_retirados
CREATE OR REPLACE procedure sp_elimina_usuarios_retirados(RESPUESTA OUT VARCHAR2) is

/******************************************************************************************************************************
** NOMBRE: SP_ELIMINA_USUARIOS_RETIRADOS
**
** PROPOSITO:
** Procedimiento almacenado responsable de inactivar masivamente los cargos y los usuarios de los funcionarios
** que se retiraron del banco, de acuerdo a archivo entregado por nomina.
** PARAMETROS DE ENTRADA
** RESPUESTA: mensaje retornado por el procedimiento almacenado con el resultado de su ejecución
**
**Construido por :ABOCANE- Ana Maria Bocanegra
**Fecha  Febrero de 2019
** Requerimiento CVAPD00405879-Validaciones en SMT para control usuarios activos
***************************************************************************************************************************************/

/*
DEFINICION DE VARIABLES
*/

idProceso          LOG_PROCESOS.id_proceso%TYPE;
codProceso         LOG_PROCESOS.CODIGO_PROCESO%TYPE;
dir_entradas       V_RUTAS_BD.descripcion%TYPE;
archivo_entrada    V_RUTAS_BD.descripcion%TYPE;
error              VARCHAR(200);
usuario            LOG_PROCESOS.USUARIO%TYPE;

descriptorArchivo  UTL_FILE.File_Type;
codigoMensaje      NUMBER;
registro           VARCHAR2(1000);
finArchivo         BOOLEAN;
nRegistros         NUMBER;

ruta varchar2(50);
bitacora UTL_FILE.FILE_TYPE;
y number;

identificacion     VARCHAR(15);
nombre             VARCHAR(20);
apellido           VARCHAR(20);
fecha_retiro       VARCHAR(10);
contador           NUMBER;
existeUsuario      NUMBER;

BEGIN

 idProceso       := NULL;
 codProceso      := '14'; -- INACTIVACION USUARIOS RETIRADOS
 dir_entradas    := 'IN'; -- DIRECTORIO DE ENTRADAS
 archivo_entrada := 'EMP'; -- ARCHIVO DE EMPLEADOS
 nRegistros      :=  0;
 usuario         := 999999999;-- PROCESOS AUTOMATICOS
 respuesta       := 'OK-Archivo procesado correctamente. Revisar log de resultado';
 existeUsuario   := 0;

 -- 1.Se registra en el log el inicio del proceso
 Pk_Lib.p_actualizar_log_procesos (idProceso,codProceso,0,usuario, NULL);
 -- Formato de fechas DD/MM/YYYY
  EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''DD/MM/YYYY''';
 IF dir_entradas IS NOT NULL AND archivo_entrada IS NOT NULL THEN
   Pk_Lib.f_get_dir_archivo_BD (dir_entradas, archivo_entrada);
   Sipcla_Operacion_Archivos.PR_ABRIR_ARCHIVO(dir_entradas,archivo_entrada,'r',descriptorArchivo, codigoMensaje);

   IF codigoMensaje <> 0 THEN
    error := 'ER-Error al abrir el archivo:'||archivo_entrada ||'. Error' ||codigoMensaje ;
    INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)VALUES (idProceso, SYSDATE, error,usuario);

    Pk_Lib.p_actualizar_log_procesos(idProceso,codProceso,0,usuario,codigoMensaje);
    respuesta:= error;
    RETURN;
   END IF;

 END IF;


  -- Creamos el archivo de log, con el fin de tener seguimiento de los usuarios eliminados
 SELECT nombre_largo INTO ruta
 FROM lista_valores WHERE tipo_dato = 23 AND codigo = 'OUT';

 sipcla_operacion_archivos.PR_ABRIR_ARCHIVO(ruta,'LogRetirados.txt','w',bitacora,y);
 sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Inicio Log: ' || To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),y);

 LOOP
  -- Leemos la linea del archivo
  sipcla_Operacion_Archivos.PR_LEER_LINEA(descriptorArchivo,registro,finArchivo,codigoMensaje);
  nRegistros := nRegistros + 1;
  IF codigoMensaje <> 0 THEN
   error := 'ER-Error al leer linea de archivo: '||nRegistros ||'. Error'|| codigoMensaje ;
   INSERT INTO LOG_ERRORES (id_proceso, fecha, error, USUARIO)VALUES (idProceso, SYSDATE, error,usuario);
   Pk_Lib.p_actualizar_log_procesos(idProceso,codProceso,0,usuario,codigoMensaje);
   sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,error|| To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),y);
  END IF;

  IF finArchivo THEN
   EXIT;
  END IF;

  BEGIN
   select
   regexp_substr(registro, '[^;]+', 1, 1),
   regexp_substr(registro, '[^;]+', 1, 2),
   regexp_substr(registro, '[^;]+', 1, 3),
   regexp_substr(registro, '[^;]+', 1, 5)
   into identificacion,nombre,apellido,fecha_retiro
   from dual;

   -- 1. Validaciones sobre los datos de entrada.
   -- Validamos que el usuario existe en la base de datos de Sarlaft y se encuentre activo
   contador := 0;
   select count(*) into contador from usuario where cedula=to_number(identificacion) and activo=1;

   if contador>0 then
    existeUsuario := 1;
   else
    existeUsuario := 0;
   end if;

   -- Si el usuario existe
   if existeUsuario = 1 then
       -- Validamos que la fecha de retiro sea menor a la fecha actual
     if to_date(fecha_retiro,'dd/mm/yyyy') > to_date(sysdate,'dd/mm/yyyy') then
       -- fecha incorrecta escribir log resultado
       sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Fecha de retiro incorrecta. Usuario:'||identificacion||'. Linea '|| nRegistros ||' '|| sysdate,y);
     else
        -- Inactivamos el usuario
       begin

        update usuario set activo= 0,fecha_actualizacion=sysdate,usuario_actualizacion=usuario
        where cedula= to_number(identificacion);
        commit;
        --  Validamos sí el usuario esta asociado a un cargo activo, si es asi inactivamos el cargo
        contador :=0;
        select  count(*)into contador from cargos where codigo_usuario=to_number(identificacion) and activo=1;
        if contador >0 then
         update cargos set activo=0,codigo_usuario=null, fecha_actualizacion=sysdate,usuario_actualizacion=usuario
         where codigo_usuario=to_number(identificacion);
         commit;
        end if;
        -- Mensaje log_procesos con los usuarios actualizados.
        sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Usuario eliminado:'||identificacion||'. Linea '|| nRegistros ||' '|| To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),y);
       exception
        when others then
         error := 'ER- Error inactivando usuario:'||identificacion ||'. '||SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros;
         insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso, SYSDATE, error,usuario);
         sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Error inactivando usuario:' ||SQLERRM|| To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),y);
        end;
     end if;
   end if;

exception when others then
  error := SUBSTR (SQLERRM,1,60) || ' REGISTRO ' || nRegistros;
  insert into log_errores (id_proceso, fecha, error, USUARIO)VALUES (idProceso,SYSDATE,error,usuario);
  sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Error en registro' ||nRegistros ||'. ' ||SQLERRM||fecha_retiro,y);
  commit;
end;
end loop;
sipcla_operacion_archivos.PR_ESCRIBIR_LINEA(bitacora,'Fin Proceso ' || To_Char(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM'),y);
sipcla_operacion_archivos.PR_CERRAR_ARCHIVO(bitacora,y);
sipcla_operacion_archivos.PR_CERRAR_ARCHIVO(descriptorArchivo,codigoMensaje);
-- Se marca el fin del proceso
Pk_Lib.p_actualizar_log_procesos (idProceso,codProceso,0,usuario, NULL);

end SP_ELIMINA_USUARIOS_RETIRADOS;
/


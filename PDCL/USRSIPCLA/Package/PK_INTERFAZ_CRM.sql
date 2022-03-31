PROMPT CREATE OR REPLACE PACKAGE pk_interfaz_crm
CREATE OR REPLACE PACKAGE pk_interfaz_crm
IS
   PROCEDURE p_crear_archivo_clientes (cedulaUsuario IN  USUARIO.cedula%TYPE);
   PROCEDURE p_obtener_datos_clientes (archivoCargue IN  VARCHAR2, --IMAM 2006-08-23
                                       tipoProceso   IN  VARCHAR2,  --IMAM 2006-08-23
                                       cedulaUsuario IN  USUARIO.cedula%TYPE,
                                       mensaje       OUT VARCHAR2); --IMAM 2006-08-23
   PROCEDURE p_grabar_datos_cliente   (regCliente VARCHAR2, idProceso LOG_PROCESOS.id_proceso%TYPE);
END;
/


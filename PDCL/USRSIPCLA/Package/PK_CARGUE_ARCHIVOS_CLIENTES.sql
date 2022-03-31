PROMPT CREATE OR REPLACE PACKAGE pk_cargue_archivos_clientes
CREATE OR REPLACE PACKAGE pk_cargue_archivos_clientes IS
   PROCEDURE p_cargar_entidad_excluida (tipoEntidad   IN  LISTA_VALORES.codigo%TYPE,
                                        cedulaUsuario IN  USUARIO.cedula%TYPE,
										codigoMensaje OUT LOG_ARCHIVOS.codigo_mensaje%TYPE);
   PROCEDURE p_grabar_entidad_excluida (regEntidad  IN VARCHAR2,
                                        tipoEntidad IN LISTA_VALORES.codigo%TYPE,
                                        idProceso   IN LOG_PROCESOS.id_proceso%TYPE);
END;
/


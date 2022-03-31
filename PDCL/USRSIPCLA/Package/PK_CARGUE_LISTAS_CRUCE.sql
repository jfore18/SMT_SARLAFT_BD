PROMPT CREATE OR REPLACE PACKAGE pk_cargue_listas_cruce
CREATE OR REPLACE PACKAGE pk_cargue_listas_cruce IS

/******************************************************************************************
                                  PROCEDIMIENTO PRINCIPAL
******************************************************************************************/
   PROCEDURE p_cargar_listas    (tipoLista             IN  VARCHAR2,
                                 cedulaUsuario         IN  USUARIO.cedula%TYPE,
                                 mensajeRetorno        OUT VARCHAR2);

/******************************************************************************************
                     PROCEDIMIENTO QUE VALIDA REGISTRO A REGISTRO E INSERTA
******************************************************************************************/
   PROCEDURE p_insertar_persona (regPersona            IN VARCHAR2,
                                 idProceso             IN LOG_PROCESOS.id_proceso%TYPE,
                                 tipoLista             IN VARCHAR2,
                                 nroPersonasYaExisten  IN OUT NUMBER,
                                 nroPersonasInsertadas IN OUT NUMBER,
                                 cedulaUsuario         IN  USUARIO.cedula%TYPE);

END Pk_Cargue_Listas_Cruce;
/


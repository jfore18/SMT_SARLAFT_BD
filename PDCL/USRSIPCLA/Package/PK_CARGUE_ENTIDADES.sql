PROMPT CREATE OR REPLACE PACKAGE pk_cargue_entidades
CREATE OR REPLACE PACKAGE pk_cargue_entidades IS

/******************************************************************************************
                                  PROCEDIMIENTO PRINCIPAL
******************************************************************************************/
   PROCEDURE p_cargar           (tipoEntidad           IN  VARCHAR2,
                                 cedulaUsuario         IN  USUARIO.cedula%TYPE,
                                 mensajeRetorno        OUT VARCHAR2);

/******************************************************************************************
                     PROCEDIMIENTO QUE VALIDA REGISTRO A REGISTRO E INSERTA
******************************************************************************************/
   PROCEDURE p_insertar_entidad (regEntidad             IN VARCHAR2,
                                 idProceso              IN LOG_PROCESOS.id_proceso%TYPE,
                                 tipoEntidad            IN VARCHAR2,
                                 nroEntidadesYaExisten  IN OUT NUMBER,
                                 nroEntidadesInsertadas IN OUT NUMBER,
                                 cedulaUsuario          IN  USUARIO.cedula%TYPE);

   PROCEDURE p_genera_flag      (campoInicial           IN VARCHAR2,
                                 tipoEntidad            IN NUMBER,
                                 campoFlags             OUT VARCHAR2);

END Pk_Cargue_Entidades;
/


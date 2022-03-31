PROMPT CREATE OR REPLACE PACKAGE pk_aplicar_filtros
CREATE OR REPLACE PACKAGE pk_aplicar_filtros
IS
--   g_cedula_usuario   USUARIO.cedula%TYPE;
--   g_codigo_producto  ARCHIVOS.codigo_producto_v%TYPE;

   PROCEDURE p_evaluar_filtro_tr (codigoArchivo    TRANSACCIONES_CLIENTE.codigo_archivo%TYPE,
                                  fechaProceso     TRANSACCIONES_CLIENTE.fecha_proceso%TYPE,
                                  idTransaccion    TRANSACCIONES_CLIENTE.id%TYPE,
                                  valorTransaccion TRANSACCIONES_CLIENTE.valor_transaccion%TYPE,
                                  idFiltro         FILTROS.id%TYPE,
                                  codigoCargo      FILTROS.codigo_cargo%TYPE);


   FUNCTION f_cumple_filtro (idFiltro FILTROS.id%TYPE,
                             valor    TRANSACCIONES_CLIENTE.valor_transaccion%TYPE) RETURN BOOLEAN;

END;
/


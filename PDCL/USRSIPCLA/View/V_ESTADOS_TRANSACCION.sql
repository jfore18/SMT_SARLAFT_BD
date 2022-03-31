PROMPT CREATE OR REPLACE VIEW v_estados_transaccion
CREATE OR REPLACE VIEW v_estados_transaccion (
  codigo,
  nombre_largo,
  nombre_corto
) AS
SELECT LISTA_VALORES.CODIGO, LISTA_VALORES.NOMBRE_LARGO, LISTA_VALORES.NOMBRE_CORTO
       FROM LISTA_VALORES
       WHERE TIPO_DATO = 11
/


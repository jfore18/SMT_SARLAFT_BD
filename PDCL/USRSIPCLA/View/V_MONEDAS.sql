PROMPT CREATE OR REPLACE VIEW v_monedas
CREATE OR REPLACE VIEW v_monedas (
  codigo,
  descripcion
) AS
SELECT LISTA_VALORES.CODIGO, LISTA_VALORES.NOMBRE_LARGO
       FROM LISTA_VALORES
       WHERE TIPO_DATO=6
/


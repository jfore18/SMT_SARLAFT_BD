PROMPT CREATE OR REPLACE VIEW v_tipos_consulta
CREATE OR REPLACE VIEW v_tipos_consulta (
  codigo,
  descripcion
) AS
SELECT LISTA_VALORES.CODIGO, LISTA_VALORES.NOMBRE_LARGO
       FROM LISTA_VALORES
       WHERE TIPO_DATO=8
/


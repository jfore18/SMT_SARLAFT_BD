PROMPT CREATE OR REPLACE VIEW v_clases_reporte
CREATE OR REPLACE VIEW v_clases_reporte (
  codigo,
  descripcion
) AS
SELECT LISTA_VALORES.CODIGO, LISTA_VALORES.NOMBRE_LARGO
       FROM LISTA_VALORES
       WHERE TIPO_DATO =7
/


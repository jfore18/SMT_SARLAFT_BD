PROMPT CREATE OR REPLACE VIEW v_tipos_relacion
CREATE OR REPLACE VIEW v_tipos_relacion (
  codigo,
  nombre_largo
) AS
SELECT LISTA_VALORES.CODIGO, LISTA_VALORES.NOMBRE_LARGO
       FROM LISTA_VALORES
       WHERE TIPO_DATO = 12
/


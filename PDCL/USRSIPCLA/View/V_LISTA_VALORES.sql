PROMPT CREATE OR REPLACE VIEW v_lista_valores
CREATE OR REPLACE VIEW v_lista_valores (
  tipo_dato,
  codigo,
  nombre_corto,
  nombre_largo,
  aplica_gerente
) AS
SELECT
tipo_dato,
codigo,
nombre_corto,
nombre_largo,
aplica_gerente
FROM LISTA_VALORES
WHERE ACTIVO = 1
UNION
SELECT
99 tipo_dato,
lpad(codigo_region_v,2,' ') || lpad(codigo,2,' '),
nombre_corto,
nombre_largo,
NULL aplica_gerente
FROM ZONAS
WHERE ACTIVA=1
/


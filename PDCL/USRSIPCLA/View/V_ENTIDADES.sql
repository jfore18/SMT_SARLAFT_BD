PROMPT CREATE OR REPLACE VIEW v_entidades
CREATE OR REPLACE VIEW v_entidades (
  codigo,
  tipo_entidad
) AS
select
codigo CODIGO,
nombre_largo TIPO_ENTIDAD
from
lista_valores
where tipo_dato = '24'
/


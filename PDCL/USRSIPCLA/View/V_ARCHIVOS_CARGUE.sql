PROMPT CREATE OR REPLACE VIEW v_archivos_cargue
CREATE OR REPLACE VIEW v_archivos_cargue (
  codigo_archivo,
  codigo_producto,
  nombre_producto,
  codigo_tipo_archivo,
  nombre_tipo_archivo
) AS
select
AR.CODIGO CODIGO_ARCHIVO,
P.codigo codigo_producto,
P.NOMBRE_LARGO nombre_producto,
A.codigo codigo_tipo_archivo,
A.NOMBRE_LARGO nombre_tipo_archivo
from LISTA_VALORES P,   --PRODUCTOS
LISTA_VALORES A, --TIPO ARCHIVO
archivos AR
where
P.TIPO_DATO = 2 AND
A.TIPO_DATO = 1 AND
AR.codigo_producto_V = P.codigo AND
AR.codigo_tipo_archivo = A.codigo AND
A.ACTIVO = 1 AND
P.ACTIVO = 1
/


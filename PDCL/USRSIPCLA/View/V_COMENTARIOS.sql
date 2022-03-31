PROMPT CREATE OR REPLACE VIEW v_comentarios
CREATE OR REPLACE VIEW v_comentarios (
  codigo_archivo,
  fecha_proceso,
  id_transaccion,
  id_comentario,
  fecha_creacion,
  nombre,
  codigo_perfil_v,
  comentario,
  perfil
) AS
SELECT
COM.codigo_archivo,
COM.fecha_proceso,
COM.id_transaccion,
COM.id id_comentario,
COM.fecha_creacion,
USU.nombre nombre,
CRG.codigo_perfil_v codigo_perfil_V,
COM.comentario,
P.NOMBRE_LARGO   PERFIL
FROM
comentarios COM,
usuario  USU,
cargos CRG,
LISTA_VALORES P
WHERE
USU.CEDULA = COM.usuario_creacion AND
CRG.CODIGO_USUARIO = USU.CEDULA AND
P.CODIGO = CRG.CODIGO_PERFIL_V AND
P.TIPO_DATO = 10
/


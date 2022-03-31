PROMPT CREATE OR REPLACE VIEW v_reportes
CREATE OR REPLACE VIEW v_reportes (
  id_reporte,
  justificacion,
  ros,
  fecha,
  usuario,
  perfil
) AS
SELECT
REP.id ID_REPORTE,
REP.justificacion_inicial justificacion,
REP.ros_relacionado ROS,
REP.fecha_creacion FECHA,
USU.nombre_USUARIO usuario,
USU.codigo_perfil PERFIL
FROM
reporte REP,
v_usuarios USU
WHERE
REP.usuario_creacion = USU.CODIGO_USUARIO
/


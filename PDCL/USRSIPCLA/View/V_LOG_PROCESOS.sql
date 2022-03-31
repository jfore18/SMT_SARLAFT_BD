PROMPT CREATE OR REPLACE VIEW v_log_procesos
CREATE OR REPLACE VIEW v_log_procesos (
  proceso,
  tipo_proceso,
  id_proceso,
  inicio,
  fin,
  reportados,
  procesados,
  usuario,
  mensaje
) AS
select p.nombre_largo PROCESO,
p.codigo TIPO_PROCESO,
l.id_proceso ID_PROCESO,
fecha_hora_inicio INICIO,
fecha_hora_fin FIN,
nvl(registros_reportados,0) REPORTADOS,
l.registros_procesados PROCESADOS,
u.nombre USUARIO,
decode(l.codigo_mensaje,null, 'TERMINACION OK', m.descripcion) MENSAJE
from log_procesos l,
log_archivos a,
lista_valores p,
mensajes m,
usuario u
where
a.fecha_creacion(+) between l.fecha_hora_inicio and l.fecha_hora_fin and
p.tipo_dato = 20
and codigo_proceso = p.codigo
and m.codigo(+) = l.codigo_mensaje
and u.cedula(+) = l.usuario
/


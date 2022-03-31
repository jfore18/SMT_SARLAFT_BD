PROMPT CREATE OR REPLACE VIEW v_conceptos1
CREATE OR REPLACE VIEW v_conceptos1 (
  id,
  fecha_creacion,
  codigo_cargo,
  justificacion,
  usuario,
  perfil,
  codigo_perfil,
  clase_reporte,
  estado_reporte,
  codigo_region,
  tipo_identificacion,
  numero_identificacion,
  justificacion_inicial,
  codigo_unidad_negocio,
  region,
  is_megabanco
) AS
select r.id,
r.fecha_creacion,
r.codigo_cargo,
r.justificacion_inicial justificacion,
us.nombre usuario,
p.nombre_largo perfil,
p.codigo codigo_perfil,
cr.nombre_largo clase_reporte,
er.nombre_largo estado_reporte,
u.codigo_region_v codigo_region,
r.tipo_identificacion,
r.numero_identificacion,
r.justificacion_inicial,
u.codigo codigo_unidad_negocio,
reg.nombre_corto  region,
IS_MEGABANCO
from
reporte r,
usuario us,
lista_valores p,
lista_valores cr,
lista_valores er,
cargos c,
unidades_negocio u,
lista_valores reg
where
us.cedula = R.USUARIO_CREACION  and
c.codigo = r.codigo_cargo and
p.codigo = c.codigo_perfil_v and
p.tipo_dato = 10 and
cr.tipo_dato = 7 and
cr.codigo = r.codigo_clase_reporte_v and
er.tipo_dato = 9 and
er.codigo = r.codigo_estado_reporte_v and
u.codigo = c.codigo_unidad_negocio and
reg.tipo_dato = 3 and
reg.codigo = u.codigo_region_v
/


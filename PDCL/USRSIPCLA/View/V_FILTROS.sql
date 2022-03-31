PROMPT CREATE OR REPLACE VIEW v_filtros
CREATE OR REPLACE VIEW v_filtros (
  id,
  codigo_cargo,
  codigo_producto,
  numero_negocio,
  tipo_identificacion,
  numero_identificacion,
  nombre_cliente,
  condicion,
  valor_minimo,
  valor_maximo,
  operador,
  vigente_desde,
  vigente_hasta,
  confirmar,
  justificacion,
  usuario_creacion,
  fecha_creacion,
  nombre_usuario_creacion,
  rol,
  codigo_unidad_negocio,
  nombre_unidad_negocio,
  codigo_zona,
  nc_zona,
  codigo_region,
  nc_region,
  estado,
  descripcion_estado,
  nombre_usuario_supervisor,
  fecha_supervisor,
  concepto_supervisor
) AS
SELECT id
, codigo_cargo
, codigo_producto
, numero_negocio
, f.tipo_identificacion
, f.numero_identificacion
, NVL(cl.nombre_razon_social, 'SIN NOMBRE') NOMBRE_CLIENTE
, condicion
, DECODE (SUBSTR(condicion,1,1)
          ,'#', TO_NUMBER(REPLACE(SUBSTR(condicion,2,INSTR(condicion,',') -2),'.',','))
          ,'<', 0
          ,TO_NUMBER(SUBSTR(condicion,2,DECODE(INSTR(condicion,'.'),0, Length(condicion) - 1,INSTR(condicion,'.') -2)))
         )valor_minimo
, DECODE (SUBSTR(condicion,1,1)
          ,'#', TO_NUMBER(REPLACE(SUBSTR( condicion, INSTR(condicion,',') + 1 ),'.',','))
          ,'>',99999999999999999
          ,TO_NUMBER(SUBSTR(condicion,2,DECODE(INSTR(condicion,'.'),0, Length(condicion) - 1,INSTR(condicion,'.') -2)))
         ) valor_maximo
, SUBSTR(condicion,1,1) operador
, vigente_desde
, vigente_hasta
--, (CASE WHEN vigente_hasta IS NULL OR vigente_hasta >= SYSDATE THEN 1 ELSE 0 END ) activo
, confirmar
, justificacion
, f.usuario_creacion
, f.fecha_creacion
, NVL(u.nombre, 'SIN USUARIO') nombre_usuario_creacion
, c.codigo_perfil_v rol
, un.codigo codigo_unidad_negocio
, un.descripcion nombre_unidad_negocio
, z.codigo codigo_zona
, z.nombre_corto nc_zona
, reg.codigo codigo_region
, reg.nombre_corto nc_region
, f.estado_filtro estado
, decode(f.estado_filtro,'0','Pendiente','1','Aprobado','2','Inactivo','3','Rechazado')descripcion_estado
, u1.nombre nombre_usuario_supervisor
, f.fecha_supervisor
, f.concepto_supervisor
FROM filtros f
, usuario u
, clientes cl
, cargos c
, unidades_negocio un
, lista_valores reg
, zonas z
, usuario u1
WHERE c.codigo = f.codigo_cargo
AND u.cedula(+) = f.usuario_creacion
AND un.codigo = c.codigo_unidad_negocio
AND reg.tipo_dato = '3'
AND reg.codigo = un.codigo_region_v
AND z.codigo = un.codigo_zona
AND z.codigo_region_v = un.codigo_region_v
AND cl.tipo_identificacion(+) = f.tipo_identificacion
AND cl.numero_identificacion(+) = f.numero_identificacion
AND u1.cedula(+) = f.usuario_supervisor
/


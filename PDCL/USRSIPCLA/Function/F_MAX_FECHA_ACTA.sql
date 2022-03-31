PROMPT CREATE OR REPLACE FUNCTION f_max_fecha_acta
CREATE OR REPLACE FUNCTION f_max_fecha_acta (p_id_reporte in reporte.ID%TYPE) return DATE
AS
 fecha date;
begin
 SELECT MAX(fecha_acta)
 INTO fecha
 FROM detalle_analisis_rep
 WHERE id_reporte = p_id_reporte;

 return fecha;

END;
/


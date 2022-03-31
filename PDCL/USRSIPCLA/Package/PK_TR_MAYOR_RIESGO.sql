PROMPT CREATE OR REPLACE PACKAGE pk_tr_mayor_riesgo
CREATE OR REPLACE PACKAGE pk_tr_mayor_riesgo IS

   arr_tr_riesgosas Pk_Lib.tab_arreglo;

   PROCEDURE p_marcar_tr_mayor_riesgo (tr          IN OUT TRANSACCIONES_CLIENTE%ROWTYPE);
--                                       , valorTope IN     NUMBER);

   PROCEDURE p_cargar_arr_tr_riesgosas (codProducto ARCHIVOS.codigo_producto_v%TYPE);

END;
/


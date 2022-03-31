PROMPT CREATE OR REPLACE PACKAGE BODY pk_tr_mayor_riesgo
CREATE OR REPLACE PACKAGE BODY pk_tr_mayor_riesgo IS
/* Cambia el valor del campo MAYOR_RIESGO de la transacción suministrada como
parámetro, a 1 en caso de que cumpla con los criterios de mayor riesgo
definidos para el Analista del DUCC.
*/

/*******************************************************************************
* Modifica      : Mauricio Zuluaga
* Fecha         :    20/01/2010
* Descripcion   : Ajuste en la aplicación SMT-SARLAFT- Parámetro de topes
* Requerimiento : 9911
* Cambio        : Se cambia encabezado para recibir el tope por parametro
* *****************************************************************************/
PROCEDURE p_marcar_tr_mayor_riesgo (tr          IN OUT TRANSACCIONES_CLIENTE%ROWTYPE) IS
--PROCEDURE p_marcar_tr_mayor_riesgo (tr          IN OUT TRANSACCIONES_CLIENTE%ROWTYPE) IS
--                                    , valorTope IN     NUMBER) IS
-- Fin modificacion
  cliente_excluido BOOLEAN := FALSE;
  vigiladoSuper    CLIENTES.vigilado_superbancaria%TYPE;
  granContrib      CLIENTES.gran_contribuyente%TYPE;
  tipoEmpresa      CLIENTES.tipo_empresa%TYPE;

BEGIN
/* 2004-07-27 IMAM se busca en la tabla entidades si es vigilado superbancaria */
  BEGIN
    SELECT 1 INTO vigiladoSuper
    FROM ENTIDADES_EXCLUIDAS
    WHERE tipo_identificacion   = tr.tipo_identificacion
    AND numero_identificacion   = tr.numero_identificacion
    AND SUBSTR(FLAGS_TIPOS,1,1) = '1';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    vigiladoSuper := 0;
  END;
/* 2004/07/27 fin IMAM*/
--       SELECT gran_contribuyente, tipo_empresa, vigilado_superbancaria REM 2004/07/27 IMAM

/* 2007-02-01 Ingrid Alonso
Comentar cruce contra tabla de clientes, ya que por requerimiento de la DUCC
ningun cliente debe excluirse, así sea gran contribuyente u oficial
REM
SELECT gran_contribuyente, tipo_empresa
--         INTO granContrib, tipoEmpresa, vigiladoSuper REM 2004/07/27 IMAM
INTO granContrib, tipoEmpresa
FROM CLIENTES
WHERE tipo_identificacion = tr.tipo_identificacion
AND numero_identificacion = tr.numero_identificacion;
IF vigiladoSuper = 1 OR granContrib = 1 OR tipoEmpresa = 'O' THEN
cliente_excluido := TRUE;
END IF;
IF NOT cliente_excluido AND tr.no_criterios > 0
AND Pk_Lib.f_valor_existe_en_arreglo (tr.codigo_transaccion, arr_tr_riesgosas)
2007-02-01 Se cambia el if, ya que ahora sólo se verificará que el codigo de
transaccion sea de mayor riesgo y que por lo menos cumpla un criterio de inus.
*/

  IF tr.no_criterios > 0
    AND Pk_Lib.f_valor_existe_en_arreglo (tr.codigo_transaccion, arr_tr_riesgosas) THEN
    tr.mayor_riesgo := 1;
  END IF;
/*******************************************************************************
* Modifica      : Mauricio Zuluaga
* Fecha         :    20/01/2010
* Descripcion   : Ajuste en la aplicación SMT-SARLAFT- Parámetro de topes
* Requerimiento : 9911
* Cambio        : Se cambia el if para aceptar el tope por parametro
* *****************************************************************************/
--  IF tr.valor_transaccion >= 1000000000 THEN
--  IF tr.valor_transaccion >= valorTope THEN
-- fin modificacion
--    tr.mayor_riesgo := 1;
--  END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
  dbms_output.put_line('El cliente con identificación ' ||
  tr.tipo_identificacion || tr.numero_identificacion  ||
  'no existe en el maestro');
END p_marcar_tr_mayor_riesgo;

/* Carga en un arreglo global en memoria, los códigos de las transacciones
marcadas como de Mayor Riesgo en la tabla de transacciones.
*/

PROCEDURE p_cargar_arr_tr_riesgosas (codProducto ARCHIVOS.codigo_producto_v%TYPE) IS

  CURSOR cur_tr_riesgo IS
    SELECT codigo_transaccion
    FROM TIPOS_TRANSACCION
    WHERE mayor_riesgo    = 1
    AND codigo_producto_v = codProducto;

  i NUMBER := 1;

BEGIN
  FOR reg_tr_riesgo IN cur_tr_riesgo LOOP
    arr_tr_riesgosas(i) := reg_tr_riesgo.codigo_transaccion;
    i := i+1;
  END LOOP;
END p_cargar_arr_tr_riesgosas;

END;
/


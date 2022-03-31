PROMPT CREATE OR REPLACE PROCEDURE p_llenar_clientes
CREATE OR REPLACE PROCEDURE p_llenar_clientes IS

   CURSOR cur_transacciones IS
   SELECT tipo_identificacion, numero_identificacion, nombre_cliente
     FROM TRANSACCIONES_CLIENTE
    ORDER BY tipo_identificacion, numero_identificacion;

	id CLIENTES.numero_identificacion%TYPE;
BEGIN

   FOR reg_transaccion IN cur_transacciones LOOP

	   BEGIN

	      SELECT numero_identificacion
	        INTO id
		    FROM CLIENTES
		   WHERE tipo_identificacion = reg_transaccion.tipo_identificacion
		     AND numero_identificacion = reg_transaccion.numero_identificacion;

	   EXCEPTION WHEN NO_DATA_FOUND THEN

	      INSERT INTO CLIENTES (tipo_identificacion,
		  		 	  		    numero_identificacion,
								nombre_razon_social)
		                VALUES (reg_transaccion.tipo_identificacion,
						 	    reg_transaccion.numero_identificacion,
								reg_transaccion.nombre_cliente);
	   END;
	   COMMIT;
   END LOOP;

END;
/


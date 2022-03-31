PROMPT CREATE TABLE transacciones_rep
CREATE TABLE transacciones_rep (
  codigo_archivo        NUMBER(5,0)  NOT NULL,
  fecha_proceso         DATE         NOT NULL,
  id_transaccion        NUMBER(5,0)  NOT NULL,
  id_reporte            NUMBER(10,0) NOT NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL
)
  INITRANS   6
  STORAGE (
    INITIAL     144 K
  )
/


